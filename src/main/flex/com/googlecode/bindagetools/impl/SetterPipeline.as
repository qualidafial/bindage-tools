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
import com.googlecode.bindagetools.util.setProperty;

/**
 * @private
 */
public class SetterPipeline implements IPipeline {

  private var target:Object;
  private var properties:Array

  public function SetterPipeline( target:Object, properties:Array ) {
    this.target = target;
    this.properties = properties;
  }

  public function run( args:Array ):void {
    if (args.length != 1) {
      throw new ArgumentError("Expected 1 argument, received " + args.length);
    }

    var value:* = args[0];
    setProperty(target, properties, value);
  }
}
}