package com.overstock.bindme.converters {

/**
 * Returns a converter function which converts a <code>String</code> to a <code>Number</code>.
 * Empty strings are converted to null.
 */
public function toNumber():Function {
  return function( value:String ):* {
    return (value == null || value.length == 0)
        ? null
        : Number(value);
  }
}

}
