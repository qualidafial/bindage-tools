package com.overstock.bindme.converters {

/**
 * Returns a var-arg converter function which returns the greatest value of the received arguments.
 */
public function toMaximum():Function {
  return function( ...values ):* {
    var result:* = null;
    for each (var value:*in values) {
      if (null == result) {
        result = value;
      }
      else if (null != value && value > result) {
        result = value;
      }
    }
    return result;
  }
}

}
