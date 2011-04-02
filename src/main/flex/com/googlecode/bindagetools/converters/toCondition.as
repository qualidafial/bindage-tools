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

/**
 * Returns a converter function which returns a Boolean value indicating whether the value(s) in
 * the pipeline match the specified condition.
 *
 * @param condition the condition that pipeline value(s) will be tested against.
 */
public function toCondition( condition:Matcher ):Function {
  return function( value:* ):Boolean {
    return condition.matches(value);
  }
}

}
