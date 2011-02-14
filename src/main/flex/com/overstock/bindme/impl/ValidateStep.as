package com.overstock.bindme.impl {
import com.overstock.bindme.IPipelineStep;

import org.hamcrest.Matcher;

/**
 * @private
 */
public class ValidateStep implements IPipelineStep {

  private var func:Function;
  private var matcher:Matcher;

  public function ValidateStep( args:Array ) {
    if (args.length == 1) {
      if (!(args[0] is Matcher)) {
        throw usageError();
      }

      this.matcher = args[0];
    }
    else if (args.length == 2) {
      if (!(args[0] is Function && args[1] is Matcher)) {
        throw usageError();
      }

      this.func = args[0];
      this.matcher = args[1];
    }
    else {
      throw usageError();
    }
  }

  private function usageError():ArgumentError {
    throw new ArgumentError(
        "Expecting arguments (attribute:Function, condition:Matcher) or (condition:Matcher)");
  }

  public function wrapStep( nextStep:Function ):Function {
    return function( value:* ):void {
      var matchValue:* = value;

      if (func != null) {
        var attributeArgs:Array = value is Array
            ? value
            : [value];
        matchValue = func.apply(null, attributeArgs);
      }

      if (matcher.matches(matchValue)) {
        nextStep(value);
      }
    }
  }

}

}
