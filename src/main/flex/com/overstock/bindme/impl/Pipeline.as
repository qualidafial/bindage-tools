package com.overstock.bindme.impl {
import com.overstock.bindme.IPipeline;
import com.overstock.bindme.IPipelineStep;

import flash.events.Event;

import org.hamcrest.Matcher;

public class Pipeline implements IPipeline {
  private var steps:Array;

  public function Pipeline() {
    steps = []
  }

  protected static function toChain( property:String ):Array {
    return property.split(".");
  }

  public function append( step:IPipelineStep ):IPipeline {
    steps.push(step);
    return this;
  }

  public function convert( converter:Function ):IPipeline {
    return append(new ConvertStep(converter));
  }

  public function validate( condition:Matcher ):IPipeline {
    return append(new ValidateStep(condition));
  }

  public function toProperty( target:Object,
                              property:String ):IPipeline {
    var setter:Function = propertySetter(target, property);
    return toFunction(setter);
  }

  protected function propertySetter( target:Object,
                                     property:String ):Function {
    var propertyChain:Array = toChain(property);
    var parentProperties:Array = propertyChain.slice(0, propertyChain.length - 1);
    var leafProperty:String = propertyChain[propertyChain.length - 1];
    return function( value:* ):void {
      var host:Object = getProperty(target, parentProperties);
      if (host != null) {
        host[leafProperty] = value;
      }
    }
  }

  protected function getProperty( source:Object,
                                  propertyChain:Array ):Object {
    var result:Object = source;
    for each (var parentProperty:String in propertyChain) {
      result = result[parentProperty];
      if (result == null) {
        break;
      }
    }
    return result;
  }

  public function toFunction( func:Function ):IPipeline {
    var runner:Function = runner(func);

    function handler( event:Event ):void {
      runner();
    }

    watch(handler);

    handler(null);

    return this;
  }

  public function runner( func:Function ):Function {
    var pipeline:Function = buildPipeline(func);

    var runner:Function = pipelineRunner(pipeline);

    return runner;
  }

  private function buildPipeline( func:Function ):Function {
    var pipeline:Function = func;

    for (var i:int = steps.length - 1; i >= 0; i--) {
      var step:IPipelineStep = steps[i];
      pipeline = step.wrapStep(pipeline);
    }

    pipeline = preventRecursion(pipeline);

    return pipeline;
  }

  private static function preventRecursion( pipeline:Function ):Function {
    var running:Boolean = false;
    var guardRecurse:Function = function( ...values ):void {
      if (!running) {
        try {
          running = true;
          pipeline.apply(null, values);
        } finally {
          running = false;
        }
      }
    }
    return guardRecurse;
  }

  protected function pipelineRunner( pipeline:Function ):Function {
    throw new Error("abstract methods");
  }

  public function watch( runner:Function ):void {
    throw new Error("abstract methods");
  }

}

}
