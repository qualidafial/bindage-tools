/*
 * The contents of this file are subject to the Mozilla Public License
 * Version 1.1 (the "License"); you may not use this file except in
 * compliance with the License. You may obtain a copy of the License at
 * http://www.mozilla.org/MPL/
 * 
 * Software distributed under the License is distributed on an "AS IS"
 * basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the
 * License for the specific language governing rights and limitations
 * under the License.
 * 
 * The Original Code is "BindMe Data Binding Framework for Flex ActionScript 3."
 * 
 * The Initial Developer of the Original Code is Overstock.com.
 * Portions created by Overstock.com are Copyright (C) 2011.
 * All Rights Reserved.
 * 
 * Contributor(s):
 * - Matthew Hall, Overstock.com <qualidafial@gmail.com> 
 */

package com.googlecode.bindme.impl {
import com.googlecode.bindme.*;
import com.googlecode.bindme.util.getProperty;

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
