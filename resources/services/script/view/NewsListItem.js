define(['text!templates/newsitem.html','backbone'], function(Template, Backbone) {
	var NewsListItem = Backbone.View.extend( {
		tagName: 'li',
		className: 'news',
		template: _.template( Template ),
		events: {
			/*'keypress .edit': 'updateOnEnter' */
			 'drop' : 'onDrop',
			 'dropable' : 'onDrop',
			 'dragenter' : 'onDrag',
			 'dragstart' : 'dragStart',
			 'dragleave' : 'dragLeave',
			 'dragend' : 'dragEnd',
			 'dragover' : 'dragOver',

		},
		render: function(){
		//	console.log( "Render NavigationElementView" );
			//console.log( this.model.toJSON() );
			this.$el.html( this.template( this.model.toJSON() ) );
			return this;

		},
		onSortStart: function(event) {
			
		},
		onDrop: function(event) {
			event.preventDefault();
		//	console.log("drop: "+(event.target).outerHTML+" "+this.model.get("title"));
	        this.$el.trigger('sortend', [this.model]);


    	}, 
    	onDrag: function(e) {
		//	console.log("drag: "+(event.target).outerHTML+" "+this.model.get("title"));
	        //this.$el.trigger('update-sort', [this.model, index]);
	        
    	},  
    	dragStart: function(event) {
			//event.preventDefault();
			//console.log("dragStart");
			this.$el.trigger('sortstart', [this.model]);
			/*
			var dragItem = $("<div id='draggable'/>");
			$("body").append( dragItem.css({ position: "absolute", display: "block",
				left:  event.pageX+"px",
		        top:   event.pageY+"px",
				"padding": this.$el.find("a").css("padding"),
				"color": this.$el.find("a").css("color"),
				width: this.$el.width()+"px", height: this.$el.find("a").height()+"px", "background": this.$el.find("a").css("background") }).text(  this.$el.text()  )  ) ;
*/
    	},  
    	dragLeave: function(event) {
			event.preventDefault();
		//	console.log("dragLeave")
    	},  
    	dragEnd: function(event) {
			event.preventDefault();
		//	console.log("dragEnd")
    	},
    	dragOver: function(event) {
			event.preventDefault();
		//	console.log("dragEnd")
    	},  
		initialize : function()
		{
			_.bindAll(this);
			console.log("Initialize NewsListItem");
			this.model.on( 'change', this.render, this );
		}
	});

	return NewsListItem;
});