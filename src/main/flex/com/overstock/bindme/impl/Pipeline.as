package com.overstock.bindme.impl {
import com.overstock.bindme.BindGroup;
import com.overstock.bindme.IPipeline;
import com.overstock.bindme.IPipelineStep;
import com.overstock.bindme.util.applyArgs;
import com.overstock.bindme.util.preventRecursion;
import com.overstock.bindme.util.setProperty;

import flash.events.Event;

public class Pipeline implements IPipeline {
  private var groups:Array;
  private var steps:Array;

  public function Pipeline() {
    groups = [];
    steps = [];
  }

  public function append( step:IPipelineStep ):IPipeline {
    steps.push(step);
    return this;
  }

  public function convert( converter:Function ):IPipeline {
    return append(new ConvertStep(converter));
  }

  public function delay( delayMillis:int ):IPipeline {
    return append(new DelayStep(delayMillis));
  }

  public function format( format:String ):IPipeline {
    return append(new FormatStep(format));
  }

  public function group( group:BindGroup ):IPipeline {
    groups.push(group);
    return this;
  }

  public function log( level:int,
                       message:String ):IPipeline {
    return append(new LogStep(level, message));
  }

  public function validate( ...condition ):IPipeline {
    return append(new ValidateStep(condition));
  }

  public function toProperty( target:Object,
                              ...properties:Array ):IPipeline {
    if (null == target) {
      throw new ArgumentError("target was null");
    }

    if (null == properties) {
      throw new ArgumentError("properties was null");
    }

    if (properties.length == 0) {
      throw new ArgumentError("properties was empty");
    }

    checkCustomGetterProperties(properties.slice(0, properties.length - 1));
    checkCustomSetterProperty(properties[properties.length - 1]);

    var normalizedProperties:* = normalizeProperties(properties);

    var setter:Function = applyArgs(setProperty, target, normalizedProperties);

    return toFunction(setter);
  }

  protected static function checkCustomGetterProperties( properties:Array ):void {
    for each (var property:Object in properties) {
      checkCustomGetterProperty(property);
    }
  }

  private static function checkCustomGetterProperty( property:Object ):void {
    checkNullProperty(property);
    if (!(property is String)) {
      requireOwnProperty(property, "name", String);
      requireOwnProperty(property, "getter", Function);
    }
  }

  private static function checkCustomSetterProperty( property:Object ):void {
    checkNullProperty(property);
    if (!(property is String)) {
      requireOwnProperty(property, "name", String);
      requireOwnProperty(property, "setter", Function);
    }
  }

  private static function checkNullProperty( property:Object ):void {
    if (property == null) {
      throw new ArgumentError("property was null");
    }
  }

  protected static function requireOwnProperty( property:Object,
                                                name:String,
                                                type:Class ):void {
    if (!property.hasOwnProperty(name)) {
      throw new ArgumentError("Custom property missing attribute '" + name + "'.");
    }

    if (!(property[name] is type)) {
      throw new ArgumentError("Custom property attribute '" +
                              name + "' should be of type " + "'" + type + "'")
    }
  }

  protected function normalizeProperties( properties:Array ):Array {
    var result:Array = [];
    for each (var property:Object in properties) {
      if (property is String) {
        for each (var prop:String in String(property).split(".")) {
          result.push(prop);
        }
      }
      else if (property.hasOwnProperty("name")) {
        result.push(property);
      }
    }
    return result;
  }

  public function toFunction( func:Function ):IPipeline {
    var pipelineRunner:Function = runner(func);
    pipelineRunner = preventRecursion(pipelineRunner);

    function handler( event:Event ):void {
      pipelineRunner();
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

      if (step is DelayStep) {
        // We exited the groups when the delay started.  Wrap the pipeline in each group to
        // ensure we don't get round-robin bindings.
        pipeline = wrapPipelineInGroups(pipeline);
      }

      pipeline = step.wrapStep(pipeline);
    }

    pipeline = wrapPipelineInGroups(pipeline);

    return pipeline;
  }

  private function wrapPipelineInGroups( pipeline:Function ):Function {
    var result:Function = pipeline;
    for each (var group:BindGroup in groups) {
      result = applyArgs(group.callExclusively, result);
    }
    return result;
  }

  protected function pipelineRunner( pipeline:Function ):Function {
    throw new Error("abstract methods");
  }

  public function watch( runner:Function ):void {
    throw new Error("abstract methods");
  }

}

}
