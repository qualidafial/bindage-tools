package com.overstock.flex.bindme.converters {

/**
 * Converts a String to a Number or null.  Null or empty strings are converted to null.
 *
 * @param value the String value to convert.  May be null.
 */
public function stringToNumber( value:String ):* {
  return (value == null || value.length == 0)
      ? null
      : Number(value);
}

}
