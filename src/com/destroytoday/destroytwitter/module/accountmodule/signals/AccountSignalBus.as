package com.destroytoday.destroytwitter.module.accountmodule.signals
{
	import org.osflash.signals.Signal;

	public class AccountSignalBus
	{
		public const selectedChanged:Signal = new Signal(Boolean);
		
		public function AccountSignalBus()
		{
		}
	}
}