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

import org.hamcrest.Matcher;
import org.hamcrest.object.equalTo;

/**
 * @private
 */
public class ValidateStep implements IPipelineStep {

  private var func:Function;
  private var matcher:Matcher;

  public function ValidateStep( args:Array ) {
    if (args.length == 1) {
      if (args[0] is Matcher) {
        this.func = null;
        this.matcher = args[0];
      }
      else if (args[0] is Function) {
        this.func = args[0];
        this.matcher = equalTo(true);
      }
      else {
        throw usageError();
      }
    }
    else if (args.length == 2) {
      if (!(args[0] is Function && args[1] is Matcher)) {
        throw usageError();
      }

      this.func = args[0];
      this.matcher = args[1];
    }
    else {
      throw usageError();
    }
  }

  private static function usageError():ArgumentError {
    throw new ArgumentError(
        "Expecting arguments (attribute:Function, condition:Matcher) or (condition:Matcher)");
  }

  public function wrapStep( nextStep:Function ):Function {
    return function( value:* ):void {
      var matchValue:* = value;

      if (func != null) {
        var attributeArgs:Array = value is Array
            ? value
            : [value];
        matchValue = func.apply(null, attributeArgs);
      }

      if (matcher.matches(matchValue)) {
        nextStep(value);
      }
    }
  }

}

}
