/*
 * Copyright 2011 Overstock.com and others.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.googlecode.bindagetools.converters {
import org.flexunit.assertThat;
import org.hamcrest.Matcher;
import org.hamcrest.collection.hasItem;
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

  [Test]
  public function testToConditionMultipleValue():void {
    var converter:Function = toCondition(hasItem(equalTo("a")));

    assertThat(converter("a", "b"),
               equalTo(true));
    assertThat(converter("b", "c"),
               equalTo(false));
  }

}

}
