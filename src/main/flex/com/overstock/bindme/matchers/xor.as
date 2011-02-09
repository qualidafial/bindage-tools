package com.overstock.bindme.matchers {
import org.hamcrest.Matcher;

public function xor( a:Matcher,
                     b:Matcher ):Matcher {
  return new XorMatcher(a, b);
}

}
