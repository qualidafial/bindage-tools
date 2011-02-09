package com.overstock.bindme.converters {

/**
 * Converts values to their String representation.  Null values are converted to null.
 *
 * @param value the value to convert.  May be null.
 */
public function valueToString( value:* ):String {
  return value == null
      ? null
      : value.toString();
}

}
