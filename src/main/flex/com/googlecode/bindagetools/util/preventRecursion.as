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
 * Wraps the specified function in a function that will not recurse.  If this function is invoked
 * inside itself, the inner invocation returns immediately.
 *
 * @param func the function to wrap
 * @return a recursion-proof wrapper around the given function.
 */
public function preventRecursion( func:Function ):Function {
  var running:Boolean = false;
  return function( ...values ):* {
    if (!running) {
      try {
        running = true;
        func.apply(null, values);
      } finally {
        running = false;
      }
    }
  }
}

}
