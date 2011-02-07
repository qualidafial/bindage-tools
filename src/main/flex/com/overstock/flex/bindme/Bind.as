package com.overstock.flex.bindme {
import com.overstock.flex.bindme.util.applyArgs;

import mx.binding.utils.BindingUtils;
import mx.binding.utils.ChangeWatcher;
import mx.logging.ILogger;
import mx.logging.Log;
import mx.logging.LogEventLevel;
import mx.utils.StringUtil;

/**
 * A factory for creating binding pipelines between arbitrary <code>[Bindable]</code> properties.
 */
public class Bind {

  private static const logger:ILogger =
      Log.getLogger("com.overstock.merch.offerprocess.util.bind.Bind");

  private static var collected:Array;

  private var object:Object = null;

  private var property:Property = null;

  private var sources:Array = null; // of Bind

  /**
   * An array of function(setter:Function):Function.
   * <p>
   * Each function in the array accepts a setter function, and returns a wrapper around that
   * setter which implements a specific step in the binding pipeline, e.g. validation, conversion,
   * etc.
   * </p>
   */
  private var pipeline:Array = [];

  /**
   * Executes the specified function, then returns an array of all ChangeWatchers created by the
   * Bind class in the course of the function's execution.
   *
   * <p>
   * Clients which use this method can destroy any of the created bindings by calling
   * <code>reset()</code> on the corresponding ChangeWatcher.
   * </p>
   *
   * @param func the function to execute and collect bindings from
   * @param args the arguments to pass to the specified function
   */
  public static function collect( func:Function,
                                  ... args ):Array {
    var oldCollected:Array = Bind.collected;

    Bind.collected = [];
    var result:Array = null;
    try {
      func.apply(null, args);
      result = Bind.collected;
    }
    finally {
      Bind.collected = oldCollected
          ? oldCollected.concat(Bind.collected)
          : null;
    }

    return result;
  }

  /**
   * Creates a two-way binding between the specified source and target binding pipelines.
   *
   * @param source the source Bind from which the target will be initially populated.
   * @param target the target binding which will be initially populated from the source
   * @param lock a semaphore for ensuring the two binding pipelines never execute at the same
   *        time.  Lock objects help prevent stack overflows and crosstalk between bindings by
   *        preventing more than one binding in a group from executing at the same time.  If
   *        omitted, a Lock object will be provided automatically.
   * @param logLevel a log level constant from mx.logging.LogEventLevel.  This value is used as
   *        the log level for the setter function at both ends of the two-way binding.  If
   *        omitted, LogEventLevel.DEBUG is used.
   * @throws ArgumentError if either source or target is null
   */
  public static function twoWay( source:Bind,
                                 target:Bind,
                                 lock:Group = null,
                                 logLevel:int = 2
                                 /* debug */ ):void {
    if (source == null) {
      throw new ArgumentError("source argument was null");
    }

    if (target == null) {
      throw new ArgumentError("target argument was null");
    }

    if (lock == null) {
      lock = new Group();
    }

    source.group(lock);
    target.group(lock);

    source.to(target.object, target.property, logLevel);

    // We may fail to acquire the lock (e.g. if the lock argument was non-null). That's okay, the
    // important thing is to make sure the lock is already taken, so the target-to-source binding
    // pipeline can't execute initially.
    var locked:Boolean = lock.acquire();

    try {
      target.to(source.object, source.property, logLevel)
    }
    finally {
      // Only release the lock if we acquired it.
      if (locked) {
        lock.release();
      }
    }
  }

  /**
   * Creates and returns a new binding pipeline, starting with the values from each of the
   * specified source pipelines.
   *
   * <p>
   * Example:
   * </p>
   * <pre>
   *   Bind.fromAll(
   *           Bind.from(normalPriceInput, 'text')
   *               .validate(Validators.stringToNumber)
   *               .convert(Converters.stringToNumber)
   *               .validate(Validators.notEqual(0),
   *           Bind.from(discountPriceInput, 'text')
   *               .validate(Validators.stringToNumber)
   *               .convert(Converters.stringToNumber)
   *           )
   *       .convert(function(normalPrice:Number, discountPrice:Number):String {
   *             return (100 * (normalPrice - discountPrice) / normalPrice) + '%';
   *           })
   *       .to(discountPercentText, 'text');
   * </pre>
   *
   * <p>
   * Note that the custom converter function takes two arguments.  This is because there are two
   * bindings pipelines specified as sources in the <code>Bind.fromAll</code> call.  The values
   * from each source pipeline are passed as arguments to the steps in the binding pipelines, in
   * the same order as they are specified in the <code>fromAll</code> call.  If the master pipeline
   * has a <code>convert()</code> step, then all arguments are combined into a single value.
   * Otherwise, all values continue to be passed to each step including the final property setter
   * or setter function.
   * </p>
   *
   * @param sources an array of Bind instances.
   */
  public static function fromAll( ... sources ):Bind {
    for each (var source:Bind in sources) {
      if (source == null) {
        throw new ArgumentError("one or more sources was null");
      }
    }

    var result:Bind = new Bind();
    result.sources = sources;

    return result;
  }

  /**
   * Creates and returns a new binding pipeline, starting with the specified property of the
   * specified source object.
   *
   * @param object the object that hosts the property to be watched.
   * @param property an object specifying the property to be watched on the source object.  Must
   *        be either a Property instance, or a String suitable for passing to
   *        Property.make(String).  Property names may be nested e.g. "foo.bar.baz".
   * @return a Bind object representing the new binding pipeline.
   * @throws ArgumentError if either source or property is null, or if property is not a valid
   *         Property or String instance.
   */
  public static function from( object:Object,
                               property:Object ):Bind {
    if (object == null) {
      throw new ArgumentError("source object was null");
    }

    var result:Bind = new Bind();
    result.object = object;
    result.property = toProperty(property);

    return result;
  }

  function Bind() {
  }

  private static function toProperty( property:Object ):Property {
    if (property == null) {
      throw new ArgumentError("property argument was null");
    }
    else if (property is Property) {
      return Property(property);
    }
    else if (property is String) {
      return Property.make(String(property));
    }
    else {
      throw new ArgumentError("Unexpected property type: " + property);
    }
  }

  /**
   * Adds a step ensuring that this binding pipeline does not execute concurrently with any other
   *  binding in the same group.  A single binding can belong to multiple groups.
   *
   * @param group the group the binding should be added to.
   * @return this Bind instance for method chaining.
   * @throws ArgumentError if the lock argument is null.
   */
  public function group( group:Group ):Bind {
    if (group == null) {
      throw new ArgumentError("group object was null");
    }

    pipeline.push(function( setter:Function ):Function {
      return applyArgs(group.acquireAndRun, setter);
    });

    return this;
  }

  /**
   * Appends a logging step to the end of the binding pipeline.  The given message is sent to the
   * Bind class's logger before sending the current value to the next step in the pipeline.
   *
   * @param logLevel log level constant defined in mx.logging.LogEventLevel
   * @param message the message to be logged.  The log message may be parameterized as follows:
   *        <code>{0}</code> - the current value in the binding pipeline i.e. the value being set
   *        on the target
   * @return this Bind instance for method chaining.
   * @throws ArgumentError if the message argument is null.
   */
  public function log( logLevel:int,
                       message:String ):Bind {
    if (message == null) {
      throw new ArgumentError("log message was null");
    }

    pipeline.push(function( setter:Function ):Function {
      return function( ... values ):void {
        logger.log.apply(null, [ logLevel, message ].concat(values));
        setter.apply(null, values);
      };
    });

    return this;
  }

  /**
   * Convenience method for <code>log(LogEventLevel.DEBUG, message)</code>
   */
  public function logDebug( message:String ):Bind {
    return log(LogEventLevel.DEBUG, message);
  }

  /**
   * Convenience method for <code>log(LogEventLevel.INFO, message)</code>
   */
  public function logInfo( message:String ):Bind {
    return log(LogEventLevel.INFO, message);
  }

  /**
   * Convenience method for <code>log(LogEventLevel.WARN, message)</code>
   */
  public function logWarn( message:String ):Bind {
    return log(LogEventLevel.WARN, message);
  }

  /**
   * Convenience method for <code>log(LogEventLevel.ERROR, message)</code>
   */
  public function logError( message:String ):Bind {
    return log(LogEventLevel.ERROR, message);
  }

  /**
   * Convenience method for <code>log(LogEventLevel.FATAL, message)</code>
   */
  public function logFatal( message:String ):Bind {
    return log(LogEventLevel.FATAL, message);
  }

  /**
   * Appends a validation step to the end of the binding pipeline.  The current value(s) are be
   * passed to the validator function.  If the validator returns true then the pipeline proceeds on
   * to the next step with the same value(s).  Otherwise the pipeline aborts.
   *
   * @param validator a function which accepts the current value(s) in the binding pipeline, and
   *        returns a Boolean (or some object which can be coerced into a Boolean) identifying
   *        whether the value(s) are valid.
   * @return this Bind instance for method chaining.
   * @throws ArgumentError if the validator argument is null
   */
  public function validate( validator:Function ):Bind {
    if (validator == null) {
      throw new ArgumentError("validator function was null");
    }

    pipeline.push(function( setter:Function ):Function {
      return function( ... values ):void {
        var valid:Boolean = validator.apply(null, values);
        if (valid) {
          setter.apply(null, values);
        }
      };
    });

    return this;
  }

  /**
   * Appends a conversion step to the end of the binding pipeline.  During this step, the current
   * value(s) are passed to the converter function, and the value returned from the converter will
   * be sent to next step in the pipeline.
   *
   * <p>
   * If this is a <code>fromAll</code> pipeline, all the values in the pipeline are passed to the
   * converter function in a single call, as successive arguments.  If you are trying to convert
   * each argument individually, use <code>map(Function)</code> instead.
   * </p>
   *
   * @param converter a function which accepts the value(s) in the binding pipeline, and returns
   *        the converted value.
   * @return this Bind instance for method chaining.
   * @throws ArgumentError if the converter argument is null
   */
  public function convert( converter:Function ):Bind {
    if (converter == null) {
      throw new ArgumentError("converter function was null");
    }

    pipeline.push(function( setter:Function ):Function {
      return function( ... values ):void {
        var convertedValue:* = converter.apply(null, values);
        setter(convertedValue);
      };
    });

    return this;
  }

  /**
   * Appends a formatting step to the end of the binding pipeline.  During this step, the current
   * value(s) are interpolated into the specified format string, and the resulting string is sent
   * to the next step in the pipeline.
   *
   * <p>
   * Example:
   * </p>
   *
   * <pre>
   *   person.name = "John"; // {0}
   *   Bind.from(person, "name")
   *       .format("Welcome, {0}!")
   *       .to(greetingLabel, "text"); // "Welcome, John!"
   * </pre>
   *
   * <p>
   * In a <code>Bind.fromAll()</code> scenario, the first <code>Bind.from()</code> declared
   * will be represented by <code>{0}</code>, the second by <code>{1}</code>,
   * and so on:
   * </p>
   *
   * <pre>
   *   person.firstName = "Me"
   *   person.lastName = "Hearty"
   *   Bind.fromAll(
   *       Bind.from(person, "firstName"), // {0}
   *       Bind.from(person, "lastName")   // {1}
   *       )
   *       .format("Ahoy, {0} {1}!", greetingString)
   *       .to(greetingLabel, "text"); // "Ahoy, Me Hearty!"
   * </pre>
   */
  public function format( formatString:String ):Bind {
    if (formatString == null) {
      throw new ArgumentError("formatString was null");
    }

    pipeline.push(function( setter:Function ):Function {
      return function( ... values ):void {
        var formattedString:String = StringUtil.substitute(formatString, values);
        setter(formattedString);
      };
    });

    return this;
  }

  /**
   * Appends a per-argument conversion step to the end of the binding pipeline.  During this step,
   * each value in the pipeline is passed in turn to the converter function.  The converted values
   * are then sent to the next step in the pipeline.
   *
   * <p>
   * If this is a <code>fromAll</code> pipeline, each value is passed to the converter function in a
   * separate invocation.  If you are trying to combine multiple arguments into a single value, use
   * <code>convert(Function)</code> instead.
   * </p>
   *
   * @param converter a function which accepts a single value in the binding pipeline, and returns
   *        the converted value.
   * @return this Bind instance for method chaining.
   * @throws ArgumentError if the converter argument is null
   */
  public function map( converter:Function ):Bind {
    if (converter == null) {
      throw new ArgumentError("converter function was null");
    }

    pipeline.push(function( setter:Function ):Function {
      return function( ... values ):void {
        var convertedValues:* = values.map(converter)
        setter.apply(null, convertedValues);
      }
    });

    return this;
  }

  /**
   * Concludes the binding pipeline by setting the current value(s) in the pipeline to the
   * specified property of the specified target object.
   *
   * @param object the target object that hosts the property to be set.
   * @param property an object specifying the property to be set on the target object.  Must
   *        be either a Property instance, or a String suitable for passing to
   *        Property.make(String).  Property names may be nested e.g. "foo.bar.baz".
   * @return this Bind instance for method chaining.
   * @throws ArgumentError if either object or property is null, or if property is not a valid
   *         Property or String instance.
   */
  public function to( object:Object,
                      property:Object,
                      logLevel:int = 2
                      /* debug */ ):Bind {
    if (object == null) {
      throw new ArgumentError("target object was null");
    }

    var targetProperty:Property = toProperty(property);
    targetProperty.logLevel = Math.max(targetProperty.logLevel, logLevel);

    var setter:Function = applyArgs(targetProperty.setValue, object);

    return toSetter(setter);
  }

  /**
   * Concludes the binding pipeline by passing the current value(s) in the pipeline to the
   * specified setter function.
   *
   * @param setter a function which accepts the current value(s) in the pipeline
   * @return this Bind instance for method chaining.
   * @throws ArgumentError if the setter argument is null
   */
  public function toSetter( setter:Function ):Bind {
    if (setter == null) {
      throw new ArgumentError("setter function was null");
    }

    var pipeline:Function = buildPipeline(setter);
    toPipeline(pipeline);

    return this;
  }

  private function buildPipeline( setter:Function ):Function {
    var result:Function = setter;

    // Last In First Out - The innermost wrapper around the setter will be the last step in the
    // binding pipeline before the setter is invoked.  So we iterate the array in reverse order
    // such that the first step becomes the outermost wrapper around the setter, and therefore
    // the first step to be invoked in the pipeline.
    for (var i:int = pipeline.length - 1; i >= 0; i--) {
      var step:Function = pipeline[i] as Function;
      result = step(result);
    }
    return result;
  }

  private function toPipeline( pipeline:Function ):void {
    if (sources != null) {
      multipleSourcesToSetter(pipeline);
    }
    else {
      singleSourceToSetter(pipeline);
    }
  }

  private function multipleSourcesToSetter( pipeline:Function ):void {
    var args:Array = new Array(sources.length);

    var groupLock:Group = new Group();

    var finalStep:Function = function():void {
      pipeline.apply(null, args);
    };

    for (var i:int = 0; i < sources.length; i++) {
      var nextStep:Function = finalStep;

      for (var j:int = sources.length - 1; j >= 0; j--) {
        if (i != j) {
          var argSetter:Function = wrapNextStepInArgumentSetter(argSetter(args, j), nextStep);
          var stepSetter:Function = sources[j].buildPipeline(argSetter);
          nextStep = wrapSetterInNextStep(sources[j], stepSetter);
        }
      }

      var setter:Function = wrapNextStepInArgumentSetter(argSetter(args, i), nextStep);
      var setterPipeline:Function = sources[i].buildPipeline(setter);
      var lockedPipeline:Function = applyArgs(groupLock.acquireAndRun, setterPipeline);

      if (i == 0) {
        sources[i].toPipeline(lockedPipeline);
      }
      else {
        groupLock.acquireAndRun(sources[i].toPipeline, lockedPipeline);
      }
    }
  }

  private function wrapNextStepInArgumentSetter( setArgument:Function,
                                                 nextStep:Function ):Function {
    return function( value:* ):void {
      setArgument(value);
      nextStep();
    };
  }

  private function argSetter( args:Array,
                              index:int ):Function {
    return function( value:* ):void {
      args[index] = value;
    }
  }

  private function wrapSetterInNextStep( source:Bind,
                                         setter:Function ):Function {
    return function():void {
      var value:* = source.property.getValue(source.object);
      setter(value);
    }
  }

  private function singleSourceToSetter( pipeline:Function ):void {
    var changeWatcher:ChangeWatcher = BindingUtils.bindSetter(pipeline, object, property.toArray());

    if (Bind.collected) {
      Bind.collected.push(changeWatcher);
    }
  }

}

}