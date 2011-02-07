package com.overstock.flex.bindme.converters {

/**
 * Returns the maximum value in the arguments
 *
 * @param values the values from which the maximum will be taken
 */
public function max( ...values ):* {
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
