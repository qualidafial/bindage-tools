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

package com.googlecode.bindagetools.matchers {
import com.googlecode.bindagetools.mockito.callFunction;

import org.hamcrest.Description;
import org.hamcrest.Matcher;
import org.hamcrest.StringDescription;
import org.hamcrest.assertThat;
import org.hamcrest.object.equalTo;
import org.mockito.integrations.any;
import org.mockito.integrations.flexunit4.MockitoClassRunner;
import org.mockito.integrations.given;
import org.mockito.integrations.verify;

[RunWith( "org.mockito.integrations.flexunit4.MockitoClassRunner")]
public class XorMatcherTest {

  private var foo:MockitoClassRunner;

  public function XorMatcherTest() {
  }

  [Mock]
  public var a:Matcher;

  [Mock]
  public var b:Matcher;

  [Before]
  public function setUp():void {
    mockDescribeTo(a, "a");
    mockDescribeTo(b, "b");
  }

  [Test]
  public function describeTo():void {
    var description:StringDescription = new StringDescription();
    xor(a, b).describeTo(description);

    verify().that(a.describeTo(any()));
    verify().that(b.describeTo(any()));

    assertThat(description.toString(),
               equalTo("'a' xor 'b'"));
  }

  private function mockDescribeTo( mock:Matcher,
                                   descriptionString:String ):void {
    var mockDescribeTo:Function = function( description:Description ):void {
      description.appendText(descriptionString);
    };

    given(mock.describeTo(any()))
        .will(callFunction(mockDescribeTo));
  }

  [Test]
  public function matchesFalseXorFalse():void {
    given(a.matches(any())).willReturn(false);
    given(b.matches(any())).willReturn(false);

    assertThat(xor(a, b).matches("item"),
               equalTo(false));

    verify().that(a.matches(any()));
    verify().that(b.matches(any()));
  }

  [Test]
  public function matchesFalseXorTrue():void {
    given(a.matches(any())).willReturn(false);
    given(b.matches(any())).willReturn(true);

    assertThat(xor(a, b).matches("item"),
               equalTo(true));

    verify().that(a.matches(any()));
    verify().that(b.matches(any()));
  }

  [Test]
  public function matchesTrueXorFalse():void {
    given(a.matches(any())).willReturn(true);
    given(b.matches(any())).willReturn(false);

    assertThat(xor(a, b).matches("item"),
               equalTo(true));

    verify().that(a.matches(any()));
    verify().that(b.matches(any()));
  }

  [Test]
  public function matchesTrueXorTrue():void {
    given(a.matches(any())).willReturn(true);
    given(b.matches(any())).willReturn(true);

    assertThat(xor(a, b).matches("item"),
               equalTo(false));

    verify().that(a.matches(any()));
    verify().that(b.matches(any()));
  }

  [Test]
  public function describeMismatch():void {
    given(a.matches(any())).willReturn(true);
    given(b.matches(any())).willReturn(true);

    var description:StringDescription = new StringDescription();

    xor(a, b).describeMismatch("item", description);

    verify().that(a.describeTo(description));
    verify().that(b.describeTo(description));

    assertThat(description.toString(),
               equalTo("Both 'a' and 'b' were <true>"));
  }

}

}
