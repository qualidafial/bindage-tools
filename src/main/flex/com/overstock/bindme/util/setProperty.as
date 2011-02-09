package com.overstock.bindme.util {

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
