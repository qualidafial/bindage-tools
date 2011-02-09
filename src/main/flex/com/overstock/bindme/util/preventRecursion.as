package com.overstock.bindme.util {

/**
 * Wraps the specified function in a function that will not recurse.  If this function is invoked
 *  inside itself, the inner invocation returns immediately.
 *
 * @param func the function to wrap
 * @return a recursion-proof wrapper around the given function.
 */
public function preventRecursion( func:Function ):Function {
  var running:Boolean = false;
  return function( ...values ):* {
    if (!running) {
      try {
        running = true;
        func.apply(null, values);
      } finally {
        running = false;
      }
    }
  }
}

}
