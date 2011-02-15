package com.overstock.bindme.converters {

public function toUpperCase():Function {
  return function( value:String ):String {
    return value == null
        ? null
        : value.toUpperCase();
  }
}

}