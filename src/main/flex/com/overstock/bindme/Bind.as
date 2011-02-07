package com.overstock.bindme {
public class Bind {
  public static function fromProperty( source:Object,
                                       property:String ):IOngoingBinding {
    if (null == source) {
      throw new ArgumentError("source was null");
    }

    if (null == property) {
      throw new ArgumentError("property was null");
    }

    return new PropertySourceBinding(source, property);
  }
}

}
