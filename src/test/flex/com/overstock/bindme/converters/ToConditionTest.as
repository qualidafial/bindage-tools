package com.overstock.bindme.converters {
import org.flexunit.assertThat;
import org.hamcrest.Matcher;
import org.hamcrest.object.equalTo;
import org.mockito.integrations.given;
import org.mockito.integrations.verify;

[RunWith( "org.mockito.integrations.flexunit4.MockitoClassRunner" )]
public class ToConditionTest {

  function ToConditionTest() {
  }

  [Mock]
  public var matcher:Matcher;

  [Test]
  public function testToCondition():void {
    given(matcher.matches("a")).willReturn(true);
    given(matcher.matches("b")).willReturn(false);

    var converter:Function = toCondition(matcher);
    assertThat(converter("a"),
               equalTo(true));
    assertThat(converter("b"),
               equalTo(false));

    verify().that(matcher.matches("a"));
    verify().that(matcher.matches("b"));
  }

}

}