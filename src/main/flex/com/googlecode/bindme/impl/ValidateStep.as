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
