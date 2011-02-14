package com.overstock.bindme.impl {
import com.overstock.bindme.IPipelineStep;

import mx.utils.StringUtil;

/**
 * @private
 */
public class FormatStep implements IPipelineStep {

  private var format:String;

  public function FormatStep( format:String ) {

    if (format == null) {
      throw new ArgumentError("Format was null");
    }

    this.format = format;
  }

  public function wrapStep( nextStep:Function ):Function {
    return function( value:* ):void {
      var args:Array = (value is Array)
          ? value
          : [value];

      var formattedValue:String = StringUtil.substitute.apply(null, [format].concat(args));

      nextStep(formattedValue);
    }
  }

}

}
