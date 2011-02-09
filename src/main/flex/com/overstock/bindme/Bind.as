package com.overstock.bindme {
import com.overstock.bindme.impl.MultiPipeline;
import com.overstock.bindme.impl.PropertyPipeline;
import com.overstock.bindme.util.setProperty;
import com.overstock.bindme.util.applyArgs;

import mx.binding.utils.ChangeWatcher;

/**
 * A factory for creating binding pipelines between arbitrary <code>[Bindable]</code> properties.
 */
public class Bind {
  private static var collected:Array;

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
   * @param rest the arguments to pass to the specified function
   */
  public static function collect( func:Function,
                                  ...rest ):Array {
    var oldCollected:Array = Bind.collected;

    Bind.collected = [];

    var result:Array;
    try {
      func.apply(null, rest);
      result = Bind.collected;
    } finally {
      Bind.collected = oldCollected == null
          ? null
          : oldCollected.concat(Bind.collected);
    }

    return result;
  }

  /**
   * Called internally whenever a binding pipeline creates a ChangeWatcher.
   * @param changeWatcher the change watcher that was created.
   * @see com.overstock.bindme.IPipeline.watch
   */
  public static function changeWatcherCreated( changeWatcher:ChangeWatcher ):void {
    if (Bind.collected != null) {
      Bind.collected.push(changeWatcher);
    }
  }

  /**
   * Creates and returns a new binding pipeline, starting with the specified property of the
   * specified source object.
   *
   * @param source the object that hosts the property to be watched.
   * @param properties one or more objects specifying the property to be watched on the source
   * object.  Valid values include:
   * <ul>
   * <li>A String containing name(s) of a public bindable property of the source object.  Nested
   * properties may be expressed using dot notation e.g. "foo.bar.baz"</li>
   * <li>An Object in the form:<br/>
   * <pre>
   * { name: <i>property name</i>,
   *   getter: function(source):* { <i>return property value</i> } }
   * </pre>
   * </li>
   * </ul>
   * @return the new binding pipeline.
   * @throws ArgumentError if source is null, or if any element of properties is null or not a
   * valid value.
   */
  public static function fromProperty( source:Object,
                                       ... properties ):IPropertyPipeline {
    return new PropertyPipeline(source, properties);
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
   *       Bind.fromProperty(normalPriceInput, "text")
   *           .validate(isNumber())
   *           .convert(toNumber)
   *           .validate(greaterThan(0)),
   *       Bind.fromProperty(discountPriceInput, "text")
   *           .validate(isNumber())
   *           .convert(toNumber)
   *       )
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
  public static function fromAll( ... pipelines ):IPipeline {
    return new MultiPipeline(pipelines);
  }

  /**
   * Creates a two-way binding between the specified source and target binding pipelines.
   *
   * @param source the source pipeline from which the target will be initially populated.
   * @param target the target pipeline which will be initially populated from the source
   * @param group a semaphore for ensuring the two binding pipelines never execute at the same
   * time.  Lock objects help prevent stack overflows and crosstalk between bindings by
   * preventing more than one binding in a group from executing at the same time.  If omitted,
   * a Lock object will be provided automatically.
   * @throws ArgumentError if either source or target is not an IPropertyPipeline instance.
   */
  public static function twoWay( source:IPipeline,
                                 target:IPipeline,
                                 group:BindGroup = null ):void {
    if (!(source is IPropertyPipeline)) {
      throw new ArgumentError("Source pipeline must originate from a single property");
    }
    if (!(target is IPropertyPipeline)) {
      throw new ArgumentError("Target pipeline must originate from a single property");
    }

    var sourcePipeline:IPropertyPipeline = IPropertyPipeline(source);
    var targetPipeline:IPropertyPipeline = IPropertyPipeline(target);

    var sourceSetter:Function = applyArgs(setProperty,
                                          sourcePipeline.source,
                                          sourcePipeline.properties);
    var targetSetter:Function = applyArgs(setProperty,
                                          targetPipeline.source,
                                          targetPipeline.properties);

    if (group == null) {
      group = new BindGroup();
    }

    var sourceToTargetRunner:Function = applyArgs(group.callExclusively,
                                                  source.runner(targetSetter));
    var targetToSourceRunner:Function = applyArgs(group.callExclusively,
                                                  target.runner(sourceSetter));

    source.watch(sourceToTargetRunner);
    target.watch(targetToSourceRunner);

    sourceToTargetRunner();
  }
}

}
