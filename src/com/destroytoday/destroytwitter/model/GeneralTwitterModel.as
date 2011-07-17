package com.destroytoday.destroytwitter.model
{
	public class GeneralTwitterModel
	{
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		protected var _loaderHash:Object = {};
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function GeneralTwitterModel()
		{
		}
		
		//--------------------------------------------------------------------------
		//
		//  Getters / Setters
		//
		//--------------------------------------------------------------------------
		
		public function get loaderHash():Object
		{
			return _loaderHash;
		}
	}
}