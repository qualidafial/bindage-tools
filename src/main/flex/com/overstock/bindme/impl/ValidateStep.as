package com.overstock.bindme.impl {
import com.overstock.bindme.IPipelineStep;

import org.hamcrest.Matcher;

public class ValidateStep implements IPipelineStep {

  private var attribute:Function;
  private var matcher:Matcher;

  public function ValidateStep( condition:Array ) {
    if (condition.length == 1) {
      this.attribute = null;
      this.matcher = condition[0];
    }
    else if (condition.length == 2) {
      this.attribute = condition[0];
      this.matcher = condition[1];
    }
    else {
      throw new ArgumentError(
          "Expecting arguments (attribute:Function, condition:Matcher) or (condition:Matcher)");
    }
  }

  public function wrapStep( nextStep:Function ):Function {
    return function( value:* ):void {
      var matchValue:* = value;

      if (attribute != null) {
        var attributeArgs:Array = value is Array
            ? value
            : [value];
        matchValue = attribute.apply(null, attributeArgs);
      }

      if (matcher.matches(matchValue)) {
        nextStep(value);
      }
    }
  }

}

}
