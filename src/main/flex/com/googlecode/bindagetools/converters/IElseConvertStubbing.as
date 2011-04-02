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
 * Interface for stubbing a conditional converter for when the condition is not satisfied.
 *
 * @see ifValue
 * @see Converters#ifValue
 */
public interface IElseConvertStubbing {

  /**
   * Specifies the converter to use if the condition is not satisfied, and returns the finalized
   * conditional converter function.
   *
   * @param elseConverter the converter to use if the condition is not satisfied.
   * @return the finalized conditional converter function.
   */
  function elseConvert( elseConverter:Function ):Function;

}

}