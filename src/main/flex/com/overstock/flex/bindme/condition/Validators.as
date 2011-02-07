package com.overstock.flex.bindme.condition {

public class Validators {

  /**
   * Returns whether the argument can be converted to a Number.  Returns false if
   * <code>Number(value)</code> returns <code>NaN</code>.
   *
   * @param value the value to test for conversion.
   */
  public static function stringToNumber( value:String ):Boolean {
    return !isNaN(Number(value));

  }

  /**
   * Returns a function which accepts 0 or more values, and returns true if all of the specified
   * operand functions return true when passed the same values.
   *
   * @param operands functions which will be invoked with the values passed to the returned
   * function.
   */
  public static function allOf( ...operands ):Function {
    return function( ...values ):Boolean {
      for each (var operand:Function in operands) {
        if (!operand.apply(null, values)) {
          return false;
        }
      }
      return true;
    };
  }

  /**
   * Returns a function which accepts 0 or more values, and returns true if any of the specified
   * operand functions return true when passed the same values.
   *
   * @param operands functions which will be invoked with the values passed to the returned
   * function.
   */
  public static function anyOf( ...operands ):Function {
    return function( ...values ):Boolean {
      for each (var operand:Function in operands) {
        if (operand.apply(null, values)) {
          return true;
        }
      }
      return false;
    }
  }

  /**
   * Returns a function which accepts a value, and returns true if one of the specified functions
   * returns true and the other returns false when invoked with the value.
   *
   * @param a the left-hand of the binary test
   * @param b the right-hand of the binary test
   */
  public static function xor( a:Function,
                              b:Function ):Function {
    return function( value:* ):Boolean {
      return Boolean(a(value)) != Boolean(b(value));
    };
  }

  /**
   * Returns a function which accepts a value, and returns the Boolean inverse of the value returned
   * from the specified function when invoked with the value.
   *
   * @param a the function which will be inverted by the returned Function.
   */
  public static function not( a:Function ):Function {
    return function( value:* ):Boolean {
      return !a(value);
    }
  }

  /**
   * Returns a function which returns true when called with a value less than the specified value.
   *
   * @param value the value which other values will be compared with.
   */
  public static function lessThan( value:* ):Function {
    return function( val:* ):Boolean {
      return val < value;
    };
  }

  /**
   * Returns a function which returns true when called with a value less than or equal to the
   * specified value.
   *
   * @param value the value which other values will be compared with.
   */
  public static function lessEqual( value:* ):Function {
    return function( val:* ):Boolean {
      return val <= value;
    };
  }

  /**
   * Returns a function which returns true when called with a equal to than the specified value.
   *
   * @param value the value which other values will be compared with.
   */
  public static function equal( value:* ):Function {
    return function( val:* ):Boolean {
      return val == value;
    };
  }

  /**
   * Returns a function which returns true when called with a value not equal to the specified
   * value.
   *
   * @param value the value which other values will be compared with.
   */
  public static function notEqual( value:* ):Function {
    return function( val:* ):Boolean {
      return val != value;
    };
  }

  /**
   * Returns a function which returns true when called with a value greater than or equal to the
   * specified value.
   *
   * @param value the value which other values will be compared with.
   */
  public static function greaterEqual( value:* ):Function {
    return function( val:* ):Boolean {
      return val >= value;
    };
  }

  /**
   * Returns a function which returns true when called with a value greater than the specified
   * value.
   *
   * @param value the value which other values will be compared with.
   */
  public static function greaterThan( value:* ):Function {
    return function( val:* ):Boolean {
      return val > value;
    };
  }

  /**
   * Returns whether the value's length property is zero
   *
   * @param value the value to check for zero length.
   */
  public static function isEmpty( value:* ):Boolean {
    return value == null || value.length == 0;
  }

  /**
   * Returns whether the value's length property is greater than zero
   *
   * @param value the value to check for non-zero length.
   */
  public static function isNotEmpty( value:* ):Boolean {
    return value != null && value.length > 0;
  }

}

}