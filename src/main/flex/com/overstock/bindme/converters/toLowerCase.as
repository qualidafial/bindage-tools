package com.overstock.bindme.converters {

/**
 * Returns a converter function which converts a string to lower case.  Null strings are converted
 * to null.
 */
public function toLowerCase():Function {
  return function( value:String ):String {
    return value == null
        ? null
        : value.toLowerCase();
  }
}

}