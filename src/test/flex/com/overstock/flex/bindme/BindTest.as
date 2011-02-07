package com.overstock.flex.bindme {
import com.overstock.flex.bindme.properties.Properties;

import flash.events.Event;

import mx.collections.ArrayCollection;
import mx.logging.ILogger;
import mx.logging.ILoggingTarget;
import mx.logging.Log;
import mx.logging.LogEvent;
import mx.logging.LogEventLevel;

import org.hamcrest.assertThat;
import org.hamcrest.collection.array;
import org.hamcrest.core.allOf;
import org.hamcrest.object.equalTo;
import org.hamcrest.object.hasProperties;
import org.hamcrest.object.instanceOf;
import org.hamcrest.object.notNullValue;

[Bindable]
public class BindTest implements ILoggingTarget {

  function BindTest() {
  }

  private var _source:Object;

  private var _source2:Object;

  private var _target:Object;

  private var log:Array;

  private var logEvents:Array;

  [Before]
  public function setUp():void {
    _source = null;
    _target = null;
    log = [];
    logEvents = [];

    Log.addTarget(this);
  }

  [After]
  public function tearDown():void {
    Log.removeTarget(this);
  }

  [Test]
  public function basicBind():void {
    _source = "abc";

    Bind.from(this, "source")
        .to(this, "target");

    assertThat(_target,
               equalTo("abc"));
    assertLogEquals([
                      "get source, value is abc",
                      "set target to abc"
                    ]);
  }

  [Test]
  public function bindConvert():void {
    _source = false;

    Bind.from(this, "source")
        .convert(negate)
        .to(this, "target");

    assertThat(_target,
               equalTo(true));
    assertLogEquals([
                      "get source, value is false",
                      "convert false to true",
                      "set target to true"
                    ]);
  }

  private function negate( value:Boolean ):Boolean {
    log.push("convert " + value + " to " + !value);
    return !value;
  }

  [Test]
  public function bindValidateConvert():void {
    _source = false;

    Bind.from(this, "source")
        .validate(isFalse)
        .convert(negate)
        .to(this, "target");

    assertThat(_target,
               equalTo(true));
    assertLogEquals([
                      "get source, value is false",
                      "validate false is false",
                      "convert false to true",
                      "set target to true"
                    ]);
  }

  private function isFalse( value:Boolean ):Boolean {
    log.push("validate " + value + " is false");
    return !value;
  }

  [Test]
  public function bindChangeSource():void {
    _source = 1;
    Bind.from(this, "source")
        .to(this, "target");
    clearLog();

    source = 2;

    assertThat(_target,
               equalTo(2));
    assertLogEquals([
                      "set source to 2",
                      "get source, value is 2",
                      "set target to 2"
                    ]);
  }

  [Test]
  public function twoWay():void {
    _source = 1;

    Bind.twoWay(
        Bind.from(this, "source"),
        Bind.from(this, "target"));

    assertThat(_target,
               equalTo(1));
    assertLogEquals([
                      "get source, value is 1",
                      "set target to 1",
                      "get target, value is 1"
                    ]);
    clearLog();

    target = 2;

    assertThat(_source,
               equalTo(2));
    assertLogEquals([
                      "set target to 2",
                      "get target, value is 2",
                      "set source to 2",
                      "get source, value is 2"
                    ]);
  }

  [Test]
  public function collect():void {
    function createBindings():void {
      Bind.from(this, "source")
          .to(this, "target");
    }

    var collected:Array = Bind.collect(createBindings);

    assertThat(collected,
               notNullValue());
    assertThat(collected.length,
               equalTo(1));
    assertThat(collected[0],
               notNullValue());
  }

  [Test]
  public function collect_Nested():void {
    var expected:Array = null;

    function createBindings():void {
      Bind.from(this, "source")
          .to(this, "target");
    }

    function collectBindings():void {
      expected = Bind.collect(createBindings);
    }

    var actual:Array = Bind.collect(collectBindings);

    assertThat(expected,
               notNullValue());
    assertThat(expected.length,
               equalTo(1));

    assertThat(actual,
               notNullValue());
    assertThat(actual.length,
               equalTo(1));

    assertThat(actual[0],
               equalTo(expected[0]));
  }

  [Test]
  public function bindFromNestedProperty_Initial():void {
    _source = new Array();
    _source.foo = new ArrayCollection([ "value" ]);

    var sourceProperty:Property = Property.make("source.foo").chain(Properties.itemAt(0));
    Bind.from(this, sourceProperty)
        .to(this, "target");

    assertThat(_target,
               equalTo("value"));
  }

  [Test]
  public function bindFromNestedProperty_Update():void {
    _source = new Array();
    var collection:ArrayCollection = new ArrayCollection([ null ]);
    _source.foo = collection;

    var sourceProperty:Property = Property.make("source.foo").chain(Properties.itemAt(0));
    Bind.from(this, sourceProperty)
        .to(this, "target");
    collection.setItemAt("new value", 0);

    assertThat(_target,
               equalTo("new value"));
  }

  [Test]
  public function bindToNestedProperty_Initial():void {
    _source = "value";
    _target = new Array();
    var collection:ArrayCollection = new ArrayCollection([ null ]);
    _target.foo = collection;

    var targetProperty:Property = Property.make("target.foo").chain(Properties.itemAt(0));
    Bind.from(this, "source")
        .to(this, targetProperty);

    assertThat(collection.getItemAt(0),
               equalTo("value"));
  }

  [Test]
  public function bindToNestedProperty_Update():void {
    _source = "old value";
    _target = new Array();
    var collection:ArrayCollection = new ArrayCollection([ null ]);
    _target.foo = collection;

    var targetProperty:Property = Property.make("target.foo").chain(Properties.itemAt(0));
    Bind.from(this, "source")
        .to(this, targetProperty);
    source = "new value";

    assertThat(collection.getItemAt(0),
               equalTo("new value"));
  }

  [Test]
  public function bindFromAll_Initial():void {
    _source = 2;
    _source2 = 3;
    _target = null;

    Bind.fromAll(
        Bind.from(this, 'source'),
        Bind.from(this, 'source2')
        )
        .convert(multiply)
        .to(this, 'target');

    assertThat(_target,
               equalTo(6));
  }

  private function multiply( a:Number,
                             b:Number ):Number {
    return a * b;
  }

  [Test]
  public function bindFromAll_Update():void {
    _source = 'abc';
    _source2 = 'xyz';
    _target = null;

    Bind.fromAll(
        Bind.from(this, 'source'),
        Bind.from(this, 'source2')
        )
        .convert(add)
        .to(this, 'target');

    assertThat(_target,
               equalTo("abcxyz"));

    source = 'ABC';

    assertThat(_target,
               equalTo('ABCxyz'));

    source2 = 'XYZ';

    assertThat(_target,
               equalTo('ABCXYZ'));
  }

  private function add( a:*,
                        b:* ):* {
    return a + b;
  }

  [Test]
  public function testLog():void {
    _source = "abc";

    Bind.from(this, 'source')
        .logInfo("value is '{0}'")
        .to(this, 'target');

    assertThat(logEvents.length,
               equalTo(1));
    assertLogEvent(LogEventLevel.INFO, "value is 'abc'", logEvents[0]);

    source = "xyz";

    assertThat(logEvents.length,
               equalTo(2));
    assertLogEvent(LogEventLevel.INFO, "value is 'xyz'", logEvents[1]);
  }

  [Test]
  public function testLog_AdditionalParameters():void {
    _source = "abc";

    Bind.from(this, 'source')
        .logWarn("source is '{0}'")
        .to(this, 'target');

    assertThat(logEvents,
               array(allOf(instanceOf(LogEvent),
                           hasProperties({
                                           level: LogEventLevel.WARN,
                                           message: "source is 'abc'"
                                         }))));

    source = "xyz";

    assertThat(logEvents,
               array(
                   allOf(instanceOf(LogEvent),
                         hasProperties({
                                         level: LogEventLevel.WARN,
                                         message: "source is 'abc'"
                                       })),

                   allOf(instanceOf(LogEvent),
                         hasProperties({
                                         level: LogEventLevel.WARN,
                                         message: "source is 'xyz'"
                                       }))));

    assertThat(logEvents.length,
               equalTo(2));
    assertLogEvent(LogEventLevel.WARN, "source is 'xyz'", logEvents[1]);
  }

  private function assertLogEvent( expectedLevel:int,
                                   expectedMessage:String,
                                   event:LogEvent ):void {
    assertThat(event.level,
               equalTo(expectedLevel));
    assertThat(event.message,
               equalTo(expectedMessage));
  }

  [Test]
  public function format():void {
    _source = "children";

    Bind.from(this, 'source')
        .format('Hello, {0}!')
        .to(this, 'target');

    assertThat(_target,
               equalTo('Hello, children!'));

  }

  [Test]
  public function format_MultipleSources():void {
    _source = "Hey";
    _source2 = "Chef";

    Bind.fromAll(
        Bind.from(this, 'source'),
        Bind.from(this, 'source2')
        )
        .format('{0}, {1}.')
        .to(this, 'target');

    assertThat(_target,
               equalTo("Hey, Chef."));
  }

  // ILoggingTarget interface implementation

  public function get filters():Array {
    return [ 'com.overstock.merch.offerprocess.util.bind.Bind' ];
  }

  public function set filters( ignored:Array ):void {
  }

  public function get level():int {
    return LogEventLevel.DEBUG;
  }

  public function set level( ignored:int ):void {
  }

  public function addLogger( logger:ILogger ):void {
    if (logger) {
      logger.addEventListener(LogEvent.LOG, handleLogEvent);
    }
  }

  public function removeLogger( logger:ILogger ):void {
    if (logger) {
      logger.removeEventListener(LogEvent.LOG, handleLogEvent);
    }
  }

  private function handleLogEvent( event:LogEvent ):void {
    logEvents.push(event);
  }

  // end ILoggingTarget interface implementation

  private function clearLog():void {
    log = [];
  }

  [Bindable(event="sourceChanged")]
  public function get source():Object {
    log.push("get source, value is " + _source);
    return _source;
  }

  public function set source( value:Object ):void {
    log.push("set source to " + value);
    _source = value;
    dispatchEvent(new Event("sourceChanged"));
  }

  public function get source2():Object {
    log.push("get source2, value is " + _source2);
    return _source2;
  }

  public function set source2( value:Object ):void {
    log.push("set source2 to " + value);
    _source2 = value;
    dispatchEvent(new Event("source2Changed"));
  }

  [Bindable(event="targetChanged")]
  public function get target():Object {
    log.push("get target, value is " + _target);
    return _target;
  }

  public function set target( value:Object ):void {
    log.push("set target to " + value);
    _target = value;
    dispatchEvent(new Event("targetChanged"));
  }

  private function assertLogEquals( expected:Array ):void {
    assertThat(log.length,
               equalTo(expected.length));
    for (var i:int = 0; i < expected.length; i++) {
      assertThat("log[" + i + "] different than expected",
                 log[i],
                 equalTo(expected[i]));
    }
  }

}
}