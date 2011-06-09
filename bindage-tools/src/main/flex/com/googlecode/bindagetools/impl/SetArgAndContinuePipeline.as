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

/**
 * @private
 */
public class SetArgAndContinuePipeline implements IPipeline {

  private var argArray:Array;
  private var index:int;
  private var next:Function;

  public function SetArgAndContinuePipeline( argArray:Array, index:int, next:Function ) {
    this.argArray = argArray;
    this.index = index;
    this.next = next;
  }

  public function run( args:Array ):void {
    if (args.length != 1) {
      throw new ArgumentError("Expected 1 argument, received " + args.length);
    }

    argArray[index] = args[0];

    next();
  }
}
}