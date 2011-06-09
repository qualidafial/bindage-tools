package com.googlecode.bindagetools.matchers {
import org.hamcrest.Matcher;

/**
 * Returns a Hamcrest matcher for numeric strings. Note that <code>null</code>, empty or
 * whitespace-only strings are treated as matches.  More precisely, anything that the built-in
 * <code>Number()</code> function convert to <code>NaN</code> is <em>not</em> a match.
 */
public function isNumeric():Matcher {
  return new IsNumericMatcher();
}

}