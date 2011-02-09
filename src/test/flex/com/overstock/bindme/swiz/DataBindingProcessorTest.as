package com.overstock.bindme.swiz {
import org.hamcrest.assertThat;
import org.hamcrest.object.equalTo;
import org.swizframework.core.Bean;
import org.swizframework.reflection.MetadataHostMethod;

public class DataBindingProcessorTest {

  private var dataBindingBean:DataBindingBean;
  private var metadataTag:DataBindingMetadataTag;
  private var swizBean:Bean;
  private var processor:DataBindingProcessor;

  public function DataBindingProcessorTest() {
  }

  [Before]
  public function setUp():void {
    dataBindingBean = new DataBindingBean();

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
    dataBindingBean.foo = 1;

    processor.setUpMetadataTag(metadataTag, swizBean);

    assertThat(dataBindingBean.bar,
               equalTo(1));

    dataBindingBean.foo = 2;

    assertThat(dataBindingBean.bar,
               equalTo(2));

    processor.tearDownMetadataTag(metadataTag, swizBean);

    dataBindingBean.foo = 3;

    assertThat(dataBindingBean.bar,
               equalTo(2)); // bindings disposed, no change.
  }

}

}
