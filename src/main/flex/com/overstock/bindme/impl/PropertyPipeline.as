package com.overstock.bindme.impl {
import com.overstock.bindme.*;

import mx.binding.utils.BindingUtils;
import mx.binding.utils.ChangeWatcher;

import org.hamcrest.Matcher;

public class PropertyPipeline implements IPropertyPipeline {

  private var source:Object;
  private var property:String;

  private var steps:Array = [];

  public function sourceSetter():Function {
    return propertySetter(source, property);
  }

  public function PropertyPipeline( source:Object,
                                    property:String ) {
    this.source = source;
    this.property = property;
  }

  private static function toChain( property:String ):Array {
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

  public function propertySetter( target:Object,
                                  property:String ):Function {
    var propertyChain:Array = toChain(property);
    var parentProperties:Array = propertyChain.slice(0, propertyChain.length - 1);
    var leafProperty:String = propertyChain[propertyChain.length - 1];
    return function( value:* ):void {
      var host:Object = target;
      for each (var parentProperty:String in parentProperties) {
        host = host[parentProperty];
        if (host == null) {
          break;
        }
      }

      if (host != null) {
        host[leafProperty] = value;
      }
    }
  }

  public function toFunction( func:Function ):IPipeline {
    var pipeline:Function = buildPipeline(func);

    var changeWatcher:ChangeWatcher = BindingUtils.bindSetter(pipeline,
                                                              this.source,
                                                              toChain(this.property));

    Bind.changeWatcherCreated(changeWatcher);

    return this;
  }

  private function buildPipeline( endPoint:Function ):Function {
    var pipeline:Function = endPoint;

    for (var i:int = steps.length - 1; i >= 0; i--) {
      var step:IPipelineStep = steps[i];
      pipeline = step.wrapStep(pipeline);
    }

    pipeline = preventRecursion(pipeline);

    return pipeline;
  }

  private static function preventRecursion( pipeline:Function ):Function {
    var running:Boolean = false;
    var guardRecurse:Function = function( value:* ):void {
      if (!running) {
        try {
          running = true;
          pipeline(value);
        } finally {
          running = false;
        }
      }
    }
    return guardRecurse;
  }

}

}
