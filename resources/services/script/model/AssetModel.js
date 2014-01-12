define(['backbone'], function(Backbone) {

var AssetModel = Backbone.Model.extend({
		idAttribute: "id",
		urlRoot: 'asset/',
		defaults: { id: -1, pid: -1, typeid: -1, source: '', name: '', header: '', title: '', url: '', body: '', imageurl:'', public: -1, orderid: -1, selected: -1 },
		url: function()
		{
			return (document.location.hostname == "localhost" ? 'http://localhost/whichDirect' : '') +'/services/asset.php'+ (this.has("id")  ? ((this.get("id")>0) ? "?id=" + this.get("id") : "") : "")
		}, 	

		initialize: function() {
			console.log("Ready");
		}
	});
	return AssetModel;
});