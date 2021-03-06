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
package org.apache.royale.html.beads.models
{
	import org.apache.royale.collections.HierarchicalData;
	import org.apache.royale.collections.TreeData;
	import org.apache.royale.events.CollectionEvent;
	import org.apache.royale.events.Event;

	/**
	 * The TreeModel is used by Tree
	 */
	public class TreeModel extends SingleSelectionCollectionViewModel
	{
		public function TreeModel()
		{
			super();
		}
		
		private var _hierarchicalData: HierarchicalData;
		
		/**
		 * Setting the hierarchicalData in this model is a convenience. The actual
		 * dataProvider is TreeData; this will create that and set it as the
		 * dataProvider. THIS COULD BE REMOVED AS NOTHING SHOULD BE SETTING THIS PROPERTY.
		 */
		public function set hierarchicalData(value:HierarchicalData):void
		{
			_hierarchicalData = value;
			var treeData:TreeData = new TreeData(_hierarchicalData);
			dataProvider = treeData;
		}
		public function get hierarchicalData():HierarchicalData
		{
			return _hierarchicalData;
		}
	}
}