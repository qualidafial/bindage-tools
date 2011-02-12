package com.overstock.bindme.util {

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
