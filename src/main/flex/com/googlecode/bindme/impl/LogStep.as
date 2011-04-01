/*
 * Copyright 2011 Overstock.com and others.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.googlecode.bindme.impl {
import com.googlecode.bindme.IPipelineStep;

import mx.logging.ILogger;
import mx.logging.Log;
import mx.logging.LogEventLevel;

/**
 * @private
 */
public class LogStep implements IPipelineStep {

  private static const logger:ILogger = Log.getLogger("com.googlecode.bindme.Bind");

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
