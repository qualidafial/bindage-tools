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