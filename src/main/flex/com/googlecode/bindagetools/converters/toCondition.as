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

package com.googlecode.bindagetools.converters {
import org.hamcrest.Matcher;
import org.hamcrest.collection.array;

/**
 * Returns a converter function which returns a Boolean value indicating whether the pipeline
 * argument(s) match the specified condition.
 *
 * @param conditions the condition that pipeline argument(s) will be tested against. Valid values:
 * <ul>
 * <li>A <code>function(arg0, arg1, ... argN):Boolean</code>.  In this case, the function is
 * called with the pipeline arguments, and the result determines whether the pipeline continues
 * executing.</li>
 * <li>A <code>function(arg0, arg1, ... argN):* </code> followed by a <code>Matcher</code>. In
 * this case the function is called with the pipeline argument(s), and the result is validated
 * against the matcher.</li>
 * <li>One or more <code>Matcher</code>s.  In this case, the pipeline argument(s) are validated
 * against the corresponding matcher. In multi-source pipelines, there must be the same number of
 * matchers as pipeline arguments</li>
 * </ul>
 * @throws ArgumentError if the validator arguments are invalid
 */
public function toCondition( ...conditions:Array ):Function {
  var attribute:Function;
  var condition:Matcher;
  var expectedArgs:* = null;

  var usageErrorString:String = "Expecting arguments (condition:Function), (attribute:Function, " +
                                "condition:Matcher) or (...conditions:Matchers)";

  if (conditions.length == 0) {
    throw new ArgumentError(usageErrorString);
  }
  else if (conditions[0] is Function) {
    if (conditions.length == 1) {
      // shortcut.  toCondition(function) without a matcher is the same as calling
      // that function directly.
      return conditions[0];
    }
    else if (conditions.length == 2) {
      if (conditions[1] is Matcher) {
        attribute = conditions[0];
        condition = conditions[1];
      }
      else {
        throw new ArgumentError(usageErrorString);
      }
    }
    else {
      throw new ArgumentError(usageErrorString);
    }
  }
  else {
    for each (var cond:* in conditions) {
      if (!(cond is Matcher)) {
        throw new ArgumentError(usageErrorString);
      }
    }

    attribute = args();
    condition = array(conditions);
    expectedArgs = conditions.length;
  }

  return function( ...values ):Boolean {
    if (expectedArgs != null && expectedArgs != values.length) {
      throw new ArgumentError("Expected " +
                              expectedArgs +
                              " arguments, received " +
                              values.length);
    }

    var matchValue:* = attribute.apply(null, values);

    return condition.matches(matchValue);
  }
}

}
