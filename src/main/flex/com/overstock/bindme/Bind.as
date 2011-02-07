package com.overstock.bindme {
import com.overstock.bindme.impl.PropertyPipeline;

import mx.binding.utils.ChangeWatcher;

public class Bind {
  private static var collected:Array;

  public static function collect( func:Function ):Array {
    var oldCollected:Array = collected;
    collected = [];

    var result:Array;
    try {
      func();
      result = collected;
    } finally {
      collected = oldCollected;
    }

    return result;
  }

  public static function changeWatcherCreated(changeWatcher:ChangeWatcher):void {
    if (collected != null) {
      collected.push(changeWatcher);
    }
  }

  public static function fromProperty( source:Object,
                                       property:String ):IPropertyPipeline {
    if (null == source) {
      throw new ArgumentError("source was null");
    }

    if (null == property) {
      throw new ArgumentError("property was null");
    }

    return new PropertyPipeline(source, property);
  }

  public static function twoWay( source:IPipeline,
                                 target:IPipeline ):void {

    var sourceSetter:Function = IPropertyPipeline(source).sourceSetter();
    var targetSetter:Function = IPropertyPipeline(target).sourceSetter()

    var running:Boolean = false;

    function guardedSourceSetter( value:* ):void {
      if (!running) {
        try {
          running = true;
          sourceSetter(value);
        } finally {
          running = false;
        }
      }
    }

    function guardedTargetSetter( value:* ):void {
      if (!running) {
        try {
          running = true;
          targetSetter(value);
        } finally {
          running = false;
        }
      }
    }

    source.toFunction(guardedTargetSetter);

    try {
      running = true;
      target.toFunction(guardedSourceSetter);
    }
    finally {
      running = false;
    }
  }
}

}
