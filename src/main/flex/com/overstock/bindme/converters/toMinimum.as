package com.overstock.bindme.converters {

/**
 * Returns a var-arg converter function which returns the least value of the received arguments.
 */
public function toMinimum():Function {
  return function( ...values ):* {
    var result:* = null;
    for each (var value:*in values) {
      if (null == result) {
        result = value;
      }
      else if (null != value && value < result) {
        result = value;
      }
    }
    return result;
  }
}

}
