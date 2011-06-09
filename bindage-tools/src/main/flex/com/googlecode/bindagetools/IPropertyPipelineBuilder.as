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
 * A single-source binding pipeline builder, binding from a property of a single source object.
 *
 * <p>
 * <em>Note</em>: This interface is not intended to be implemented directly by clients.  Clients
 * should instead extend one of the included implementations of this interface.  In future
 * versions, new methods might be added to this interface, which would break any direct
 * implementations.
 * </p>
 */
public interface IPropertyPipelineBuilder extends IPipelineBuilder {

  /**
   * Returns the source object of the binding pipeline.
   */
  function get source():Object;

  /**
   * Returns the sequence of nested properties that this binding pipeline watches on the source
   * object.
   */
  function get properties():Array;

}

}
