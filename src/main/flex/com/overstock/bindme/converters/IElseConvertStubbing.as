package com.overstock.bindme.converters {

/**
 * Interface for stubbing a conditional converter for when the condition is not satisfied.
 *
 * @see ifValue
 * @see Converters#ifValue
 */
public interface IElseConvertStubbing {

  /**
   * Specifies the converter to use if the condition is not satisfied, and returns the finalized
   * conditional converter function.
   *
   * @param elseConverter the converter to use if the condition is not satisfied.
   * @return the finalized conditional converter function.
   */
  function elseConvert( elseConverter:Function ):Function;

}

}