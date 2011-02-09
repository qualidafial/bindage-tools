package com.overstock.bindme.converters {

/**
 * Converts a String to a Number or null.  Null or empty strings are converted to null.
 *
 * @param value the String value to convert.  May be null.
 */
public function toNumber( value:String ):* {
  return (value == null || value.length == 0)
      ? null
      : Number(value);
}

}
