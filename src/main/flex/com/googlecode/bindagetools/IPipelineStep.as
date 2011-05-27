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

package com.googlecode.bindagetools {

/**
 * A step in a data binding pipeline.
 */
public interface IPipelineStep {

  /**
   * Returns a function which accepts the expected value(s) in the binding pipeline,
   * executes this step, and calls the next step with the same value(s) when finished.
   * @param next the next step in the pipeline.
   */
  function wrap( next:IPipeline ):IPipeline;

}

}
