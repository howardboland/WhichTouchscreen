define(['backbone', 'model/NewsModel'], function(Backbone, NewsModel) {

	var NewsCollection = Backbone.Collection.extend({
		model: NewsModel,
		comparator: 'orderid',
		url: (document.location.hostname == "localhost" ? 'http://localhost/whichDirect/' : '') +'/services/news.php', 	
		initialize: function()
		{

			console.log("News collection init");

		//	this.BannerCollection.bind("completed", co)
		}
	});
	return NewsCollection;
});