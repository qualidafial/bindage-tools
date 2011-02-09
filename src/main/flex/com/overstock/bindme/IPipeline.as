package com.overstock.bindme {

/**
 * A builder interface for data binding pipelines.
 */
public interface IPipeline {

  /**
   * Appends the given step to the end of this binding pipeline.
   * @param step the pipeline step to append.
   * @return this IPipeline instance for method chaining.
   */
  function append( step:IPipelineStep ):IPipeline;

  /**
   * Appends a conversion step to the end of the binding pipeline.  During this step, the current
   * value(s) are passed to the converter function, and the value returned from the converter will
   * be sent to next step in the pipeline.
   *
   * <p>
   * If this is a <code>fromAll</code> pipeline, all the values in the pipeline are passed to the
   * converter function in a single call, as successive arguments.  If you are trying to convert
   * each argument individually, use <code>map(Function)</code> instead.
   * </p>
   *
   * @param converter a function which accepts the value(s) in the binding pipeline, and returns
   *        the converted value.
   * @return this IPipeline instance for method chaining.
   * @throws ArgumentError if the converter argument is null
   */
  function convert( converter:Function ):IPipeline;

  /**
   * Appends a formatting step to the end of the binding pipeline.  During this step, the current
   * value(s) are interpolated into the specified format string, and the resulting string is sent
   * to the next step in the pipeline.
   *
   * <p>
   * Example:
   * </p>
   *
   * <pre>
   *   person.name = "John"; // {0}
   *   Bind.from(person, "name")
   *       .format("Welcome, {0}!")
   *       .to(greetingLabel, "text"); // "Welcome, John!"
   * </pre>
   *
   * <p>
   * In a <code>Bind.fromAll()</code> scenario, the first <code>Bind.from()</code> declared
   * will be represented by <code>{0}</code>, the second by <code>{1}</code>,
   * and so on:
   * </p>
   *
   * <pre>
   *   person.firstName = "Me"
   *   person.lastName = "Hearty"
   *   Bind.fromAll(
   *       Bind.from(person, "firstName"), // {0}
   *       Bind.from(person, "lastName")   // {1}
   *       )
   *       .format("Ahoy, {0} {1}!", greetingString)
   *       .to(greetingLabel, "text"); // "Ahoy, Me Hearty!"
   * </pre>
   */
  function format( format:String ):IPipeline;

  /**
   * Adds a step ensuring that this binding pipeline does not execute concurrently with any other
   *  binding in the same group.  A single binding can belong to multiple groups.
   *
   * @param group the group the binding should be added to.
   * @return this IPipeline instance for method chaining.
   * @throws ArgumentError if the lock argument is null.
   */
  function group( group:BindGroup ):IPipeline;

  /**
   * Appends a logging step to the end of the binding pipeline.  The given message is sent to the
   * Bind class's logger before sending the current value to the next step in the pipeline.
   *
   * @param logLevel log level constant defined in mx.logging.LogEventLevel
   * @param message the message to be logged.  The log message may be parameterized as follows:
   *        <code>{0}</code> - the current value in the binding pipeline i.e. the value being set
   *        on the target
   * @return this IPipeline instance for method chaining.
   * @throws ArgumentError if the message argument is null.
   */
  function log( level:int,
                message:String ):IPipeline;

  /**
   * Appends a validation step to the end of the binding pipeline.  The current value(s) are
   * (optionally transformed) and then validated against a <code>Matcher</code>.  If the value(s)
   * match, then the pipeline proceeds on to the next step with the same value(s).  If the
   * value(s) do not match, then the pipeline aborts execution.
   *
   * @param condition the condition that should be validated before proceeding.  Valid values:
   * <ul>
   * <li>A <code>function(...values):*</code> followed by a <code>Matcher</code>.  In this case
   * the function is called with the values in the pipeline, and the result is validated against
   * the matcher.</li>
   * <li>A <code>Matcher</code>.  In this case, the value(s) in the pipeline are validated
   * against the matcher.</li>
   * </ul>
   * @return this IPipeline instance for method chaining.
   * @throws ArgumentError if the validator argument is null
   */
  function validate( ...condition ):IPipeline;

  /**
   * Builds the binding pipeline by setting the current value(s) in the pipeline to the specified
   * property of the specified target object.
   *
   * @param object the target object that hosts the property to be set.
   * @param properties one or more object specifying the property to be written to on the target
   * object.  Valid values include:
   * <ul>
   * <li>A String containing name(s) of a public bindable property of the target object.  Nested
   * properties may be expressed using dot notation e.g. "foo.bar.baz"</li>
   * <li>An object in the form (any but the last property): <br/>
   * <pre>
   * { name: <i>property name</i>,
   *   getter: function(target):* { <i>return property value</i> } }
   * </pre>
   * </li>
   * <li>An object in the form (last property only): <br/>
   * <pre>
   * { name: <i>property name</i>,
   *   setter: function(target, value):void { <i>set target property to value</i> } }
   * </pre>
   * </li>
   * </ul>
   * @return this IPipeline instance for method chaining.
   * @throws ArgumentError if either object or property is null, or if property is not a valid
   * Property or String instance.
   */
  function toProperty( target:Object,
                       ...properties ):IPipeline;

  /**
   * Builds the binding pipeline by passing the current value(s) in the pipeline to the
   * specified setter function.
   *
   * @param func a function which accepts the current value(s) in the pipeline
   * @return this IPipeline instance for method chaining.
   * @throws ArgumentError if the setter argument is null
   */
  function toFunction( func:Function ):IPipeline;

  /**
   * Returns a <code>function():void</code> which, when invoked,
   * retrieves the binding source value(s) and pushes them through the binding pipeline,
   * with the final value(s) sent to the specified pipeline function.
   *
   * @param func a <code>function(value0, ...valueN):void</code> which will be invoked with the
   * value(s) in the pipeline when returned runner is invoked.
   *
   * @return a <code>function():void</code> which, when invoked, runs the binding pipeline
   * through to the specified pipeline function.
   */
  function runner( func:Function ):Function;

  /**
   * Sets up event listeners, such that the specified runner is invoked (with no arguments)
   * whenever any of this pipeline's binding sources changes values.
   *
   * @param runner a <code>function(...values):void</code> which will be invoked whenever
   * any of thispipeline's binding sources changes values.
   */
  function watch( runner:Function ):void;

}

}
