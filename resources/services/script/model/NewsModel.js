define(['backbone'], function(Backbone) {

var NewsModel = Backbone.Model.extend({
		defaults: { id: -1, header: '', title: '', url: '', body: '', public: -1, orderid: -1 },
		url: (document.location.hostname == "localhost" ? 'http://localhost/whichDirect/' : '') +'/services/news.php', 	
		initialize: function() {
			console.log("Ready");
		}
	});
	return NewsModel;
});