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

package com.googlecode.bindagetools.util {

/**
 * Returns a function which wraps the specified function, with the specified bound argument
 * applied.
 *
 * @param func the function to apply arguments to
 * @param boundArgs the arguments to apply
 * @return a function which wraps the specified function and applies the specified bound arguments.
 */
public function applyArgs( func:Function,
                           ...boundArgs ):Function {

  return function( ... dynamicArgs ):* {
    return func.apply(null, boundArgs.concat(dynamicArgs));
  }

}

}
