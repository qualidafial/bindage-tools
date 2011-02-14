package com.overstock.bindme.converters {
import org.flexunit.assertThat;
import org.hamcrest.object.equalTo;

public class TrimStringToNullTest {

  function TrimStringToNullTest() {
  }

  [Test]
  public function testTrimStringToNull():void {
    var converter:Function = trimStringToNull();
    assertThat(converter(null),
               equalTo(null));
    assertThat(converter(""),
               equalTo(null));
    assertThat(converter(" "),
               equalTo(null));
    assertThat(converter("\t"),
               equalTo(null));
    assertThat(converter("\n"),
               equalTo(null));
    assertThat(converter("abc"),
               equalTo("abc"));
    assertThat(converter("   abc"),
               equalTo("abc"));
    assertThat(converter("abc   "),
               equalTo("abc"));

    assertThat(converter("abc xyz"),
               equalTo("abc xyz"));
    assertThat(converter("  abc xyz"),
               equalTo("abc xyz"));
    assertThat(converter("abc xyz  "),
               equalTo("abc xyz"));
  }

}

}