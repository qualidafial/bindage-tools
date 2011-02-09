package com.overstock.bindme.util {
import mx.binding.utils.ChangeWatcher;

/**
 * Calls <code>unwatch()</code> and <code>setHandler(null)</code> on each of the specified
 * ChangeWatchers.
 * @param watchers an array of ChangeWatchers.
 */
public function unwatchAll( watchers:Array ):void {
  for each (var watcher:ChangeWatcher in watchers) {
    watcher.unwatch();
    watcher.setHandler(null);
  }
}

}
