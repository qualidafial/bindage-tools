package com.overstock.bindme.impl {
import com.overstock.bindme.IPipelineStep;

import org.hamcrest.Matcher;

public class ValidateStep implements IPipelineStep {

  private var condition:Matcher;

  public function ValidateStep( condition:Matcher ) {
    this.condition = condition;
  }

  public function wrapStep( nextStep:Function ):Function {
    return function(value:*):void {
      if (condition.matches(value)) {
        nextStep(value);
      }
    }
  }

}

}
