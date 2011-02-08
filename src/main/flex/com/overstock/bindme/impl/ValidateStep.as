package com.overstock.bindme.impl {
import com.overstock.bindme.IPipelineStep;

import org.hamcrest.Matcher;

public class ValidateStep implements IPipelineStep {

  private var condition:Matcher;

  public function ValidateStep( condition:Matcher ) {
    this.condition = condition;
  }

  public function wrapStep( nextStep:Function ):Function {
    return function( ...values ):void {
      if (condition.matches(values)) {
        nextStep.apply(null, values);
      }
    }
  }

}

}
