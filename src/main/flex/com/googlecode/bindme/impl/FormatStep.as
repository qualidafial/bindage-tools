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

import mx.utils.StringUtil;

/**
 * @private
 */
public class FormatStep implements IPipelineStep {

  private var format:String;

  public function FormatStep( format:String ) {

    if (format == null) {
      throw new ArgumentError("Format was null");
    }

    this.format = format;
  }

  public function wrapStep( nextStep:Function ):Function {
    return function( value:* ):void {
      var args:Array = (value is Array)
          ? value
          : [value];

      var formattedValue:String = StringUtil.substitute.apply(null, [format].concat(args));

      nextStep(formattedValue);
    }
  }

}

}
