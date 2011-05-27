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
import com.googlecode.bindagetools.impl.MultiPipelineBuilder;
import com.googlecode.bindagetools.impl.PropertyPipelineBuilder;
import com.googlecode.bindagetools.impl.SetterPipeline;

/**
 * A factory for creating binding pipelines between arbitrary <code>[Bindable]</code> properties.
 *
 * <h3>Examples:</h3>
 *
 * <h4>Simple one-way binding:</h4>
 * <pre>
 *     Bind.fromProperty(model, "submitEnabled")
 *         .toProperty(submitButton, "enabled");
 * </pre>
 *
 * <h4>Two-way bindings:</h4>
 * <pre>
 *     Bind.twoWay(
 *         Bind.fromProperty(person, "name"),
 *         Bind.fromProperty(nameInput, "text"));
 * </pre>
 *
 * <h4>Data validation:</h4>
 * <pre>
 *     Bind.fromProperty(ageStepper, "value")
 *         .validate(greaterThanOrEqualTo(0)) // (Hamcrest matcher)
 *         .toProperty(person, "age");
 * </pre>
 *
 * <h4>Data conversion</h4>
 * <pre>
 *     Bind.fromProperty(ageInput, "text")
 *         .convert(toNumber())
 *         .toProperty(person, "age");
 * </pre>
 *
 * <h4>Custom conversion</h4>
 * <pre>
 *     function toTitleCase(value:String):String {
 *       return value.replace(/\b./g, // match first letter of each word
 *                            function(match:String, ... rest):String {
 *                              return match.toUpperCase(); }
 *                            });
 *     }
 *     <br/>
 *     Bind.fromProperty(document, "title")
 *         .convert(toTitleCase)
 *         .toProperty(titleLabel, "text");
 * </pre>
 *
 * <h4>Conditional conversion:</h4>
 * <pre>
 *     Bind.fromProperty(person, "name")
 *         .convert(ifValue(isA(emptyString()))
 *             .thenConvert(toConstant("This field is required"))
 *             .elseConvert(toConstant(null)))
 *         .toProperty(nameInput, "errorString");
 * </pre>
 *
 * <h4>Validate for conversion, convert, then validate converted value</h4>
 * <pre>
 *     Bind.fromProperty(ageInput, "text")
 *         .validate(re(/\d+/)) // ("re" is the Hamcrest matcher for RegExp)
 *         .convert(toNumber())
 *         .validate(greaterThan(0))
 *         .toProperty(person, "age");
 * </pre>
 *
 * <h4>Two-way binding with validation and conversion</h4>
 * <pre>
 *     Bind.twoWay(
 *         Bind.fromProperty(model, "age")
 *             .convert(valueToString()),
 *         Bind.fromProperty(ageInput, "text")
 *             .validate(isNumber())
 *             .convert(toNumber())
 *             .validate(greaterThan(0)));
 * </pre>
 *
 * <h4>Bind from a property to a handler function:</h4>
 * <pre>
 *     function selectAllOrNone(all:Boolean):void {
 *       if (all) {
 *         selectAll();
 *       }
 *       else {
 *         deselectAll();
 *       }
 *     }
 * <br/>
 *     Bind.fromProperty(selectAllCheckbox, "selection")
 *         .toFunction(selectAllOrNone);
 * </pre>
 *
 * <h4>Interpolate values into Strings:</h4>
 * <pre>
 *     Bind.fromProperty(user, "name")
 *         .format("Welcome, {0}!")
 *         .toProperty(welcomeLabel, "text");
 * </pre>
 *
 * <h4>Log when data travels through a binding pipeline:</h4>
 * <pre>
 *     Bind.fromProperty(person, "name")
 *         .log(LogEventLevel.DEBUG, "person.name changed to {0}")
 *         .convert(valueToString())
 *         .log(LogEventLevel.DEBUG, "name converted to String {0}")
 *         .toProperty(nameInput, "text");
 * </pre>
 *
 * <h4>Bind from multiple sources</h4>
 * <pre>
 *     Bind.fromAll(
 *         Bind.fromProperty(billingSameAsShippingCheckbox, "selection"),
 *         Bind.fromProperty(shippingAddressInput, "text"),
 *         Bind.fromProperty(billingAddressInput, "text")
 *         )
 *         .convert(function(billSameAsShip:Boolean, shipValue:String, billValue:String):String {
 *           // Converter function is called with argument in same order as the source bindings above
 *           return billSameAsShip ? shipValue : billValue;
 *         })
 *         .toProperty(order, "billingAddress");
 * </pre>
 *
 * <h4>Bind some condition to the enablement/visibility of a control</h4>
 * The login button should be enabled only if both the username and password fields are non-empty.
 * <pre>
 *     Bind.fromAll(
 *         Bind.fromProperty(userNameInput, "text"),
 *         Bind.fromProperty(passwordInput, "text")
 *         )
 *         .convert(toCondition(args(), everyItem(not(emptyString()))))
 *         .toProperty(loginButton, "enabled");
 * </pre>
 *
 * <h4>Group related bindings so they do not step on eachother:</h4>
 * Suppose we have a UI for entering a coupon code.  We have a checkbox,
 * "Do you have a coupon?" and a text input to enter the code.  These two UI elements represent a
 * single field in the model.
 *
 * <p>
 * When there is a coupon code in the model, the checkbox should be selected,
 * and the coupon input should display the coupon code.
 * </p>
 *
 * <p>
 * Grouping helps solve the problem where complementary bindings make a roundtrip and overwrite
 * eachother.  If groups were omitted in this example, and if the coupon input field was blank,
 * then selecting the checkbox would trigger binding 3, which would set null to the coupon code in
 * the model (since no coupon code is entered in the text box).  Setting the model would in turn
 * trigger binding 1 with the blank value, setting the checkbox selection back to false.
 * </p>
 *
 * <p>
 * When two or more bindings are grouped together, then only one binding in the group may execute
 * at a time.  If one binding in a group is running when another is triggered,
 * the second binding simply aborts until the next property change.
 * </p>
 *
 * <p>
 * Note that bindings created using <code>Bind.twoWay</code> are already grouped transparently
 * for you.
 * </p>
 *
 * <pre>
 *     var couponCodeGroup:BindGroup = new BindGroup();
 *     Bind.fromProperty(order, "couponCode") // binding 1
 *         .group(couponCodeGroup)
 *         .convert(toCondition(not(equalTo(null))))
 *         .toProperty(hasCouponCheckbox, "selection");
 * <br/>
 *     Bind.fromProperty(order, "couponCode") // binding 2
 *         .group(couponCodeGroup)
 *         .toProperty(couponCodeInput, "text");
 * <br/>
 *     Bind.fromAll( // binding 3
 *         Bind.fromProperty(hasCouponCheckbox, "selection"),
 *         Bind.fromProperty(couponCodeInput, "text")
 *             .convert(emptyStringToNull())
 *         )
 *         .group(couponCodeGroup)
 *         .convert(function(hasCoupon:Boolean, couponCode:String):String {
 *           return hasCoupon ? couponCode : null;
 *         })
 *         .toProperty(order, "couponCode");
 * </pre>
 *
 * <h4>Delay execution of a binding until the user stops typing</h4>
 *
 * <p>
 * Use a delayed binding when the response to the change is a long-running or expensive operation
 * The pipeline will halt at the delay step until the specified delay has elapsed with no further
 * changes.
 * </p>
 *
 * <pre>
 *     function searchItems(searchText:String):void {
 *       // expensive filtering operation, or asynchronous webservice call
 *     }
 * <br/>
 *     Bind.fromProperty(searchInput, "text")
 *         .delay(400) // milliseconds
 *         .toFunction(searchItems);
 * </pre>
 */
public class Bind {
  /**
   * @private
   */
  public function Bind() {
  }

  /**
   * Returns a new binding pipeline builder, which binds from the specified property of the given
   * source
   * object.
   *
   * @param source the object that hosts the property to be watched.
   * @param property an object specifying the property to be watched on the source object.  Valid
   * values include:
   * <ul>
   * <li>A String containing name(s) of a public bindable property of the source object.  Nested
   * properties may be expressed using dot notation e.g. "foo.bar.baz"</li>
   * <li>An Object in the form:<br/>
   * <pre>
   * { name: <i>property name</i>,
   *   getter: function(source):* { <i>return property value</i> } }
   * </pre>
   * </li>
   * <li>If <code>additionalProperties</code> is omitted, an Array containing the above
   * elements.</li>
   * </ul>
   * @param additionalProperties (optional) any additional properties in the source property chain.
   * Valid values are same as the <code>property</code> parameter.
   * @return the new binding pipeline builder.
   * @throws ArgumentError if source is null, or if any element of properties is null or not a
   * valid value.
   */
  public static function fromProperty( source:Object,
                                       property:Object,
                                       ... additionalProperties ):IPropertyPipelineBuilder {
    var properties:Array;
    if (property is Array && additionalProperties.length == 0) {
      properties = property as Array;
    }
    else {
      properties = [property].concat(additionalProperties);
    }

    return new PropertyPipelineBuilder(source, properties);
  }

  /**
   * Returns a new binding pipeline builder, which binds from all the specified source pipelines.
   *
   * <p>
   * Example:
   * </p>
   * <pre>
   * Bind.fromAll(
   *     Bind.fromProperty(normalPriceInput, "text")
   *         .validate(isNumber())
   *         .convert(toNumber)
   *         .validate(greaterThan(0)),
   *     Bind.fromProperty(discountPriceInput, "text")
   *         .validate(isNumber())
   *         .convert(toNumber)
   *     )
   *     .convert(function(normalPrice:Number, discountPrice:Number):String {
   *       return (100 * (normalPrice - discountPrice) / normalPrice) + '%';
   *     })
   *     .toProperty(discountPercentText, 'text');
   * </pre>
   *
   * <p>
   * Note that the custom converter function takes two arguments.  This is because there are two
   * bindings pipelines specified as sources in the <code>Bind.fromAll</code> call.  The values
   * from each source pipeline are passed as arguments to the steps in the binding pipelines, in
   * the same order as they are specified in the <code>fromAll</code> call.  If the master pipeline
   * has a <code>convert()</code> step, then all arguments are combined into a single value.
   * Otherwise, all values continue to be passed to each step including the final property setter
   * or setter function.
   * </p>
   *
   * @param sources an array of IPipelineBuilder instances.
   * @return the new binding pipeline builder.
   */
  public static function fromAll( ... pipelines ):IPipelineBuilder {
    return new MultiPipelineBuilder(pipelines);
  }

  /**
   * Creates a two-way binding between the specified pipelines.
   *
   * @param source the source pipeline from which the target will be initially populated.
   * @param target the target pipeline which will be initially populated from the source
   * @param group (optional) the BindGroup that each binding will belong to.  Grouping bindings
   * ensures that only one binding in a group may execute at a time.  If this parameter is
   * omitted, a BindGroup will be provided automatically.
   * @throws ArgumentError if either source or target is not an IPropertyPipeline instance.
   */
  public static function twoWay( source:IPipelineBuilder,
                                 target:IPipelineBuilder,
                                 group:BindGroup = null ):void {
    if (!(source is IPropertyPipelineBuilder)) {
      throw new ArgumentError("Source pipeline must originate from a single property");
    }
    if (!(target is IPropertyPipelineBuilder)) {
      throw new ArgumentError("Target pipeline must originate from a single property");
    }

    if (group == null) {
      group = new BindGroup();
    }

    source.group(group);
    target.group(group);

    var sourcePipeline:IPropertyPipelineBuilder = IPropertyPipelineBuilder(source);
    var targetPipeline:IPropertyPipelineBuilder = IPropertyPipelineBuilder(target);

    var sourceSetter:IPipeline = new SetterPipeline(sourcePipeline.source,
                                                    sourcePipeline.properties);
    var targetSetter:IPipeline = new SetterPipeline(targetPipeline.source,
                                                    targetPipeline.properties);

    var sourceToTargetRunner:Function = source.runner(targetSetter);
    var targetToSourceRunner:Function = target.runner(sourceSetter);

    source.watch(sourceToTargetRunner);
    target.watch(targetToSourceRunner);

    sourceToTargetRunner();
  }
}

}
