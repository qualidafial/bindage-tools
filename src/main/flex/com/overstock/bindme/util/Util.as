package com.overstock.bindme.util {

/**
 * Documentation for top-level functions in the BindMe util package.
 *
 * <p>
 * <em>Note:</em> This class exists as a workaround to an asdoc bug in Flex 3, which causes
 * some top-level functions to be excluded from generated ASdoc.  We recommend that you use the
 * top-level functions directly.
 * </p>
 */
public class Util {

  /**
   * @private
   */
  public function Util() {
  }

  /**
   * Returns a function which wraps the specified function, with the specified bound argument
   * applied.
   *
   * @param func the function to apply arguments to
   * @param boundArgs the arguments to apply
   * @return a function which wraps the specified function and applies the specified bound
   * arguments.
   */
  public static function applyArgs( func:Function,
                                    ...boundArgs ):Function {
    return com.overstock.bindme.util.applyArgs.apply(null, [func].concat(boundArgs));
  }

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
  public static function getProperty( host:Object,
                                      properties:Array ):Object {
    return com.overstock.bindme.util.getProperty(host, properties);
  }

  /**
   * Wraps the specified function in a function that will not recurse.  If this function is invoked
   * inside itself, the inner invocation returns immediately.
   *
   * @param func the function to wrap
   * @return a recursion-proof wrapper around the given function.
   */
  public static function preventRecursion( func:Function ):Function {
    return com.overstock.bindme.util.preventRecursion(func);
  }

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
  public static function setProperty( object:Object,
                                      properties:Array,
                                      value:* ):void {
    com.overstock.bindme.util.setProperty(object, properties, value);
  }

  /**
   * Calls <code>unwatch()</code> and <code>setHandler(null)</code> on each of the specified
   * ChangeWatchers.
   * @param watchers an array of ChangeWatchers.
   */
  public static function unwatchAll( watchers:Array ):void {
    com.overstock.bindme.util.unwatchAll(watchers);
  }

}

}