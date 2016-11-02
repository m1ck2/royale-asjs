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
package
{

/**
 *  @private
 *  This class is used to link additional classes into rpc.swc
 *  beyond those that are found by dependecy analysis starting
 *  from the classes specified in manifest.xml.
 */
internal class GraphicsClasses
{	

	import org.apache.flex.graphics.SolidColor; SolidColor;
	import org.apache.flex.graphics.SolidColorStroke; SolidColorStroke;
	import org.apache.flex.svg.TransformBead; TransformBead;
	import org.apache.flex.svg.ClipBead; ClipBead;
	import org.apache.flex.svg.LinearGradient; LinearGradient;
	import org.apache.flex.graphics.CubicCurve; CubicCurve;
	import org.apache.flex.graphics.LineStyle; LineStyle;
	import org.apache.flex.graphics.LineTo; LineTo;
	import org.apache.flex.graphics.MoveTo; MoveTo;
	import org.apache.flex.graphics.PathBuilder; PathBuilder;
	COMPILE::SWF
	{
		import org.apache.flex.graphics.utils.PathHelper; PathHelper;
	}
	import org.apache.flex.graphics.QuadraticCurve; QuadraticCurve;
	import org.apache.flex.graphics.ICircle; ICircle;
	import org.apache.flex.graphics.ICompoundGraphic; ICompoundGraphic;
	import org.apache.flex.graphics.IEllipse; IEllipse;
	import org.apache.flex.graphics.IPath; IPath;
	import org.apache.flex.graphics.IRect; IRect;
	import org.apache.flex.graphics.IText; IText;
		
}

}

