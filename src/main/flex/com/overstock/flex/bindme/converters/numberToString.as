package com.overstock.flex.bindme.converters {

/**
 * Converts a Number or null to a String.  Null values are converted to null.
 *
 * @param value the numeric value to convert.  May be null.
 */
public function numberToString( value:* ):String {
  return value == null
      ? null
      : value.toString();
}

}
