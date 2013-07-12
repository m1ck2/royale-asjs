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
package org.apache.flex.html.staticControls
{
	import org.apache.flex.core.IBead;
	import org.apache.flex.core.IInitSkin;
	import org.apache.flex.core.ITextModel;
	import org.apache.flex.core.UIBase;
	import org.apache.flex.core.ValuesManager;
	
	public class TextInput extends UIBase implements IInitSkin
	{
		public function TextInput()
		{
			super();
		}
		
		public function get text():String
		{
			return ITextModel(model).text;
		}
		public function set text(value:String):void
		{
			ITextModel(model).text = value;
		}
		
		public function get html():String
		{
			return ITextModel(model).html;
		}
		public function set html(value:String):void
		{
			ITextModel(model).html = value;
		}
		
		public function initSkin():void
		{
		}
	}
}