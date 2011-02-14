package com.overstock.bindme.converters {

/**
 * Returns a converter function which converts a boolean value to its inverse.
 */
public function toBooleanInverse():Function {
  return function( value:Boolean ):Boolean {
    return !value;
  }
}

}
