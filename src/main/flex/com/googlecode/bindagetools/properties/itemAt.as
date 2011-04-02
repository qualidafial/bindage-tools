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

package com.googlecode.bindagetools.properties {

/**
 * Returns a custom property object for the item at the specified index.  May be used with
 * Array and ILists.
 *
 * @param index the item index
 * @return a property object for getting/setting/watching the item at the specified index.
 */
public function itemAt( index:int ):Object {
  if (index < 0) {
    throw new ArgumentError("index must be >= 0");
  }

  function getter( obj:Object ):* {
    return obj.length > index
        ? obj[index]
        : null;
  }

  function setter( obj:Object,
                   value:* ):void {
    if (obj.length > index) {
      obj[index] = value;
    }
  }

  return {
    name: "getItemAt",
    getter: getter,
    setter: setter
  }
}

}
