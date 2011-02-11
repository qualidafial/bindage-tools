package com.overstock.bindme.converters {
import org.flexunit.assertThat;
import org.hamcrest.object.equalTo;

public class ToBooleanInverseTest {

  function ToBooleanInverseTest() {
  }

  [Test]
  public function testToBooleanInverse():void {
    var converter:Function = toBooleanInverse();
    assertThat(converter(false),
               equalTo(true));
    assertThat(converter(true),
               equalTo(false));

    assertThat(converter(null),
               equalTo(true));
    assertThat(converter(""),
               equalTo(true));
    assertThat(converter("non-empty string"),
               equalTo(false));
    assertThat(converter({ some: "object" }),
               equalTo(false));
  }

}

}