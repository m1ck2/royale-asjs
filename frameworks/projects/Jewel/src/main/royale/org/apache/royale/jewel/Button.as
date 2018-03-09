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
package org.apache.royale.jewel
{
    import org.apache.royale.html.Button;

    COMPILE::JS
    {
        import org.apache.royale.core.WrappedHTMLElement;
        import org.apache.royale.html.util.addElementToWrapper;
        import org.apache.royale.core.CSSClassList;
    }

    /**
     *  The Button class is a simple button.  Use TextButton for
     *  buttons that should show text.  This is the lightest weight
     *  button used for non-text buttons like the arrow buttons
     *  in a Scrollbar or NumericStepper.
     * 
     *  The most common view for this button is CSSButtonView that
     *  allows you to specify a backgroundImage in CSS that defines
     *  the look of the button.
     * 
     *  However, when used in ScrollBar and when composed in many
     *  other components, it is more common to assign a custom view
     *  to the button.  
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
    public class Button extends org.apache.royale.html.Button
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function Button()
		{
			super();

            COMPILE::JS
            {
                _classList = new CSSClassList();
            }
		}

        COMPILE::JS
        protected var _classList:CSSClassList;

        /**
		 * @private
		 * @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
		 */
		COMPILE::JS
		override protected function createElement():WrappedHTMLElement
		{
			addElementToWrapper(this,'button');
            element.setAttribute('type', 'button');
			typeNames = "jewel button";
			return element;
		}


        private var _primary:Boolean = false;

        /**
		 *  A boolean flag to activate "jewel-button--primary" effect selector.
		 *  Applies primary color display effect.
         *  Colors are defined in royale-jewel.css
         *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.2
		 */
        public function get primary():Boolean
        {
            return _primary;
        }

        public function set primary(value:Boolean):void
        {
            if (_primary != value)
            {
                _primary = value;

                COMPILE::JS
                {
                    addOrRemove("jewel-button--primary",value);
                    setClassName(computeFinalClassNames());
                }
            }
        }



        COMPILE::JS
        protected function addOrRemove(classNameVal:String,add:Boolean):void
        {
            add ? _classList.add(classNameVal) : _classList.remove(classNameVal);
        }

        COMPILE::JS
        override protected function computeFinalClassNames():String
        {
            return _classList.compute() + super.computeFinalClassNames();
        }
	}
}