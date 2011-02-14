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
