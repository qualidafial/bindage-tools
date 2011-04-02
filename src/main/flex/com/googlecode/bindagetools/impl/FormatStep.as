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

package com.googlecode.bindagetools.impl {
import com.googlecode.bindagetools.IPipelineStep;

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
