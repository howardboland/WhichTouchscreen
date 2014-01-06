define(['text!templates/newsitem.html','backbone'], function(Template, Backbone) {
	var NewsListItem = Backbone.View.extend( {
		tagName: 'li',
		className: 'news',
		template: _.template( Template ),
		events: {
			/*'keypress .edit': 'updateOnEnter' */
			
		},
		render: function(){
		//	console.log( "Render NavigationElementView" );
			console.log( this.model.toJSON() );
			this.$el.html( this.template( this.model.toJSON() ) );
			return this;

		},
		initialize : function()
		{
			console.log("Initialize NewsListItem");
			this.model.on( 'change', this.render, this );
		}
	});

	return NewsListItem;
});