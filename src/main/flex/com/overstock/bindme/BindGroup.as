package com.overstock.bindme {

/**
 * Defines a group of data bindings.  Grouping data bindings (via
 * <code>IPipelineBuilder.group(BindGroup)</code>) ensures that only one binding in the group can
 * be executing at a time.  This helps prevent common problems where two or more related bindings
 * can make undesired round-trips, possibly overwriting data at inappropriate times.
 *
 * <p>
 * Example: suppose an ungrouped, two-way binding exists between a text input and a bindable
 * field in the model. We want to store text in uppercase only, so the UI-to-model binding
 * converts the string to uppercase.  Now suppose the user moves the cursor to the beginning of
 * the text input and starts typing.
 * <ul>
 *   <li>The first character entered will fire a change event, triggering the UI-to-model
 *   binding</li>
 *   <li>The UI-to-model binding overwrites the model with the new text field contents.
 *   Suppose, for the sake of argument, that the text is converted to uppercase by the
 *   binding.</li>
 *   <li>The change to the model triggers the model-to-UI binding.</li>
 *   <li>The model-to-UI binding sets the now uppercase text to the text field. Because the new
 *   text is different (uppercase vs lowercase) than the old text, the text input resets the
 *   cursor to the end of the field.</li>
 *   <li>Now that the cursor is at the end of the field, every successive keystroke will
 *   insert at the end of the field, instead of where the user placed the cursor.</li>
 * </ul>
 * </p>
 *
 * <p>
 * Grouping bindings helps solve this type of problem.  When two or more bindings form a loop,
 * they should be grouped so that round-trip problems do not cause unexpected behavior.
 * </p>
 */
public class BindGroup {

  private var running:Boolean;

  public function BindGroup() {
    running = false;
  }

  /**
   * Calls the given function if this group is not already calling another function.  If this
   * group is already calling another function, no action is taken.
   *
   * @param func the function to call
   * @param rest the arguments to use when calling the function.
   */
  public function callExclusively( func:Function,
                                   ...rest ):* {
    var result:Object = null;

    if (!running) {
      try {
        running = true;
        result = func.apply(null, rest);
      } finally {
        running = false;
      }
    }

    return result;
  }

}

}
