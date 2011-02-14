package com.overstock.bindme.swiz {
import com.overstock.bindme.BindTracker;
import com.overstock.bindme.util.unwatchAll;

import flash.utils.Dictionary;

import mx.events.FlexEvent;
import mx.logging.ILogger;
import mx.logging.Log;
import mx.managers.ILayoutManagerClient;
import mx.utils.UIDUtil;

import org.swizframework.core.Bean;
import org.swizframework.processors.BaseMetadataProcessor;
import org.swizframework.reflection.IMetadataTag;

/**
 * Swiz metadata processor for methods that set up data bindings.  By default, this class
 * processes any public methods annotated with <code>[DataBinding]</code>.
 *
 * <p>
 * Any bindings created in a <code>[DataBinding]</code> method are managed by this
 * processor.  When the view or bean is torn down, all data bindings created during
 * set up are automatically disposed.
 * </p>
 *
 * <p>
 * UI controls (i.e. any instance of ILayoutManagerClient) are not set up until after
 * <code>FlexEvent.CREATION_COMPLETE</code>.
 * </p>
 */
public class DataBindingProcessor extends BaseMetadataProcessor {

  // ========================================
  // protected static constants
  // ========================================

  protected static const DATA_BINDING:String = "DataBinding";

  // ========================================
  // protected properties
  // ========================================

  protected var logger:ILogger = Log.getLogger(
      "com.overstock.cs.creditterminal.processors.DataBindingProcessor");

  protected var changeWatchersBySource:Dictionary = new Dictionary();

  // ========================================
  // constructor
  // ========================================

  /**
   * Constructor
   * @param metadataNames array of metadata names this processor will process
   */
  public function DataBindingProcessor( metadataNames:Array = null ) {
    super(metadataNames == null
        ? [ DATA_BINDING ]
        : metadataNames,
          DataBindingMetadataTag);
  }

  // ========================================
  // protected methods
  // ========================================

  override public function setUpMetadataTag( metadataTag:IMetadataTag,
                                             bean:Bean ):void {
    var bindingsTag:DataBindingMetadataTag = metadataTag as DataBindingMetadataTag;

    var source:Object = bean.source;
    var method:Function = source[bindingsTag.host.name];

    if (source is ILayoutManagerClient && !ILayoutManagerClient(source).initialized) {
      logger.info("deferring bindings setup -- source: {0}, method: {1}",
                  source,
                  bindingsTag.host.name);

      function initBindings( event:FlexEvent ):void {
        logger.info("setting up deferred bindings -- source {0}, method: {1}",
                    source,
                    bindingsTag.host.name);

        setUpBindings(source, method);
        ILayoutManagerClient(source).removeEventListener(FlexEvent.INITIALIZE, initBindings);
      }

      ILayoutManagerClient(source).addEventListener(FlexEvent.INITIALIZE, initBindings);
    }
    else {
      logger.debug("setting up immediate bindings -- source {0}, method {1}",
                   source,
                   bindingsTag.host.name);

      setUpBindings(source, method);
    }
  }

  private function setUpBindings( source:Object,
                                  method:Function ):void {
    var uid:String = UIDUtil.getUID(source);

    var changeWatchers:Array = BindTracker.collect(method);

    logger.debug("created {0} bindings",
                 changeWatchers.length,
                 source,
                 uid);

    changeWatchersBySource[uid] ||= [];
    changeWatchersBySource[uid] = changeWatchersBySource[uid].concat(changeWatchers);
  }

  override public function tearDownMetadataTag( metadataTag:IMetadataTag,
                                                bean:Bean ):void {
    var source:Object = bean.source;
    var uid:String = UIDUtil.getUID(source);

    var changeWatchers:Array = changeWatchersBySource[uid];
    if (changeWatchers != null) {
      logger.debug("tearing down {0} bindings -- source: {1}, uid: {2}",
                   changeWatchers.length,
                   source,
                   uid);

      unwatchAll(changeWatchers);

      delete changeWatchersBySource[uid];
    }
  }

}

}
