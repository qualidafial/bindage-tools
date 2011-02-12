package com.overstock.bindme.matchers {
import org.hamcrest.Matcher;

/**
 * Returns a Hamcrest matcher for the exclusive-or of conditions <code>a</code> and <code>b</code>.
 *
 * @param a the first condition
 * @param b the second condition
 */
public function xor( a:Matcher,
                     b:Matcher ):Matcher {
  return new XorMatcher(a, b);
}

}
