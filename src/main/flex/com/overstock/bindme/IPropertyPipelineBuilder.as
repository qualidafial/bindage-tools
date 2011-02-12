package com.overstock.bindme {

/**
 * A single-source binding pipeline builder, binding from a property of a single source object.
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
