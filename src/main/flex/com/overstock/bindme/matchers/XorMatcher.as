package com.overstock.bindme.matchers {
import org.hamcrest.Description;
import org.hamcrest.Matcher;

public class XorMatcher implements Matcher {
  private var a:Matcher;
  private var b:Matcher;

  public function XorMatcher( a:Matcher,
                              b:Matcher ) {
    this.a = a;
    this.b = b;
  }

  public function describeTo( description:Description ):void {
    description
        .appendText("'")
        .appendDescriptionOf(a)
        .appendText("' xor '")
        .appendDescriptionOf(b)
        .appendText("'");
  }

  public function matches( item:Object ):Boolean {
    var condA:Boolean = a.matches(item);
    var condB:Boolean = b.matches(item);
    return condA != condB;
  }

  public function describeMismatch( item:Object,
                                    mismatchDescription:Description ):void {
    mismatchDescription
        .appendText("Both '")
        .appendDescriptionOf(a)
        .appendText("' and '")
        .appendDescriptionOf(b)
        .appendText("' were ")
        .appendValue(a.matches(item));
  }
}
}
