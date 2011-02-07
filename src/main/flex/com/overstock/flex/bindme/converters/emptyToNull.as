package com.overstock.flex.bindme.converters {

/**
 * Converts an empty string to null.  If the string is non-null and non-empty, it is returned
 * without modification.
 *
 * @param value the String (or null) value to convert
 */
public function emptyToNull( value:String ):String {
  return (value == null || value.length == 0)
      ? null
      : value;
}

}
