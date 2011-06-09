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

import mx.logging.ILogger;
import mx.logging.Log;

public class LogPipeline implements IPipeline {

  private static const logger:ILogger = Log.getLogger("com.googlecode.bindagetools.Bind");

  private var level:int;
  private var message:String;
  private var next:IPipeline;

  public function LogPipeline( level:int,
                               message:String,
                               next:IPipeline ) {
    this.level = level;
    this.message = message;
    this.next = next;
  }

  public function run( args:Array ):void {
    logger.log.apply(null, [level, message].concat(args));

    next.run(args);
  }

}

}