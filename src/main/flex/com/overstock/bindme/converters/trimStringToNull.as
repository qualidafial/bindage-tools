package com.overstock.bindme.converters {

/**
 * Returns a converter function which converts strings by trimming away any leading and trailing
 * whitespace; strings containing only whitespace are converted to null.
 */
public function trimStringToNull():Function {
  return function( value:String ):String {
    var result:String = value;
    if (result != null) {
      result = result.replace(/(^\s+|\s+$)/, "");

      if (result.length == 0) {
        result = null;
      }
    }
    return result;
  }
}

}