/*
 * The contents of this file are subject to the Mozilla Public License
 * Version 1.1 (the "License"); you may not use this file except in
 * compliance with the License. You may obtain a copy of the License at
 * http://www.mozilla.org/MPL/
 * 
 * Software distributed under the License is distributed on an "AS IS"
 * basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the
 * License for the specific language governing rights and limitations
 * under the License.
 * 
 * The Original Code is "BindMe Data Binding Framework for Flex ActionScript 3."
 * 
 * The Initial Developer of the Original Code is Overstock.com.
 * Portions created by Overstock.com are Copyright (C) 2011.
 * All Rights Reserved.
 * 
 * Contributor(s):
 * - Matthew Hall, Overstock.com <qualidafial@gmail.com> 
 */

package com.overstock.bindme.matchers {
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
