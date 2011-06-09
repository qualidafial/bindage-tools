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
internal class ConditionalConverter implements IThenConvertStubbing, IElseConvertStubbing {
  private var condition:Function;
  private var thenConverter:Function;
  private var elseConverter:Function;

  public function ConditionalConverter( conditions:Array ) {
    condition = toCondition.apply(null, conditions);
  }

  public function thenConvert( thenConverter:Function ):IElseConvertStubbing {
    this.thenConverter = thenConverter;
    return this;
  }

  public function elseConvert( elseConverter:Function ):Function {
    this.elseConverter = elseConverter;
    return convertConditionally;
  }

  private function convertConditionally( ...values ):* {
    var converter:Function = condition.apply(null, values)
        ? thenConverter
        : elseConverter;

    return converter.apply(null, values);
  }
}

}