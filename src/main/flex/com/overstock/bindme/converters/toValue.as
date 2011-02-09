package com.overstock.bindme.converters {

/**
 * Returns a function which always converts to the specified value, regardless of input.
 *
 * @param value the value which the returned function will always return.
 */
public function toValue( value:* ):Function {
  return function( ... ignored ):* {
    return value;
  };
}

}
