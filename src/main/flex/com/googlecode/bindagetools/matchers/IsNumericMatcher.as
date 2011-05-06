package com.googlecode.bindagetools.matchers {
import org.hamcrest.Description;
import org.hamcrest.Matcher;

/**
 * @private
 */
public class IsNumericMatcher implements Matcher {

  public function IsNumericMatcher() {
  }

  public function describeTo( description:Description ):void {
    description.appendText("numeric value");
  }

  public function describeMismatch( item:Object, description:Description ):void {
    description
        .appendText("")
        .appendValue(item)
        .appendText(" is not numeric");
  }

  public function matches( item:Object ):Boolean {
    return !isNaN(Number(item));
  }
}
}