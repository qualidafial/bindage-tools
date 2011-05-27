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
import com.googlecode.bindagetools.IPipeline;
import com.googlecode.bindagetools.IPipelineStep;
import com.googlecode.bindagetools.converters.toCondition;

/**
 * @private
 */
public class ValidateStep implements IPipelineStep {

  private var condition:Function;

  public function ValidateStep( conditions:Array ) {
    condition = toCondition.apply(null, conditions);
  }

  public function wrap( next:IPipeline ):IPipeline {
    return new ValidatePipeline(condition, next);
  }

}

}
