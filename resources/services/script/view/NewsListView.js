define(['text!templates/newslist.html','backbone', 'jquery.ui',
  	'collection/NewsCollection', //Request NewsCollection.js
  	'view/NewsListItem', //Request NewsElementView.js
  	'model/NewsModel', //Request NewsElementView.js
  	'view/NewsFormView', //Request NewsElementView.js
  	'crossdomain' //Request NewsElementView.js
], 	function(Template, Backbone, UI, NewsCollection, NewsListItem, NewsModel, NewsFormView, crossdomain)
	{
	var NewsListView = Backbone.View.extend( {
		el: '#news',
		newsform: new NewsFormView(),
		currentSelected: '',
		template: _.template( Template ),
		events: {
			'keypress #addnews': 'filterOnEnter',
			'click #submit-news': 'create',
			'click li.news' : 'select',
			 'sortupdate'   :  'sorting'
          	

		},
		render: function()
		{
			console.log( "Render News " +this.collection.length);
			//this.collection.unshift( (new NewsModel()).set("name", "menu").set("title", "menu") )
			this.$el.html( this.template() );
			for (var i=0;i<this.collection.length;i++)
			{
				console.log( this.collection.at(i) )
			 	var navItem = new NewsListItem( { model: this.collection.at(i) } );
			 	var $item = $( navItem.render().el );
			 	$(this.el).find("ul").append( $item );
			 	//var $span = $($item.find("span"));
			 	
			 	//$span.css({  top : (($span.parent().height()-$span.height()) / 2)})
			}

			$(this.el).find("ul").sortable({ 
				/*over: function( event, ui ) { 
					ui.item.animate({opacity: .5}, 'fast')
				},
				out: function( event, ui ) { 
					ui.item.animate({opacity:1}, 'fast')
				},
				stop: function( event, ui ) { 
					console.log("change "+ui.item.index());
					console.log("id"+$(event.target).data('id'))
				}*/
			});
				/*
				axis: "y",
                connectWith: ".news",
                receive: function(event, ui) {
                    // do something here?
                      	alert("");
                },
                update: function(el, ui) {
              
                    $(this).find('li > a').each(function(i){
                        var id = $(this).attr('data-id');
                        var model = this.collection.getByCid(id);
                        alert(model)
                        if(model.get('orderid') != i+1) model.set({orderid: i+1}, {silent: true});
                    });
                   //this.collection.sort();
                }, stop: function(event, ui) {
                	alert("dfd")
            		ui.item.trigger('drop', ui.item.index());
        		}
            });*/
			this.update(this.currentSelected);
			this.trigger('complete', this.collection);
			
		}, 
		sorting:  function() 
		{
			alert("")
	      	_.each( this._listItems, function ( v ) {
	            v.model.set("orderid", v.$el.index());
	         });

	      this.collection.sort({silent: true});
	      this.render();

	     // this.trigger('sorted');


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