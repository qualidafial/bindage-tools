package com.overstock.bindme.converters {

/**
 * Returns a converter function which converts values to their <code>toString()</code>
 * representation.  Null values are converted to null.
 */
public function valueToString():Function {
  return function( value:* ):String {
    return value == null
        ? null
        : value.toString();
  }
}

}
