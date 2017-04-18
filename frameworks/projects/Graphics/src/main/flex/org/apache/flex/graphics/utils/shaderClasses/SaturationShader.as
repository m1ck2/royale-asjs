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

package org.apache.flex.graphics.utils.shaderClasses
{
import flash.display.Shader;

/**
 *  Creates a blend shader that is equivalent to 
 *  the 'Saturation' blend mode for RGB premultiplied colors available 
 *  in Adobe Creative Suite tools. This blend mode is not native to Flash, 
 *  but is available in tools like Adobe Illustrator and Adobe Photoshop. 
 * 
 *  <p>The 'saturation' blend mode can be set on Flex groups and graphic  
 *  elements. The visual appearance in tools like Adobe Illustrator and 
 *  Adobe Photoshop will be mimicked through this blend shader.</p>  
 * 
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 *  
 *  @includeExample examples/SaturationShaderExample.mxml
 */
public class SaturationShader extends flash.display.Shader
{
    [Embed(source="Saturation.pbj", mimeType="application/octet-stream")]
    private static var ShaderClass:Class;
    
    /**
     *  Constructor. 
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function SaturationShader()
    {
        super(new ShaderClass());
    }
}
}
