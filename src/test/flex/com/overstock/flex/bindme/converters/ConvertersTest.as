package com.overstock.flex.bindme.converters {
import org.flexunit.assertThat;
import org.hamcrest.object.equalTo;

public class ConvertersTest {

  function ConvertersTest() {
  }

  [Test]
  public function testAlways():void {
    var expected:Object = new Object();

    var converter:Function = always(expected);

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
  public function testAny():void {
    assertThat(any(),
               equalTo(false));
    assertThat(any(false),
               equalTo(false));
    assertThat(any(true),
               equalTo(true));
    assertThat(any("non-empty string"),
               equalTo(true));
    assertThat(any(null, false, ""),
               equalTo(false));
  }

  [Test]
  public function testEmptyToNull():void {
    assertThat(emptyToNull(null),
               equalTo(null));
    assertThat(emptyToNull(""),
               equalTo(null));
    assertThat(emptyToNull("abc"),
               equalTo("abc"));
  }

  [Test]
  public function testMax():void {
    assertThat(max(),
               equalTo(null));
    assertThat(max(null, 1),
               equalTo(1));
    assertThat(max(3, 5, 1),
               equalTo(5));
  }

  [Test]
  public function testMin():void {
    assertThat(min(),
               equalTo(null));
    assertThat(min(null, 1),
               equalTo(1));
    assertThat(min(3, 5, 1),
               equalTo(1));
  }

  [Test]
  public function testNegate():void {
    assertThat(negate(false),
               equalTo(true));
    assertThat(negate(true),
               equalTo(false));

    assertThat(negate(null),
               equalTo(true));
    assertThat(negate(""),
               equalTo(true));
    assertThat(negate("non-empty string"),
               equalTo(false));
    assertThat(negate({ some: "object" }),
               equalTo(false));
  }

  [Test]
  public function testNumberToString():void {
    assertThat(numberToString(null),
               equalTo(null));
    assertThat(numberToString(NaN),
               equalTo("NaN"));
    assertThat(numberToString(1.2),
               equalTo("1.2"));
  }

  [Test]
  public function testStringToNumber():void {
    assertThat(stringToNumber(null),
               equalTo(null));

    assertThat(stringToNumber(""),
               equalTo(null));

    assertThat(stringToNumber("1"),
               equalTo(1));
  }

}

}