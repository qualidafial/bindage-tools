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

package com.googlecode.bindagetools {

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
   * Runs the given pipeline if this group is not already running another pipeline.  If this group
   * is already running another pipeline, no action is taken.
   *
   * @param pipeline the pipeline to run
   * @param args the arguments to send to the pipeline.
   */
  public function runExclusively( pipeline:IPipeline,
                                  args:Array ):void {
    if (!running) {
      try {
        running = true;
        pipeline.run(args);
      } finally {
        running = false;
      }
    }
  }

}

}
