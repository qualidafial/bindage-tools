package com.overstock.bindme.converters {

/**
 * Returns a function which converts an empty string to null.  Non-empty strings are returned as
 * is.
 */
public function emptyStringToNull():Function {
  return function( value:String ):String {
    return (value == null || value.length == 0)
        ? null
        : value;
  };
}

}
