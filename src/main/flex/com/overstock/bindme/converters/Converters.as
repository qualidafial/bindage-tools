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

package com.overstock.bindme.converters {
import org.hamcrest.Matcher;

/**
 * Documentation for top-level functions in the BindMe converters package.  The methods in this
 * class serve as documentation for the public functions in this package.
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
  public static function ifValue( condition:Matcher ):IThenConvertStubbing {
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
   * Returns a converter function which converts a string to lower case.  Null strings are
   * converted to null.
   */
  public static function toLowerCase():Function {
    return com.overstock.bindme.converters.toLowerCase();
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
   * Returns a converter function which converts a string to upper case.  Null strings are
   * converted to null.
   */
  public static function toUpperCase():Function {
    return com.overstock.bindme.converters.toUpperCase();
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