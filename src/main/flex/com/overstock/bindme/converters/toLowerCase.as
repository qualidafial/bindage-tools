package com.overstock.bindme.converters {

public function toLowerCase():Function {
  return function( value:String ):String {
    return value == null
        ? null
        : value.toLowerCase();
  }
}

}