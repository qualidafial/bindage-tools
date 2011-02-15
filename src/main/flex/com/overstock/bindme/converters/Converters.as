package com.overstock.bindme.converters {
import org.hamcrest.Matcher;

/**
 * Documentation for top-level functions in the BindMe converters package.
 *
 * <p>
 * <em>Note:</em> This class exists as a workaround to an asdoc bug in Flex 3, which causes
 * some top-level functions to be excluded from generated ASdoc.  We recommend that you use the
 * top-level functions directly.
 * </p>
 */
public class Converters {

  /**
   * @private
   */
  function Converters() {
  }

  /**
   * Returns a converter function which converts an empty string to null.  Non-empty strings are
   * returned as is.
   */
  public static function emptyStringToNull():Function {
    return com.overstock.bindme.converters.emptyStringToNull();
  }

  /**
   * Begins stubbing for a conditional converter.
   *
   * @param condition the condition to test for
   * @return an IThenValue to continue stubbing
   */
  public static function ifValue(condition:Matcher):IThenConvertStubbing {
    return com.overstock.bindme.converters.ifValue(condition);
  }

  /**
   * Returns a converter function which converts null to the given value.
   */
  public static function nullToValue( valueIfNull:Object ):Function {
    return com.overstock.bindme.converters.nullToValue(valueIfNull);
  }

  /**
   * Returns a converter function which converts a boolean value to its inverse.
   */
  public static function toBooleanInverse():Function {
    return com.overstock.bindme.converters.toBooleanInverse();
  }

  /**
   * Returns a converter function which returns a Boolean value indicating whether the value(s) in
   * the pipeline match the specified condition.
   *
   * @param condition the condition that pipeline value(s) will be tested against.
   */
  public static function toCondition( condition:Matcher ):Function {
    return com.overstock.bindme.converters.toCondition(condition);
  }

  /**
   * Returns a converter function which always converts to the specified value, regardless of
   * input.
   *
   * @param value the value which the returned function will always return.
   */
  public static function toConstant( value:* ):Function {
    return com.overstock.bindme.converters.toConstant(value);
  }

  /**
   * Returns a var-arg converter function which returns the greatest value of the received
   * arguments.
   */
  public static function toMaximum():Function {
    return com.overstock.bindme.converters.toMaximum();
  }

  /**
   * Returns a var-arg converter function which returns the least value of the received arguments.
   */
  public static function toMinimum():Function {
    return com.overstock.bindme.converters.toMinimum();
  }

  /**
   * Returns a converter function which converts a <code>String</code> to a <code>Number</code>.
   * Empty strings are converted to null.
   */
  public static function toNumber():Function {
    return com.overstock.bindme.converters.toNumber();
  }

  /**
   * Returns a converter function which converts strings by trimming away any leading and trailing
   * whitespace; strings containing only whitespace are converted to null.
   */
  public static function trimStringToNull():Function {
    return com.overstock.bindme.converters.trimStringToNull();
  }

  /**
   * Returns a converter function which converts values to their <code>toString()</code>
   * representation.  Null values are converted to null.
   */
  public static function valueToString():Function {
    return com.overstock.bindme.converters.valueToString();
  }

}

}