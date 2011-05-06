package com.googlecode.bindagetools.matchers {
import org.hamcrest.Matcher;

/**
 * Documentation for top-level functions in the BindMe matchers package.  The methods in this
 * class serve as documentation for the public functions in this package.
 *
 * <p>
 * <em>Note:</em> This class exists as a workaround to an asdoc bug in Flex 3, which causes
 * some top-level functions to be excluded from generated ASdoc.  We recommend that you use the
 * top-level functions directly.
 * </p>
 */
public class Matchers {

  /**
   * @private
   */
  function Matchers() {
  }

  /**
   * Returns a Hamcrest matcher for numeric strings. Note that <code>null</code>, empty or
   * whitespace-only strings are treated as matches.  More precisely, anything that the built-in
   * <code>Number()</code> function convert to <code>NaN</code> is <em>not</em> a match.
   */
  public static function isNumeric():Matcher {
    return com.googlecode.bindagetools.matchers.isNumeric();
  }

  /**
   * Returns a Hamcrest matcher for the exclusive-or of conditions <code>a</code> and
   * <code>b</code>.
   *
   * @param a the first condition
   * @param b the second condition
   */
  public static function xor(a:Matcher, b:Matcher):Matcher {
    return com.googlecode.bindagetools.matchers.xor(a, b);
  }

}

}