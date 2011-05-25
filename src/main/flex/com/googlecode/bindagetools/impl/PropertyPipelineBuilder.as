/*
 * Copyright 2011 Overstock.com and others.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.googlecode.bindagetools.impl {
import com.googlecode.bindagetools.*;
import com.googlecode.bindagetools.util.getProperty;

import mx.binding.utils.ChangeWatcher;

/**
 * @private
 */
public class PropertyPipelineBuilder extends PipelineBuilder implements IPropertyPipelineBuilder {

  private var _source:Object;
  private var _properties:Array;

  public function get source():Object {
    return _source;
  }

  public function get properties():Array {
    return _properties.slice();
  }

  public function PropertyPipelineBuilder( source:Object,
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
