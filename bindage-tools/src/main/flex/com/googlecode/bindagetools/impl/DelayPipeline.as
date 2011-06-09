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

package com.googlecode.bindagetools.impl {
import com.googlecode.bindagetools.IPipeline;

import flash.events.TimerEvent;
import flash.utils.Timer;

public class DelayPipeline implements IPipeline {

  private var delayMillis:int;
  private var next:IPipeline;

  private var timer:Timer = null;

  public function DelayPipeline( delayMillis:int, next:IPipeline ) {
    this.delayMillis = delayMillis;
    this.next = next;
  }

  public function run( args:Array ):void {
    function timerElapsed( event:TimerEvent ):void {
      next.run(args);
      timer = null;
    }

    if (timer != null) {
      timer.stop();
    }

    timer = new Timer(delayMillis, 1);
    timer.addEventListener(TimerEvent.TIMER_COMPLETE, timerElapsed);
    timer.start();
  }

}

}