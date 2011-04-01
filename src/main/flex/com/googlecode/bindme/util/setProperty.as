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

package com.googlecode.bindme.util {

/**
 * Sets the given property of the specified source object to the given value.
 *
 * @param object the object that hosts the property to be set.
 * @param properties array of individual properties in the property chain to set. Valid values
 * include:
 * <ul>
 * <li>A String containing the name of a <em>single</em> public bindable property of the host
 * object.  Dot-delimited properties (e.g. "foo.bar.baz") are <i>not</i> supported.</li>
 * <li>(excluding the last property) An object in the form: <br/>
 * <pre>
 * { name: <i>property name</i>,
 *   getter: function(target):* { <i>return property value</i> } }
 * </pre>
 * </li>
 * <li>(last property only) An object in the form: <br/>
 * <pre>
 * { name: <i>property name</i>,
 *   setter: function(target, value):void { <i>set target property to value</i> } }
 * </pre>
 * </li>
 * </ul>
 * @param value the value to set to the property.
 */
public function setProperty( object:Object,
                             properties:Array,
                             value:* ):void {
  var parentProperties:Array = properties.slice(0, properties.length - 1);
  var childProperty:Object = properties[properties.length - 1];

  var host:Object = getProperty(object, parentProperties);
  if (host != null) {
    if (childProperty is String) {
      host[childProperty] = value;
    }
    else {
      childProperty.setter(host, value);
    }
  }
}

}
