package com.destroytoday.destroytwitter.model
{
	import com.destroytoday.twitteraspirin.image.GenericImageService;
	import com.destroytoday.twitteraspirin.image.ImglyImageService;
	import com.destroytoday.twitteraspirin.image.ImgurImageService;
	import com.destroytoday.twitteraspirin.image.PikchurImageService;
	import com.destroytoday.twitteraspirin.image.PosterousImageService;
	import com.destroytoday.twitteraspirin.image.TweetPhotoImageService;
	import com.destroytoday.twitteraspirin.image.TwitgooImageService;
	import com.destroytoday.twitteraspirin.image.TwitpicImageService;
	import com.destroytoday.twitteraspirin.image.YfrogImageService;

	public class ImageServiceModel
	{
		//--------------------------------------------------------------------------
		//
		//  Instances
		//
		//--------------------------------------------------------------------------
		
		public var posterous:PosterousImageService = new PosterousImageService();
		
		public var twitgoo:TwitgooImageService = new TwitgooImageService();
		
		public var imgly:ImglyImageService = new ImglyImageService();
		
		public var pikchur:PikchurImageService = new PikchurImageService();
		
		public var twitpic:TwitpicImageService = new TwitpicImageService();
		
		public var yfrog:YfrogImageService = new YfrogImageService();
		
		public var tweetphoto:TweetPhotoImageService = new TweetPhotoImageService();

		public var imgur:ImgurImageService = new ImgurImageService();

		public var generic:GenericImageService = new GenericImageService();
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------

		public function ImageServiceModel()
		{
		}
	}
}