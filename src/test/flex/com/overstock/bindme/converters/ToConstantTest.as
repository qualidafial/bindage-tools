package com.overstock.bindme.converters {
import org.flexunit.assertThat;
import org.hamcrest.object.equalTo;

public class ToConstantTest {

  function ToConstantTest() {
  }

  [Test]
  public function testToConstant():void {
    var expected:Object = new Object();

    var converter:Function = toConstant(expected);

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

}

}