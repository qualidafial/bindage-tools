package com.overstock.flex.bindme {
import mx.logging.ILogger;
import mx.logging.Log;
import mx.logging.LogEventLevel;
import mx.utils.ObjectUtil;

/**
 * Instances of this class represent a bindable property or chain of bindable properties.
 */
public class Property extends Object {
  private static const logger:ILogger =
      Log.getLogger("com.overstock.merch.offerprocess.util.bind.Property");

  private var _name:String;

  private var _getter:Function;

  private var _setter:Function;

  private var _parent:Property;

  /**
   * A LogEventLevel constant used for logging in this Property instance.  Properties log detailed
   * information at each step of every getValue/setValue operation.  Setting the logLevel can help
   * in troubleshooting binding problems.
   */
  public var logLevel:int = LogEventLevel.DEBUG;

  /**
   * Returns a new Property instances representing the specified property name.
   *
   * @param name the property name.  May be a nested using dot delimiters, e.g. 'foo.bar.baz'
   * @param getter (optional) a function which accepts a host object and returns the value
   *        currently in the named property for that host.  If null (the default) a getter function
   *        is provided automatically.  This argument is ignored if <code>name</code> is a nested
   *        property.
   * @param setter (optional) a function which accepts a host object and a property value, and
   *        stores the specified value in the named property of the specified host.  If null (the
   *        default) a setter function is provided automatically.  This argument is ignored if
   *        <code>name</code> is a nested property.
   */
  public static function make( name:String,
                               getter:Function = null,
                               setter:Function = null ):Property {
    return internalMake(name, getter, setter, null);
  }

  private static function internalMake( name:String,
                                        getter:Function,
                                        setter:Function,
                                        parent:Property ):Property {
    if (name.indexOf(".") == -1) {
      var actualGetter:Function = getter != null
          ? getter
          : namedGetter(name);
      var actualSetter:Function = setter != null
          ? setter
          : namedSetter(name);
      return new Property(name, actualGetter, actualSetter, parent);
    }
    else {
      var propertyNames:Array = name.split(".");
      var result:Property = parent;
      for each (var propertyName:String in propertyNames) {
        result =
        new Property(propertyName, namedGetter(propertyName), namedSetter(propertyName), result);
      }
      return result;
    }
  }

  private static function namedGetter( name:String ):Function {
    return function( obj:* ):* {
      return obj[name];
    };
  }

  private static function namedSetter( name:String ):Function {
    return function( obj:*,
                     value:* ):void {
      obj[name] = value;
    };
  }

  function Property( name:String,
                     getter:Function,
                     setter:Function,
                     parent:Property ) {
    _name = name;
    _getter = getter;
    _setter = setter;
    _parent = parent;
  }

  /**
   * Returns a new property which chains the specified property to the end of this property.
   *
   * @param property a Property instance, or a String suitable for passing to the
   *        <code>Property.make</code> function.
   * @param getter (optional) a function which accepts a host object and returns the value
   *        currently in the named property for that host.  If null (the default) a getter function
   *        is provided automatically.  This argument is ignored if <code>name</code> is a Property
   *        instance, or a String containing a nested property name.
   * @param setter (optional) a function which accepts a host object and a property value, and
   *        stores the specified value in the named property of the specified host.  If null (the
   *        default) a setter function is provided automatically.  This argument is ignored if
   *        <code>name</code> is a Property instance, or a String containing a nested property
   *        name.
   */
  public function chain( property:Object,
                         getter:Function = null,
                         setter:Function = null ):Property {
    if (property is Property) {
      return chainProperty(Property(property));
    }
    else if (property is String) {
      return internalMake(String(property), getter, setter, this);
    }
    else {
      throw new ArgumentError("Unexpected property object " + ObjectUtil.toString(property));
    }
  }

  private function chainProperty( property:Property ):Property {
    var chainParent:Property = property.parent
        ? chainProperty(property.parent)
        : this;

    return new Property(property.name, property.getter, property.setter, chainParent);
  }

  /**
   * Returns the parent of this Property instance.  e.g.
   * <code>Property.make('foo.bar').parent</code> would return <code>Property.make('foo')</code>.
   */
  public function get parent():Property {
    return _parent;
  }

  /**
   * Returns the property name.  For a chained property, this is the last property in the chain.
   *
   * <p>
   * Architectural note: This property is designed to work well with the BindingUtils.bindSetter
   * method, which accepts an array of properties, where each property object has a 'name' and a
   * 'getter' property.  This behavior may change in the future and client code should not depend
   * on this.
   * </p>
   */
  public function get name():String {
    return _name;
  }

  /**
   * Returns the property getter function.  For a chained property, this is the getter for the last
   * property in the chain.
   *
   * <p>
   * Architectural note: This property is designed to work well with the BindingUtils.bindSetter
   * method, which accepts an array of properties, where each property object has a 'name' and a
   * 'getter' property.  This behavior may change in the future and client code should not depend
   * on this.
   * </p>
   */
  public function get getter():Function {
    return _getter;
  }

  /**
   * Returns the property setter function.  For a chained property, this is the setter for the last
   * property in the chain.
   */
  public function get setter():Function {
    return _setter;
  }

  /**
   * Returns the value of this property for the specified object.
   *
   * @param object the object to get the property value from.
   */
  public function getValue( object:* ):* {
    logger.log(logLevel, "getting property {0} from object {1}:", toString(), String(object));
    return internalGetValue(object, logLevel);
  }

  private function internalGetValue( object:*,
                                     logLevel:int ):* {
    var value:* = null;

    var host:* = resolveHost(object);
    if (host) {
      value = getter(host);
      logger.log(logLevel, "   {0}.{1} == '{2}'", String(object), String(name), String(value));
    }

    return value;
  }

  /**
   * Sets the property of the specified object to the specified value(s).
   *
   * @param object the object to set the property value on.
   * @param values one or more values to pass to the property setter.
   */
  public function setValue( object:*,
                            ... values ):void {
    logger.log(logLevel, "setting property {0} on object {1} to '{2}':", toString(), String(object),
               String(values));
    internalSetValue(object, values);
  }

  private function internalSetValue( object:*,
                                     values:Array ):void {
    var host:* = resolveHost(object);
    if (host) {
      logger.log(logLevel, "   set {0}.{1} to '{2}'", String(host), String(name), String(values));
      var setterArgs:Array = [ host ].concat(values);
      setter.apply(null, setterArgs);
    }
    else {
      logger.log(logLevel, "   Unexpected null in property chain -- aborting set");
    }
  }

  private function resolveHost( object:* ):* {
    return parent
        ? parent.internalGetValue(object, logLevel)
        : object;
  }

  /**
   * Returns an Array suitable for passing as the <code>chain</code> argument to
   * <code>BindingUtils.bindSetter</code>.
   */
  public function toArray():Array {
    return parent
        ? parent.toArray().concat(this)
        : [ this ];
  }

  /**
   * Returns a programmer-friendly String representation of this property.
   */
  public function toString():String {
    return _parent
        ? _parent.toString() + "." + name
        : name;
  }

}
}