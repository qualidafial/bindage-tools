/*
 * The contents of this file are subject to the Mozilla Public License
 * Version 1.1 (the "License"); you may not use this file except in
 * compliance with the License. You may obtain a copy of the License at
 * http://www.mozilla.org/MPL/
 * 
 * Software distributed under the License is distributed on an "AS IS"
 * basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the
 * License for the specific language governing rights and limitations
 * under the License.
 * 
 * The Original Code is "BindMe Data Binding Framework for Flex ActionScript 3."
 * 
 * The Initial Developer of the Original Code is Overstock.com.
 * Portions created by Overstock.com are Copyright (C) 2011.
 * All Rights Reserved.
 * 
 * Contributor(s):
 * - Matthew Hall, Overstock.com <qualidafial@gmail.com> 
 */

package com.overstock.bindme.converters {

/**
 * Returns a converter function which converts strings by trimming away any leading and trailing
 * whitespace; strings containing only whitespace are converted to null.
 */
public function trimStringToNull():Function {
  return function( value:String ):String {
    var result:String = value;
    if (result != null) {
      result = result.replace(/(^\s+|\s+$)/, "");

      if (result.length == 0) {
        result = null;
      }
    }
    return result;
  }
}

}