package com.overstock.bindme.converters {

/**
 * Returns a converter function which converts a string to upper case.  Null strings are converted
 * to null.
 */
public function toUpperCase():Function {
  return function( value:String ):String {
    return value == null
        ? null
        : value.toUpperCase();
  }
}

}