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

package com.overstock.bindme.impl {
import com.overstock.bindme.IPipelineStep;

/**
 * @private
 */
public class ConvertStep implements IPipelineStep {

  private var converter:Function;

  public function ConvertStep( converter:Function ) {
    if (converter == null) {
      throw new ArgumentError("converter function was null");
    }

    this.converter = converter;
  }

  public function wrapStep( nextStep:Function ):Function {
    return function( value:* ):void {
      var values:Array = value is Array
          ? value
          : [value];

      var convertedValue:* = converter.apply(null, values);
      nextStep(convertedValue);
    }
  }

}

}
