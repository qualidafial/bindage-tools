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

package com.googlecode.bindme.util {

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
