package com.overstock.bindme {

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
