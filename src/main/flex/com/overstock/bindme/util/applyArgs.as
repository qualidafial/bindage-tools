package com.overstock.bindme.util {

/**
 * Returns a function which wraps the specified function, with the specified bound argument
 * applied.
 *
 * @param func the function to apply arguments to
 * @param boundArgs the arguments to apply
 * @return a function which wraps the specified function and applies the specified bound arguments.
 */
public function applyArgs( func:Function,
                           ...boundArgs ):Function {

  return function( ... dynamicArgs ):* {
    return func.apply(null, boundArgs.concat(dynamicArgs));
  }

}

}
