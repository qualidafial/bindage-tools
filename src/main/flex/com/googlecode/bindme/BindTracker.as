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

package com.googlecode.bindme {
import mx.binding.utils.ChangeWatcher;

/**
 * Helper API for tracking the <code>ChangeWatcher</code> instances created by the
 * <code>Bind</code> class, so that they can be disposed of properly.  If your application
 * regularly creates and discards databound elements, this class can help clean up bindings from
 * discarded elements to avoid memory leaks.
 */
public class BindTracker {

  /**
   * @private
   */
  public function BindTracker() {
  }

  private static var collected:Array;

  /**
   * Executes the specified function, then returns an array of all ChangeWatchers created through
   * the Bind class in the course of the function's execution.
   *
   * <p>
   * Clients which use this method can destroy any of the created bindings by calling
   * <code>unwatchAll(watchers)</code> on the returned array.
   * </p>
   *
   * @param func the function to execute and collect bindings from
   * @param rest the arguments to pass to the specified function
   */
  public static function collect( func:Function,
                                  ...rest ):Array {
    var oldCollected:Array = collected;

    collected = [];

    var result:Array;
    try {
      func.apply(null, rest);
      result = collected;
    } finally {
      collected = oldCollected == null
          ? null
          : oldCollected.concat(collected);
    }

    return result;
  }

  /**
   * Called internally whenever a binding pipeline creates a ChangeWatcher.
   * @param changeWatcher the change watcher that was created.
   * @see com.googlecode.bindme.IPipelineBuilder.watch
   * @private
   */
  public static function changeWatcherCreated( changeWatcher:ChangeWatcher ):void {
    if (collected != null) {
      collected.push(changeWatcher);
    }
  }

}

}
