////////////////////////////////////////////////////////////////////////////////
//
//  Licensed to the Apache Software Foundation (ASF) under one or more
//  contributor license agreements.  See the NOTICE file distributed with
//  this work for additional information regarding copyright ownership.
//  The ASF licenses this file to You under the Apache License, Version 2.0
//  (the "License"); you may not use this file except in compliance with
//  the License.  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
////////////////////////////////////////////////////////////////////////////////

package org.apache.flex.utils.validation
{
	//TODO make PAYG

	// [ResourceBundle("validators")]

	/**
	 *  The NumberValidator class ensures that a String represents a valid number.
	 *  It can ensure that the input falls within a given range
	 *  (specified by <code>minValue</code> and <code>maxValue</code>),
	 *  is an integer (specified by <code>domain</code>),
	 *  is non-negative (specified by <code>allowNegative</code>),
	 *  and does not exceed the specified <code>precision</code>.
	 *  The validator correctly validates formatted numbers (e.g., "12,345.67")
	 *  and you can customize the <code>thousandsSeparator</code> and
	 *  <code>decimalSeparator</code> properties for internationalization.
	 *  
	 *  @mxml
	 *
	 *  <p>The <code>&lt;mx:NumberValidator&gt;</code> tag
	 *  inherits all of the tag attributes of its superclass,
	 *  and adds the following tag attributes:</p>
	 *  
	 *  <pre>
	 *  &lt;mx:NumberValidator 
	 *    allowNegative="true|false" 
	 *    decimalPointCountError="The decimal separator can only occur once." 
	 *    decimalSeparator="." 
	 *    domain="real|int" 
	 *    exceedsMaxError="The number entered is too large." 
	 *    integerError="The number must be an integer." 
	 *    invalidCharError="The input contains invalid characters." 
	 *    invalidFormatCharsError="One of the formatting parameters is invalid." 
	 *    lowerThanMinError="The amount entered is too small." 
	 *    maxValue="NaN" 
	 *    minValue="NaN" 
	 *    negativeError="The amount may not be negative." 
	 *    precision="-1" 
	 *    precisionError="The amount entered has too many digits beyond the decimal point." 
	 *    separationError="The thousands separator must be followed by three digits." 
	 *    thousandsSeparator="," 
	 *  /&gt;
	 *  </pre>
	 *  
	 *  @includeExample examples/NumberValidatorExample.mxml
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public class NumberValidator extends Validator
	{
		/**
		 *  Convenience method for calling a validator
		 *  from within a custom validation function.
		 *  Each of the standard Flex validators has a similar convenience method.
		 *
		 *  @param validator The NumberValidator instance.
		 *
		 *  @param value A field to validate.
		 *
		 *  @param baseField Text representation of the subfield
		 *  specified in the <code>value</code> parameter.
		 *  For example, if the <code>value</code> parameter specifies value.number,
		 *  the <code>baseField</code> value is "number".
		 *
		 *  @return An Array of ValidationResult objects, with one ValidationResult 
		 *  object for each field examined by the validator. 
		 *
		 *  @see mx.validators.ValidationResult
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public static function validateNumber(validator:NumberValidator,
											value:Object,
											baseField:String):Array
		{
			var results:Array = [];

			// Resource-backed properties of the validator.
			var allowNegative:Boolean = validator.allowNegative;		
			var decimalSeparator:String = validator.decimalSeparator;
			var domain:String = validator.domain;	
			var maxValue:Number = Number(validator.maxValue);
			var minValue:Number = Number(validator.minValue);
			var precision:int = int(validator.precision);
			var thousandsSeparator:String = validator.thousandsSeparator;

			var input:String = String(value);
			var len:int = input.length;

			var isNegative:Boolean = false;
			
			var i:int;
			var c:String;

			// Make sure the formatting character parameters are unique,
			// are not digits or the negative sign,
			// and that the separators are one character.
			var invalidFormChars:String = DECIMAL_DIGITS + "-";

			if (decimalSeparator == thousandsSeparator ||
				invalidFormChars.indexOf(decimalSeparator) != -1 ||
				invalidFormChars.indexOf(thousandsSeparator) != -1 ||
				decimalSeparator.length != 1 ||
				thousandsSeparator.length != 1)
			{
				results.push(new ValidationResult(
					true, baseField, "invalidFormatChar",
					validator.invalidFormatCharsError));
				return results;
			}

			// Check for invalid characters in input.
			var validChars:String = DECIMAL_DIGITS + "-" +
									decimalSeparator + thousandsSeparator;
			for (i = 0; i < len; i++)
			{
				c = input.charAt(i);
				if (validChars.indexOf(c) == -1)
				{
					results.push(new ValidationResult(
						true, baseField, "invalidChar",
						validator.invalidCharError));
					return results;
				}
			}

			// Check if the input is negative.
			if (input.charAt(0) == "-")
			{
				if (len == 1) // we have only '-' char
				{
					results.push(new ValidationResult(
						true, baseField, "invalidChar",
						validator.invalidCharError));
					return results;
				}
				else if (len == 2 && input.charAt(1) == '.') // handle "-."
				{
					results.push(new ValidationResult(
						true, baseField, "invalidChar",
						validator.invalidCharError));
					return results;
				}

				// Check if negative input is allowed.
				if (!allowNegative)
				{
					results.push(new ValidationResult(
						true, baseField, "negative",
						validator.negativeError));
					return results;
				}

				// Strip off the minus sign, update some variables.
				input = input.substring(1);
				len--;
				isNegative = true;
			}

			// Make sure there's only one decimal point.
			if (input.indexOf(decimalSeparator) !=
				input.lastIndexOf(decimalSeparator))
			{
				results.push(new ValidationResult(
					true, baseField, "decimalPointCount",
					validator.decimalPointCountError));
				return results;
			}

			// Make sure every character after the decimal is a digit,
			// and that there aren't too many digits after the decimal point:
			// if domain is int there should be none,
			// otherwise there should be no more than specified by precision.
			var decimalSeparatorIndex:Number = input.indexOf(decimalSeparator);
			if (decimalSeparatorIndex != -1)
			{
				var numDigitsAfterDecimal:Number = 0;

				if (i == 1 && i == len) // we only have a '.'
				{
					results.push(new ValidationResult(
						true, baseField, "invalidChar",
						validator.invalidCharError));
					return results;
				}
				
				for (i = decimalSeparatorIndex + 1; i < len; i++)
				{
					// This character must be a digit.
					if (DECIMAL_DIGITS.indexOf(input.charAt(i)) == -1)
					{
						results.push(new ValidationResult(
							true, baseField, "invalidChar",
							validator.invalidCharError));
						return results;
					}

					++numDigitsAfterDecimal;

					// There may not be any non-zero digits after the decimal
					// if domain is int.
					if (domain == NumberValidatorDomainType.INT && input.charAt(i) != "0")
					{
						results.push(new ValidationResult(
							true, baseField,"integer",
							validator.integerError));
						return results;
					}

					// Make sure precision is not exceeded.
					if (precision != -1 &&
						numDigitsAfterDecimal > precision)
					{
						results.push(new ValidationResult(
							true, baseField, "precision",
							validator.precisionError));
						return results;
					}
				}
			}

			// Make sure the input begins with a digit or a decimal point.
			if (DECIMAL_DIGITS.indexOf(input.charAt(0)) == -1 &&
				input.charAt(0) != decimalSeparator)
			{
				results.push(new ValidationResult(
					true, baseField, "invalidChar",
					validator.invalidCharError));
				return results;
			}

			// Make sure that every character before the decimal point
			// is a digit or is a thousands separator.
			// If it's a thousands separator,
			// make sure it's followed by three consecutive digits.
			var end:int = decimalSeparatorIndex == -1 ?
						len :
						decimalSeparatorIndex;
			for (i = 1; i < end; i++)
			{
				c = input.charAt(i);
				if (c == thousandsSeparator)
				{
					if (c == thousandsSeparator)
					{
						if ((end - i != 4 &&
							input.charAt(i + 4) != thousandsSeparator) ||
							DECIMAL_DIGITS.indexOf(input.charAt(i + 1)) == -1 ||
							DECIMAL_DIGITS.indexOf(input.charAt(i + 2)) == -1 ||
							DECIMAL_DIGITS.indexOf(input.charAt(i + 3)) == -1)
						{
							results.push(new ValidationResult(
								true, baseField, "separation",
								validator.separationError));
							return results;
						}
					}
				}
				else if (DECIMAL_DIGITS.indexOf(c) == -1)
				{
					results.push(new ValidationResult(
						true, baseField,"invalidChar",
						validator.invalidCharError));
					return results;
				}
			}

			// Make sure the input is within the specified range.
			if (!isNaN(minValue) || !isNaN(maxValue))
			{
				// First strip off the thousands separators.
				for (i = 0; i < end; i++)
				{
					if (input.charAt(i) == thousandsSeparator)
					{
						var left:String = input.substring(0, i);
						var right:String = input.substring(i + 1);
						input = left + right;
					}
				}

				// Translate the value back into standard english
				// If the decimalSeperator is not '.' we need to change it to '.' 
				// so that the number casting will work properly
				if (validator.decimalSeparator != '.')
				{
					var dIndex:int = input.indexOf( validator.decimalSeparator );
					if (dIndex != -1)
					{ 
						var dLeft:String = input.substring(0, dIndex);
						var dRight:String = input.substring(dIndex + 1);
						input = dLeft + '.' + dRight;
					}
				}

				// Check bounds

				var x:Number = Number(input);

				if (isNegative)
					x = -x;

				if (!isNaN(minValue) && x < minValue)
				{
					results.push(new ValidationResult(
						true, baseField, "lowerThanMin",
						validator.lowerThanMinError));
					return results;
				}
				
				if (!isNaN(maxValue) && x > maxValue)
				{
					results.push(new ValidationResult(
						true, baseField, "exceedsMax",
						validator.exceedsMaxError));
					return results;
				}
			}

			return results;
		}

		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------

		/**
		 *  Constructor.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function NumberValidator()
		{
			super();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------

		//----------------------------------
		//  allowNegative
		//----------------------------------

		/**
		 *  @private
		 *  Storage for the allowNegative property.
		 */
		private var _allowNegative:Object;
		
		/**
		 *  @private
		 */
		private var allowNegativeOverride:Object;

		[Inspectable(category="General", defaultValue="null")]

		/**
		 *  Specifies whether negative numbers are permitted.
		 *  Valid values are <code>true</code> or <code>false</code>.
		 *
		 *  @default true
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function get allowNegative():Object
		{
			return _allowNegative;
		}

		/**
		 *  @private
		 */
		public function set allowNegative(value:Object):void
		{
			allowNegativeOverride = value;

			_allowNegative = value != null ?
							Boolean(value) : true;
			// TODO get from resource bundle
			// _allowNegative = value != null ?
			// 				Boolean(value) :
			// 				resourceManager.getBoolean(
			// 					"validators", "allowNegative");
		}

		[Inspectable(category="General", defaultValue="null")]

		/**
		 *  The character used to separate the whole
		 *  from the fractional part of the number.
		 *  Cannot be a digit and must be distinct from the
		 *  <code>thousandsSeparator</code>.
		 *
		 *  @default "."
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */	
		public var decimalSeparator:String;

		//----------------------------------
		//  domain
		//----------------------------------

		/**
		 *  @private
		 *  Storage for the domain property.
		 */
		private var _domain:String = "real";
		
		[Inspectable(category="General", enumeration="int,real", defaultValue="null")]

		/**
		 *  Type of number to be validated.
		 *  Permitted values are <code>"real"</code> and <code>"int"</code>.
		 *
		 *  <p>In ActionScript, you can use the following constants to set this property: 
		 *  <code>NumberValidatorDomainType.REAL</code> or
		 *  <code>NumberValidatorDomainType.INT</code>.</p>
		 * 
		 *  @default "real"
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function get domain():String
		{
			return _domain;
		}

		/**
		 *  @private
		 */
		public function set domain(value:String):void
		{
			if(isRealValue(value))
				_domain = value;
		}
		
		//----------------------------------
		//  maxValue
		//----------------------------------
		
		/**
		 *  @private
		 *  Storage for the maxValue property.
		 */
		private var _maxValue:Object = NaN;
		
		[Inspectable(category="General", defaultValue="null")]

		/**
		 *  Maximum value for a valid number. A value of NaN means there is no maximum.
		 *
		 *  @default NaN
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function get maxValue():Object
		{
			return _maxValue;
		}

		/**
		 *  @private
		 */
		public function set maxValue(value:Object):void
		{
			if(isRealValue(value))
				_maxValue = Number(value);
		}

		//----------------------------------
		//  minValue
		//----------------------------------

		/**
		 *  @private
		 *  Storage for the minValue property.
		 */
		private var _minValue:Object = NaN;

		[Inspectable(category="General", defaultValue="null")]

		/**
		 *  Minimum value for a valid number. A value of NaN means there is no minimum.
		 *
		 *  @default NaN
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function get minValue():Object
		{
			return _minValue;
		}

		/**
		 *  @private
		 */
		public function set minValue(value:Object):void
		{
			if(isRealValue(value))
				_minValue = Number(value);
		}
		
		//----------------------------------
		//  precision
		//----------------------------------

		/**
		 *  @private
		 *  Storage for the precision property.
		 */
		private var _precision:Object = -1;
		
		[Inspectable(category="General", defaultValue="null")]

		/**
		 *  The maximum number of digits allowed to follow the decimal point.
		 *  Can be any nonnegative integer. 
		 *  Note: Setting to <code>0</code> has the same effect
		 *  as setting <code>domain</code> to <code>"int"</code>.
		 *  A value of -1 means it is ignored.
		 *
		 *  @default -1
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function get precision():Object
		{
			return _precision;
		}

		/**
		 *  @private
		 */
		public function set precision(value:Object):void
		{
			if(isRealValue(value))
				_precision = int(value);
		}
		
		[Inspectable(category="General", defaultValue="null")]

		/**
		 *  The character used to separate thousands
		 *  in the whole part of the number.
		 *  Cannot be a digit and must be distinct from the
		 *  <code>decimalSeparator</code>.
		 *
		 *  @default ","
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public var thousandsSeparator:String;
		
		//--------------------------------------------------------------------------
		//
		//  Properties: Errors
		//
		//--------------------------------------------------------------------------

		//----------------------------------
		//  decimalPointCountError
		//----------------------------------

		/**
		 *  @private
		 *  Storage for the decimalPointCountError property.
		 */
		
		[Inspectable(category="Errors", defaultValue="null")]

		/**
		 *  Error message when the decimal separator character occurs more than once.
		 *
		 *  @default "The decimal separator can occur only once."
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public var decimalPointCountError:String;
		
		//----------------------------------
		//  exceedsMaxError
		//----------------------------------

		
		[Inspectable(category="Errors", defaultValue="null")]

		/**
		 *  Error message when the value exceeds the <code>maxValue</code> property.
		 *
		 *  @default "The number entered is too large."
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public var exceedsMaxError:String;
		
		//----------------------------------
		//  integerError
		//----------------------------------

		[Inspectable(category="Errors", defaultValue="null")]

		/**
		 *  Error message when the number must be an integer, as defined 
		 * by the <code>domain</code> property.
		 *
		 *  @default "The number must be an integer."
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public var integerError:String;

		[Inspectable(category="Errors", defaultValue="null")]

		/**
		 *  Error message when the value contains invalid characters.
		 *
		 *  @default The input contains invalid characters."
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */	
		public var invalidCharError:String;

		[Inspectable(category="Errors", defaultValue="null")]

		/**
		 *  Error message when the value contains invalid format characters, which means that 
		 *  it contains a digit or minus sign (-) as a separator character, 
		 *  or it contains two or more consecutive separator characters.
		 *
		 *  @default "One of the formatting parameters is invalid."
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public var invalidFormatCharsError:String;

		[Inspectable(category="Errors", defaultValue="null")]

		/**
		 *  Error message when the value is less than <code>minValue</code>.
		 *
		 *  @default "The amount entered is too small."
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public var lowerThanMinError:String;

		[Inspectable(category="Errors", defaultValue="null")]

		/**
		 *  Error message when the value is negative and the 
		 *  <code>allowNegative</code> property is <code>false</code>.
		 *
		 *  @default "The amount may not be negative."
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public var negativeError:String;

		[Inspectable(category="Errors", defaultValue="null")]

		/**
		 *  Error message when the value has a precision that exceeds the value defined 
		 *  by the precision property.
		 *
		 *  @default "The amount entered has too many digits beyond the decimal point."
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public var precisionError:String;

		[Inspectable(category="Errors", defaultValue="null")]

		/**
		 *  Error message when the thousands separator is in the wrong location.
		 *
		 *  @default "The thousands separator must be followed by three digits."
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public var separationError:String;

		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------

		/**
		 *  Override of the base class <code>doValidation()</code> method 
		 *  to validate a number.
		 *
		 *  <p>You do not call this method directly;
		 *  Flex calls it as part of performing a validation.
		 *  If you create a custom Validator class, you must implement this method. </p>
		 *
		 *  @param value Object to validate.
		 *
		 *  @return An Array of ValidationResult objects, with one ValidationResult 
		 *  object for each field examined by the validator. 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		override protected function doValidation(value:Object):Array
		{
			var results:Array = super.doValidation(value);
			
			// Return if there are errors
			// or if the required property is set to <code>false</code> and length is 0.
			var val:String = value ? String(value) : "";
			if (results.length > 0 || ((val.length == 0) && !required))
				return results;
			else
				return NumberValidator.validateNumber(this, value, null);
		}
	}

}