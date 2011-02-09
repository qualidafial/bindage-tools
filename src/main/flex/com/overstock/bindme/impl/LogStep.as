package com.overstock.bindme.impl {
import com.overstock.bindme.IPipelineStep;

import mx.logging.ILogger;
import mx.logging.Log;
import mx.logging.LogEventLevel;

public class LogStep implements IPipelineStep {

  private static const logger:ILogger = Log.getLogger("com.overstock.bindme.Bind");

  private var level:int;
  private var message:String;

  public function LogStep( level:int,
                           message:String ) {
    if (!(level == LogEventLevel.DEBUG ||
          level == LogEventLevel.INFO ||
          level == LogEventLevel.WARN ||
          level == LogEventLevel.ERROR ||
          level == LogEventLevel.FATAL)) {
      throw new ArgumentError("Unexpected log event level " + level);
    }

    if (message == null) {
      throw new ArgumentError("Log message was null");
    }

    this.level = level;
    this.message = message;
  }

  public function wrapStep( nextStep:Function ):Function {
    return function( value:* ):void {
      var args:Array = (value is Array)
          ? value
          : [value];
      logger.log.apply(null, [level, message].concat(args));

      nextStep(value);
    }
  }

}

}
