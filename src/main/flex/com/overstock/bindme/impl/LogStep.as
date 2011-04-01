/*
 * The contents of this file are subject to the Mozilla Public License
 * Version 1.1 (the "License"); you may not use this file except in
 * compliance with the License. You may obtain a copy of the License at
 * http://www.mozilla.org/MPL/
 * 
 * Software distributed under the License is distributed on an "AS IS"
 * basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the
 * License for the specific language governing rights and limitations
 * under the License.
 * 
 * The Original Code is "BindMe Data Binding Framework for Flex ActionScript 3."
 * 
 * The Initial Developer of the Original Code is Overstock.com.
 * Portions created by Overstock.com are Copyright (C) 2011.
 * All Rights Reserved.
 * 
 * Contributor(s):
 * - Matthew Hall, Overstock.com <qualidafial@gmail.com> 
 */

package com.overstock.bindme.impl {
import com.overstock.bindme.IPipelineStep;

import mx.logging.ILogger;
import mx.logging.Log;
import mx.logging.LogEventLevel;

/**
 * @private
 */
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
