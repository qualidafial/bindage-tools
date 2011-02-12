package com.overstock.bindme.converters {

/**
 * Returns a converter function which converts null to the given value.
 */
public function nullToValue( nullValue:Object ):Function {
  return function( value:* ):* {
    return value == null
        ? nullValue
        : value;
  };
}

}
