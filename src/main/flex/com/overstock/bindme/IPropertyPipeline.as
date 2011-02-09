package com.overstock.bindme {

/**
 * A binding pipeline originating from a property of a particular source object.
 */
public interface IPropertyPipeline extends IPipeline {

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
