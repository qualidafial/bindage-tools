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

package com.overstock.bindme.swiz {
import mx.core.Application;

import org.hamcrest.assertThat;
import org.hamcrest.object.equalTo;
import org.swizframework.core.Bean;
import org.swizframework.reflection.MetadataHostMethod;

public class DataBindingProcessorTest {

  private var metadataTag:DataBindingMetadataTag;
  private var swizBean:Bean;
  private var processor:DataBindingProcessor;

  public function DataBindingProcessorTest() {
  }

  private function setUpBean( dataBindingBean:Object ):void {
    var metadataHost:MetadataHostMethod = new MetadataHostMethod();
    metadataHost.metadataTags = [metadataTag];
    metadataHost.name = "init";

    metadataTag = new DataBindingMetadataTag();
    metadataTag.name = "DataBinding";
    metadataTag.host = metadataHost;
    metadataTag.args = [];

    swizBean = new Bean();
    swizBean.source = dataBindingBean;

    processor = new DataBindingProcessor();
  }

  [Test]
  public function setUpMetadataTag():void {
    var bean:DataBindingBean = new DataBindingBean();
    setUpBean(bean);

    bean.foo = 1;

    processor.setUpMetadataTag(metadataTag, swizBean);

    assertThat(bean.bar,
               equalTo(1));

    bean.foo = 2;

    assertThat(bean.bar,
               equalTo(2));

    processor.tearDownMetadataTag(metadataTag, swizBean);

    bean.foo = 3;

    assertThat(bean.bar,
               equalTo(2)); // bindings disposed, no change.
  }

  [Test]
  public function setUpMetadataTagUiComponentInitialized():void {
    var bean:DataBindingUiBean = new DataBindingUiBean();
    bean.initialized = true;
    setUpBean(bean);

    bean.foo = 1;

    processor.setUpMetadataTag(metadataTag, swizBean);

    assertThat(bean.bar,
               equalTo(1));

    bean.foo = 2;

    assertThat(bean.bar,
               equalTo(2));

    processor.tearDownMetadataTag(metadataTag, swizBean);

    bean.foo = 3;

    assertThat(bean.bar,
               equalTo(2)); // bindings disposed, no change.
  }

  [Test]
  public function setUpMetadataTagUiComponentUninitialized():void {
    var bean:DataBindingUiBean = new DataBindingUiBean();
    bean.initialized = false;
    setUpBean(bean);

    bean.foo = 1;
    bean.bar = 0;

    processor.setUpMetadataTag(metadataTag, swizBean);

    assertThat(bean.bar,
               equalTo(0)); // No change, data bindings not set up yet.

    Application(Application.application).addChild(bean);

    assertThat(bean.bar,
               equalTo(1));

    bean.foo = 2;

    assertThat(bean.bar,
               equalTo(2));

    processor.tearDownMetadataTag(metadataTag, swizBean);

    bean.foo = 3;

    assertThat(bean.bar,
               equalTo(2)); // bindings disposed, no change.
  }

}

}
