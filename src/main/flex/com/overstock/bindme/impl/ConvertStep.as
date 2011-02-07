package com.overstock.bindme.impl {
import com.overstock.bindme.IPipelineStep;

public class ConvertStep implements IPipelineStep {

  private var converter:Function;

  public function ConvertStep( converter:Function ) {
    this.converter = converter;
  }

  public function wrapStep( nextStep:Function ):Function {
    return function( value:* ):* {
      var convertedValue:* = converter(value);
      nextStep(convertedValue);
    }
  }

}

}
