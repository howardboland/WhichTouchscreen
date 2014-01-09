define(['text!templates/newslist.html','backbone', 'jquery.ui', 'jquery.sortable',
  	'collection/NewsCollection', //Request NewsCollection.js
  	'view/NewsListItem', //Request NewsElementView.js
  	'model/NewsModel', //Request NewsElementView.js
  	'view/NewsFormView', //Request NewsElementView.js
  	'crossdomain' //Request NewsElementView.js
], 	function(Template, Backbone, UI, Sortable, NewsCollection, NewsListItem, NewsModel, NewsFormView, crossdomain)
	{
	var NewsListView = Backbone.View.extend( {
		el: '#news',
		newsform: new NewsFormView(),
		currentSelected: '',
		dropModel: null,
		dragModel: null,
		template: _.template( Template ),
		events: {
			'keypress #addnews': 'filterOnEnter',
			'click #submit-news': 'create',
			'click li.news' : 'select',
			'sortstart li.news'   :  'sortBegin',
			'sortend li.news'   :  'sortEnd',
			'render #news' : 'render'
          	

		},
		render: function()
		{
			console.log( "Render News " +this.collection.length);
			//this.collection.unshift( (new NewsModel()).set("name", "menu").set("title", "menu") )
			this.$el.html( this.template() );
			for (var i=0;i<this.collection.length;i++)
			{
				//console.log( this.collection.at(i).get("orderid") )
			 	var navItem = new NewsListItem( { model: this.collection.at(i) } );
			 	var $item = $( navItem.render().el );
			 	$(this.el).find("ul").append( $item );

			}
/*			this.$el.find("ul li").draggable({revert: true})
			this.$el.find("ul li a").droppable({drop: function(event, ui) {
				   	//	console.log("drop "+ui.draggable[0].outerHTML)
				   	//	console.log("drop "+$(event.target)[0].outerHTML)
				   }});
*/
			this.update(this.currentSelected);

			this.trigger('complete', this.collection);
			
		}, 
		sortBegin: function(e, model)
		{
			this.dragModel = model;
		},
		sortEnd: function(e, model)
		{
			this.dropModel = model;
			this.sort();
		},
		sort:  function() 
		{
			var wasOrderid = this.dragModel.get("orderid");
			console.log(this.dragModel.get("title")+"=>"+this.dropModel.get("title"))
			this.dragModel.set("orderid", this.dropModel.get("orderid"));
			this.dropModel.set("orderid", wasOrderid);
			this.dropModel.save();
			this.dragModel.save();
			this.collection.sort();
			this.render();

		},
		update: function(id)
		{
			$(this.el).find("li").removeClass("selected");
			for (var i=0;i<this.collection.length;i++)
			{
				if (this.collection.at(i).get("id")==id)
				{
					$($(this.el).find("li")[i]).addClass("selected");
					
				}
			}
			this.currentSelected = id;
		},
		filterOnEnter: function(e) {
	        if (e.keyCode != 13) return;
	        this.create();
	     },
		create: function()
		{
			//alert('creating new '+$("#addnews").val());
			this.newsform.model = (new NewsModel()).set("title", $("#addnews").val()).set("header", $("#addnews").val());
			this.newsform.render();
		},
		select: function(e)
		{

			e.preventDefault();
			
			//alert('creating new '+$("#addnews").val());
			this.newsform.model = this.collection.get($(e.target).data("id"));
			this.newsform.render();
			// we should create a new model and open input form.
		},
		onresize: function()
		{

		},
		initialize : function()
		{
			 _.bind(this, this.render);
			var self = this;
			this.on( 'change', this.update, this );
			this.collection = new NewsCollection;

			// not using get
			this.collection.fetch({ 
					data: { method: "getNews" }, 
					success: function(){
							console.info("NewsCollection successfully loaded"); 
							self.render();
					},
					error: function(data, response, status) {
							
							console.error("NewsCollection loading error of url '"+data.url+"' caused by '"+response.statusText+"' server returned code " +response.status); 							
							//for (var m in status)
							//	console.error(m+" "+status[m]); 
							//for (var m in xhr.xhr)
						//		console.error(m+" "+xhr.xhr[m]); 
							self.trigger('error',["News", response]); }
			})
			$(window).bind("resize", $.proxy(this.onresize, this));
			console.log("Initialize NewsListView");
		}
	});

	return NewsListView;
});