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

package com.googlecode.bindme {

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
