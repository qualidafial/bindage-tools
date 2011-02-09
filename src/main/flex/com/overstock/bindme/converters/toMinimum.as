package com.overstock.bindme.converters {

/**
 * Returns the minimum value in the arguments
 *
 * @param values the values from which the minimum will be taken
 */
public function toMinimum( ... values ):* {
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
