package com.overstock.bindme.impl {
import com.overstock.bindme.*;

import mx.binding.utils.ChangeWatcher;

import org.hamcrest.Matcher;
import org.hamcrest.collection.array;

public class PropertyPipeline extends Pipeline implements IPropertyPipeline {

  private var source:Object;
  private var property:String;

  public function PropertyPipeline( source:Object,
                                    property:String ) {
    if (null == source) {
      throw new ArgumentError("source was null");
    }

    if (null == property) {
      throw new ArgumentError("property was null");
    }

    this.source = source;
    this.property = property;
  }

  override public function validate( condition:Matcher ):IPipeline {
    return super.validate(array(condition));
  }

  override protected function pipelineRunner( pipeline:Function ):Function {
    return function():void {
      var value:Object = getProperty(source, toChain(property));
      pipeline(value);
    };
  }

  override public function watch( runner:Function ):void {
    var watcher:ChangeWatcher = ChangeWatcher.watch(source, toChain(property), runner);
    Bind.changeWatcherCreated(watcher);
  }

  public function sourceSetter():Function {
    return propertySetter(source, property);
  }

}

}
