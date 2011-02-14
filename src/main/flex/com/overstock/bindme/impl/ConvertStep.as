package com.overstock.bindme.impl {
import com.overstock.bindme.IPipelineStep;

/**
 * @private
 */
public class ConvertStep implements IPipelineStep {

  private var converter:Function;

  public function ConvertStep( converter:Function ) {
    if (converter == null) {
      throw new ArgumentError("converter function was null");
    }

    this.converter = converter;
  }

  public function wrapStep( nextStep:Function ):Function {
    return function( value:* ):void {
      var values:Array = value is Array
          ? value
          : [value];

      var convertedValue:* = converter.apply(null, values);
      nextStep(convertedValue);
    }
  }

}

}
