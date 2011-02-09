package com.overstock.bindme {

/**
 * Instances of this class are used to group bindings so that only one pipeline in a group may
 * execute at once.
 */
public class BindGroup {

  private var running:Boolean;

  public function BindGroup() {
    running = false;
  }

  /**
   * Calls the given function if this group is not already calling another function.  If this
   * group is already calling another function, no action is taken.
   *
   * @param func the function to call
   * @param rest the arguments to use when calling the function.
   */
  public function callExclusively( func:Function,
                                   ...rest ):* {
    if (!running) {
      try {
        running = true;
        return func.apply(null, rest);
      } finally {
        running = false;
      }
    }
    else {
      return null;
    }
  }

}

}
