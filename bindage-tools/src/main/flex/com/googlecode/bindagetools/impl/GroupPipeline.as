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

package com.googlecode.bindagetools.impl {
import com.googlecode.bindagetools.BindGroup;
import com.googlecode.bindagetools.IPipeline;

public class GroupPipeline implements IPipeline {

  private var group:BindGroup;
  private var next:IPipeline;

  public function GroupPipeline( group:BindGroup, next:IPipeline ) {
    this.group = group;
    this.next = next;
  }

  public function run( args:Array ):void {
    group.callExclusively(next.run, args);
  }

}

}