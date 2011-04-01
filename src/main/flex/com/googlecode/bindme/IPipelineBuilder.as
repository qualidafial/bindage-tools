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

package com.googlecode.bindme {

/**
 * Builder interface for data binding pipelines.
 *
 * <p><em>Note</em>: This interface is not intended to be implemented directly by clients.  Clients
 * should instead extend one of the included implementations of this interface.  In future
 * versions, new methods might be added to this interface, which would break any direct
 * implementations.</p>
 */
public interface IPipelineBuilder {

  /**
   * Appends the given step to the end of this binding pipeline.
   * @param step the pipeline step to append.
   * @return this IPipelineStep instance for method chaining.
   */
  function append( step:IPipelineStep ):IPipelineBuilder;

  /**
   * Appends a conversion step to the end of the binding pipeline.  During this step, the current
   * value(s) are passed to the converter function, and the value returned from the converter will
   * be sent to next step in the pipeline.
   *
   * <p>If this is a <code>fromAll</code> pipeline, all the values in the pipeline are passed to
   * the converter function in a single call, as successive arguments.</p>
   *
   * @param converter a function which accepts the value(s) in the binding pipeline, and returns
   * the converted value.
   * @return this IPipelineBuilder instance for method chaining.
   * @throws ArgumentError if the converter argument is null
   */
  function convert( converter:Function ):IPipelineBuilder;

  /**
   * Appends a delay step to the end of the binding pipeline.  Value(s) in the pipeline will be
   * held for <code>delay</code> milliseconds before sending them to the next step in the pipeline.
   * If any new value(s) are received before the delay has elapsed, the old value(s) are discarded,
   * and the delay starts over with the new value(s).
   *
   * @param delayMillis the delay in milliseconds.
   */
  function delay( delayMillis:int ):IPipelineBuilder;

  /**
   * Appends a formatting step to the end of the binding pipeline.  During this step, the current
   * value(s) are interpolated into the specified format string, and the resulting string is sent
   * to the next step in the pipeline.
   *
   * <p>Example:<pre>
   *   person.name = "John"; // {0}
   *   Bind.fromProperty(person, "name")
   *       .format("Welcome, {0}!")
   *       .toProperty(greetingLabel, "text"); // "Welcome, John!"
   * </pre></p>
   *
   * <p>In a <code>Bind.fromAll()</code> scenario, the first <code>Bind.from()</code> declared
   * will be represented by <code>{0}</code>, the second by <code>{1}</code>, and so on:<pre>
   *   person.firstName = "Me"
   *   person.lastName = "Hearty"
   *   Bind.fromAll(
   *       Bind.fromProperty(person, "firstName"), // {0}
   *       Bind.fromProperty(person, "lastName")   // {1}
   *       )
   *       .format("Ahoy, {0} {1}!", greetingString)
   *       .to(greetingLabel, "text"); // "Ahoy, Me Hearty!"
   * </pre></p>
   */
  function format( format:String ):IPipelineBuilder;

  /**
   * Prepends a step ensuring that this binding pipeline does not execute concurrently with any
   * other binding in the same group.  Binding groups are always enforced before any other steps in
   * the pipeline can occur.  Pipelines can belong to more than one group, but should not be added
   * to the same group twice.
   *
   * @param group the group the binding should be added to.
   * @return this IPipelineBuilder instance for method chaining.
   * @throws ArgumentError if the lock argument is null.
   */
  function group( group:BindGroup ):IPipelineBuilder;

  /**
   * Appends a logging step to the end of the binding pipeline.  The given message is sent to the
   * Bind class's logger before sending the current value to the next step in the pipeline.
   *
   * @param logLevel log level constant defined in mx.logging.LogEventLevel
   * @param message the message to be logged.  Similar to the <code>format</code> step, value(s) in
   * the pipeline may be interpolated into the log message using <code>{<i>index</i>}</code>
   * notation, e.g. "nameInput.text changed to {0}"
   * @return this IPipelineBuilder instance for method chaining.
   * @throws ArgumentError if the message argument is null.
   */
  function log( level:int,
                message:String ):IPipelineBuilder;

  /**
   * Appends a validation step to the end of the binding pipeline.  The current value(s) are
   * (optionally transformed) and then validated against a <code>Matcher</code>.  If the value(s)
   * match, then the pipeline proceeds on to the next step with the same value(s).  If the value(s)
   * do not match, then the pipeline aborts execution.
   *
   * @param condition the condition that should be validated before proceeding.  Valid arguments:
   * <ul>
   * <li>A <code>Matcher</code>.  In this case, the value(s) in the pipeline are validated
   * against the matcher.</li>
   * <li>A <code>function(arg0, arg1, ... argN):Boolean</code>.  In this case, the function is
   * called with the value(s) in the pipeline, and the result determines whether the pipeline
   * continues executing.</li>
   * <li>A <code>function(arg0, arg1, ... argN):* </code> followed by a <code>Matcher</code>. In
   * this case the function is called with the value(s) in the pipeline, and the result is
   * validated against the matcher.</li>
   * </ul>
   * @return this IPipelineBuilder instance for method chaining.
   * @throws ArgumentError if the validator argument is null
   */
  function validate( ...condition ):IPipelineBuilder;

  /**
   * Builds a new binding pipeline by setting the current value(s) in the pipeline to the
   * specified property of the specified target object.
   *
   * @param object the target object that hosts the property to be set.
   * @param property an object specifying the property to be written to on the target object.
   * Valid values include:
   * <ul><li>A String containing name(s) of a public bindable property of the target object.
   * Nested properties may be expressed using dot notation e.g. "foo.bar.baz"</li>
   * <li>An object in the form (any but the last property):<pre>
   * { name: <i>property name</i>,
   *   getter: function(target):* { <i>return property value</i> } }</pre></li>
   * <li>An object in the form (last property only):<pre>
   * { name: <i>property name</i>,
   *   setter: function(target, value):void { <i>set target property to value</i> } }</pre></li>
   * </ul>
   * @param additionalProperties (optional) any additional properties in the property chain.  Valid
   * values are same as the <code>property</code> parameter.
   * @return this IPipelineBuilder instance for method chaining.
   * @throws ArgumentError if object is null, or if properties contains any null or invalid
   * values.
   */
  function toProperty( target:Object,
                       property:Object,
                       ...additionalProperties ):IPipelineBuilder;

  /**
   * Builds a new binding pipeline by passing the current value(s) in the pipeline to the specified
   * setter function.
   *
   * @param func a function which accepts the current value(s) in the pipeline
   * @return this IPipelineBuilder instance for method chaining.
   * @throws ArgumentError if the setter argument is null
   */
  function toFunction( func:Function ):IPipelineBuilder;

  /**
   * Returns a <code>function():void</code> which, when invoked, retrieves the binding source
   * value(s) and pushes them through the binding pipeline, with the final value(s) sent to the
   * specified pipeline function.
   *
   * @param func a <code>function(value0, ...valueN):void</code> which will be invoked with the
   * value(s) in the pipeline when returned runner is invoked.
   * @return a <code>function():void</code> which, when invoked, runs the binding pipeline
   * through to the specified pipeline function.
   */
  function runner( func:Function ):Function;

  /**
   * Sets up event listeners, such that the specified function is invoked (with no arguments)
   * whenever any of this pipeline's binding sources changes values.
   *
   * @param runner a <code>function():void</code> which will be invoked whenever any of this
   * pipeline's binding sources changes value.
   */
  function watch( runner:Function ):void;

}

}
