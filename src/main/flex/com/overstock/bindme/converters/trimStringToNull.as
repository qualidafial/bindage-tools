package com.overstock.bindme.converters {

public function trimStringToNull():Function {
  return function( value:String ):String {
    var result:String = value;
    if (result != null) {
      result = result.replace(/(^\s+|\s+$)/, "");

      if (result.length == 0) {
        result = null;
      }
    }
    return result;
  }
}

}