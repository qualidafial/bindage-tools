package com.overstock.bindme {

/**
 * A binding pipeline originating from a property of a particular source object.
 */
public interface IPropertyPipeline extends IPipeline {

  /**
   * Returns a <code>function(value:*):void</code> which, when invoked,
   * sets the pipeline source property to the passed-in value.
   * @return a function which sets the pipelins source's property.
   */
  function sourceSetter():Function;

}

}
