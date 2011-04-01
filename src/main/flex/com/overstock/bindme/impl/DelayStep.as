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

import flash.events.TimerEvent;
import flash.utils.Timer;

/**
 * @private
 */
public class DelayStep implements IPipelineStep {

  private var delayMillis:int;

  public function DelayStep( delayMillis:int ) {
    this.delayMillis = delayMillis;
  }

  public function wrapStep( nextStep:Function ):Function {
    var timer:Timer = null;

    return function( value:* ):void {
      function timerElapsed( event:TimerEvent ):void {
        nextStep(value);
      }

      if (timer != null) {
        timer.stop();
        timer = null;
      }

      timer = new Timer(delayMillis, 1);
      timer.addEventListener(TimerEvent.TIMER_COMPLETE, timerElapsed);
      timer.start();
    }
  }

}

}
