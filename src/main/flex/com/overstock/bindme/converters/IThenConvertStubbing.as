package com.overstock.bindme.converters {

/**
 * Interface for stubbing a conditional converter for when the condition is satisfied.
 *
 * @see ifValue
 * @see Converters#ifValue
 */
public interface IThenConvertStubbing {

  /**
   * Specifies the converter to use if the condition is satisfied.
   *
   * @param thenConverter the converter to use if the condition is satisfied.
   * @return an IElseValue to continue stubbing.
   */
  function thenConvert( thenConverter:Function ):IElseConvertStubbing;

}

}