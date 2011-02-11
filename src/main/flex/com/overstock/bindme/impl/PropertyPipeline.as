package com.overstock.bindme.impl {
import com.overstock.bindme.*;
import com.overstock.bindme.util.getProperty;

import mx.binding.utils.ChangeWatcher;

public class PropertyPipeline extends Pipeline implements IPropertyPipeline {

  private var _source:Object;
  private var _properties:Array;

  public function get source():Object {
    return _source;
  }

  public function get properties():Array {
    return _properties.slice();
  }

  public function PropertyPipeline( source:Object,
                                    properties:Array ) {
    if (null == source) {
      throw new ArgumentError("source was null");
    }

    if (null == properties) {
      throw new ArgumentError("properties was null");
    }

    if (properties.length == 0) {
      throw new ArgumentError("properties was empty");
    }

    checkCustomGetterProperties(properties);

    var normalizedProperties:Array = normalizeProperties(properties);

    this._source = source;
    this._properties = normalizedProperties;
  }

  override protected function pipelineRunner( pipeline:Function ):Function {
    return function():void {
      var value:Object = getProperty(_source, _properties);
      pipeline(value);
    };
  }

  override public function watch( runner:Function ):void {
    var watcher:ChangeWatcher = ChangeWatcher.watch(_source,
                                                    _properties,
                                                    runner);
    BindTracker.changeWatcherCreated(watcher);
  }

}

}
