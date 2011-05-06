package com.googlecode.bindagetools.matchers {
import org.hamcrest.StringDescription;
import org.hamcrest.assertThat;
import org.hamcrest.object.equalTo;

public class IsNumericMatcherTest {

  private var matcher:IsNumericMatcher;

  public function IsNumericMatcherTest() {
  }

  [Before]
  public function setUp():void {
    matcher = new IsNumericMatcher();
  }

  [Test]
  public function matches():void {
    assertThat(matcher.matches(""),
               equalTo(true));
    assertThat(matcher.matches(" "),
               equalTo(true));
    assertThat(matcher.matches("a"),
               equalTo(false));
    assertThat(matcher.matches("1"),
               equalTo(true));
    assertThat(matcher.matches("1."),
               equalTo(true));
    assertThat(matcher.matches("1.1"),
               equalTo(true));
    assertThat(matcher.matches(".1"),
               equalTo(true));
  }

  [Test]
  public function describeTo():void {
    var description:StringDescription = new StringDescription();
    matcher.describeTo(description);

    assertThat(description.toString(),
               equalTo("numeric value"));
  }

  [Test]
  public function describeMismatch():void {
    var description:StringDescription = new StringDescription();

    matcher.describeMismatch("text", description);

    assertThat(description.toString(),
               equalTo("\"text\" is not numeric"));
  }

}

}