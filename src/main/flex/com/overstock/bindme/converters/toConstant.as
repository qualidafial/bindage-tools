package com.overstock.bindme.converters {

/**
 * Returns a converter function which always converts to the specified value, regardless of input.
 *
 * @param value the value which the returned function will always return.
 */
public function toConstant( value:* ):Function {
  return function( ... ignored ):* {
    return value;
  };
}

}
