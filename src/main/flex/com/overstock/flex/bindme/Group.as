package com.overstock.flex.bindme {
import mx.logging.ILogger;
import mx.logging.Log;
import mx.logging.LogEventLevel;

/**
 * A non-reentrant lock for synchronizing access to bindable targets.
 */
public class Group {

  private static var _nextId:int = 0;

  private static function get nextId():int {
    var result:int = _nextId;
    _nextId++;
    return result;
  }

  private var locked:Boolean = false;

  private const logger:ILogger = Log.getLogger("com.overstock.merch.offerprocess.util.bind.Group");

  private var id:int;

  public var logLevel:int;

  /**
   * Constructs a new Lock.
   */
  public function Group() {
    this.id = nextId;
    this.logLevel = LogEventLevel.DEBUG;
  }

  /**
   * Runs the specified function while holding the lock.  If the lock cannot be acquired, no
   * action is taken.
   *
   * @param func the function to run while holding the lock
   * @param args the arguments to use when calling the function
   */
  public function acquireAndRun( func:Function,
                                 ... args ):* {
    if (func == null) {
      throw new ArgumentError("func argument was null");
    }

    var result:* = null;

    if (acquire()) {
      try {
        log("Enter function with args: ", args);

        result = func.apply(null, args);

        log("Exit function with args: ", args);
      }
      finally {
        release();
      }
    }
    else {
      log("Abort function invocation -- a different function is already running", args);
    }

    return result;
  }

  /**
   * Attempts to acquire the lock.  An acquired lock must be released before it can be acquired
   * again.
   *
   * @return whether the lock was acquired
   */
  public function acquire():Boolean {
    if (locked) {
      log("Failed to acquire lock");
      return false;
    }
    else {
      log("Lock acquired");
      locked = true;
      return true;
    }
  }

  /**
   * Releases the lock.
   *
   * @throws Error if the lock is not currently acquired.
   */
  public function release():void {
    if (locked) {
      log("Lock released");
      locked = false;
    }
    else {
      log("Attempted to release an unacquired lock!");
      throw new Error("Attempting to release an unacquired lock");
    }
  }

  private function log( message:String,
                        args:Array = null ):void {
    var logArgs:Array = [ logLevel, id + ": " + message ];
    if (args != null) {
      logArgs = logArgs.concat(args);
    }
    logger.log.apply(logger, logArgs);
  }

}
}