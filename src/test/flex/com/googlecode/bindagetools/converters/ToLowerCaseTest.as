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
import org.hamcrest.assertThat;
import org.hamcrest.object.equalTo;

public class ToLowerCaseTest {

  function ToLowerCaseTest() {
  }

  [Test]
  public function testToLowerCase():void {
    var converter:Function = toLowerCase();

    assertThat(converter(null),
               equalTo(null));
    assertThat(converter("abc"),
               equalTo("abc"));
    assertThat(converter("ABC"),
               equalTo("abc"));
  }

}

}