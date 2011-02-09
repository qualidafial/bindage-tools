package com.overstock.bindme.converters {
import org.flexunit.assertThat;
import org.hamcrest.Matcher;
import org.hamcrest.object.equalTo;
import org.mockito.integrations.given;
import org.mockito.integrations.verify;

[RunWith( "org.mockito.integrations.flexunit4.MockitoClassRunner" )]
public class ConvertersTest {

  function ConvertersTest() {
  }

  [Mock]
  public var matcher:Matcher;

  [Test]
  public function testEmptyStringToNull():void {
    assertThat(emptyStringToNull(null),
               equalTo(null));
    assertThat(emptyStringToNull(""),
               equalTo(null));
    assertThat(emptyStringToNull("abc"),
               equalTo("abc"));
  }

  [Test]
  public function testToBooleanInverse():void {
    assertThat(toBooleanInverse(false),
               equalTo(true));
    assertThat(toBooleanInverse(true),
               equalTo(false));

    assertThat(toBooleanInverse(null),
               equalTo(true));
    assertThat(toBooleanInverse(""),
               equalTo(true));
    assertThat(toBooleanInverse("non-empty string"),
               equalTo(false));
    assertThat(toBooleanInverse({ some: "object" }),
               equalTo(false));
  }

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

  [Test]
  public function testToMaximum():void {
    assertThat(toMaximum(),
               equalTo(null));
    assertThat(toMaximum(null, 1),
               equalTo(1));
    assertThat(toMaximum(3, 5, 1),
               equalTo(5));
  }

  [Test]
  public function testToMinimum():void {
    assertThat(toMinimum(),
               equalTo(null));
    assertThat(toMinimum(null, 1),
               equalTo(1));
    assertThat(toMinimum(3, 5, 1),
               equalTo(1));
  }

  [Test]
  public function testToNumber():void {
    assertThat(toNumber(null),
               equalTo(null));

    assertThat(toNumber(""),
               equalTo(null));

    assertThat(toNumber("1"),
               equalTo(1));
  }

  [Test]
  public function testToValue():void {
    var expected:Object = new Object();

    var converter:Function = toValue(expected);

    assertThat(converter(),
               equalTo(expected));
    assertThat(converter(null),
               equalTo(expected));
    assertThat(converter(1),
               equalTo(expected));
    assertThat(converter("derp"),
               equalTo(expected));
    assertThat(converter(false),
               equalTo(expected));
    assertThat(converter(1, 2, 3),
               equalTo(expected));
    assertThat(converter(1, null, "herp a derp", true),
               equalTo(expected));
  }

  [Test]
  public function testValueToString():void {
    assertThat(valueToString(null),
               equalTo(null));
    assertThat(valueToString(NaN),
               equalTo("NaN"));
    assertThat(valueToString(1.2),
               equalTo("1.2"));
  }

}

}