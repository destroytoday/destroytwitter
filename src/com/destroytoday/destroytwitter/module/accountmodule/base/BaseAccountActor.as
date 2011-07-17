package com.destroytoday.destroytwitter.module.accountmodule.base
{
	import com.destroytoday.destroytwitter.module.accountmodule.AccountModule;

	public class BaseAccountActor
	{
		public var module:AccountModule;
		
		public function BaseAccountActor(module:AccountModule)
		{
			this.module = module;
		}
	}
}