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

package com.googlecode.bindagetools.util {

/**
 * Returns the current value of given property of the specified source object.
 *
 * @param host the host object
 * @param properties array of individual properties in the property chain to retrieve. Valid
 * values include:
 * <ul>
 * <li>A String containing the name of a <em>single</em> public bindable property of the host
 * object. Dot-delimited properties (e.g. "foo.bar.baz") are <i>not</i> supported.</li>
 * <li>An Object in the form:<br/>
 * <pre>
 * { name: <i>property name</i>,
 *   getter: function(host):* { <i>return property value</i> } }
 * </pre>
 * </li>
 * </ul>
 * @return the value of the given property chain on the specified source object.
 */
public function getProperty( host:Object,
                             properties:Array ):Object {
  var result:Object = host;
  for each (var property:Object in properties) {
    if (property is String) {
      result = result[property as String];
    }
    else {
      result = property.getter(result);
    }

    if (result == null) {
      break;
    }
  }
  return result;
}

}
