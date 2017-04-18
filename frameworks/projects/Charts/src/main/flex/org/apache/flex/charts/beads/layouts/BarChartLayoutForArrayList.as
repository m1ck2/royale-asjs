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
package org.apache.flex.charts.beads.layouts
{
	import org.apache.flex.charts.core.ICartesianChartLayout;
	import org.apache.flex.charts.core.IChartItemRenderer;
	import org.apache.flex.charts.core.IChartSeries;
	import org.apache.flex.charts.supportClasses.BarSeries;
	import org.apache.flex.core.IBeadLayout;
	import org.apache.flex.core.ISelectionModel;
	import org.apache.flex.core.UIBase;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.IEventDispatcher;
	import org.apache.flex.collections.ArrayList;
	
	/**
	 *  The BarChartLayoutForArrayList class calculates the size and position of all of the itemRenderers for
	 *  all of the series in a BarChart. 
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.0
	 */
	public class BarChartLayoutForArrayList extends BarChartLayout
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function BarChartLayoutForArrayList()
		{
			super();
		}
		
		/**
		 * @private
		 */
		override protected function performLayout():void
		{			
			var selectionModel:ISelectionModel = strand.getBeadByType(ISelectionModel) as ISelectionModel;
			var dp:ArrayList = selectionModel.dataProvider as ArrayList;
			if (!dp)
				return;
			if (dp.length == 0)
				return;
			
			var n:int = dp.length;
			var useWidth:Number = UIBase(chartDataGroup).width;
			var useHeight:Number = UIBase(chartDataGroup).height;
			var itemHeight:Number =  useHeight/dp.length - gap;
			var seriesHeight:Number = itemHeight/chart.series.length;
			var ypos:Number = useHeight - gap/2;
						
			var maxXValue:Number = 0;
			var minXValue:Number = 0;
			var scaleFactor:Number = 1.0;
			var determineScale:Boolean = true;
			
			if (horizontalAxisBead != null && !isNaN(horizontalAxisBead.maximum)) {
				maxXValue = horizontalAxisBead.maximum;
				determineScale = false;
			}
			if (horizontalAxisBead != null && !isNaN(horizontalAxisBead.minimum)) {
				minXValue = horizontalAxisBead.minimum;
			}
			
			for (var s:int = 0; s < chart.series.length; s++)
			{
				var bcs:BarSeries = chart.series[s] as BarSeries;
				
				for (var i:int = 0; i < n; i++)
				{
					var data:Object = dp.getItemAt(i);
					var field:String = bcs.xField;
					
					var xValue:Number = Number(data[field]);
					if (determineScale) maxXValue = Math.max(xValue, maxXValue);
				}				
			}
			
			var range:Number = maxXValue - minXValue;
			scaleFactor = useWidth/range;
			
			for (i = 0; i < n; i++)
			{
				data = dp.getItemAt(i);
				
				for (s=0; s < chart.series.length; s++)
				{
					bcs = chart.series[s] as BarSeries;
					
					var child:IChartItemRenderer = chartDataGroup.getItemRendererForSeriesAtIndex(bcs,i);
					xValue = Number(data[bcs.xField]) - minXValue;
					if (xValue > maxXValue) xValue = maxXValue;
					xValue = xValue * scaleFactor;
					
					child.x = 0;
					child.y = ypos - seriesHeight;
					child.width = xValue;
					child.height = seriesHeight;
					ypos -= seriesHeight;
					
					COMPILE::JS {
						child.element.style.position = "absolute";
					}
					
					child.updateRenderer();
				}
				
				ypos -= gap;
			}
		}
	}
}
