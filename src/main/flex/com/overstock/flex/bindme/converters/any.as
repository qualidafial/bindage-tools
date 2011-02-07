package com.overstock.flex.bindme.converters {

/**
 * Returns true if any of the arguments evaluate to Boolean true.
 * @param values
 * @return
 */
public function any( ...values ):Boolean {
  for each (var value:* in values) {
    if (value) {
      return true;
    }
  }
  return false;
}

}
