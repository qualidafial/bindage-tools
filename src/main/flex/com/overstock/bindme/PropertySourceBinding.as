package com.overstock.bindme {
import mx.binding.utils.BindingUtils;

public class PropertySourceBinding implements IOngoingBinding {

  private var source:Object;
  private var propertyChain:Array;

  public function PropertySourceBinding( source:Object,
                                         property:String ) {
    this.source = source;
    this.propertyChain = toChain(property);
  }

  private static function toChain( property:String ):Array {
    return property.split(".");
  }

  public function toProperty( target:Object,
                              property:String ):IOngoingBinding {
    return toFunction(propertySetter(target, toChain(property)));
  }

  private function propertySetter( target:Object,
                                   propertyChain:Array ):Function {
    var parentProperties:Array = propertyChain.slice(0, propertyChain.length - 1);
    var leafProperty:String = propertyChain[propertyChain.length - 1];
    return function( value:* ):void {
      var host:Object = target;
      for each (var parentProperty:String in parentProperties) {
        host = host[parentProperty];
        if (host == null) {
          break;
        }
      }

      if (host != null) {
        host[leafProperty] = value;
      }
    }
  }

  public function toFunction( func:Function ):IOngoingBinding {
    BindingUtils.bindSetter(func, this.source, this.propertyChain);
    return this;
  }

  public function convert( converter:Function ):IOngoingBinding {
    return this;
  }

}

}
