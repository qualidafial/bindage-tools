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

/**
 * Begins stubbing for a conditional converter.
 *
 * @param condition the condition that pipeline arguments(s) will be tested against to decide
 * conversion. Valid arguments:
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
 * @return an IThenValue to continue stubbing
 * @throws ArgumentError if the validator arguments are invalid
 */
public function ifValue( ...condition ):IThenConvertStubbing {
  return new ConditionalConverter(condition);
}

}