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
import org.hamcrest.Description;
import org.hamcrest.Matcher;

/**
 * @private
 */
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
