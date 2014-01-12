define(['text!templates/assetform.html', 'jquery', 'underscore', 'backbone',  'model/AssetModel'], 
	function(Template, $, _, Backbone, AssetModel) {
		
		var LoaderView = Backbone.View.extend( {
			el: '#asset',
			form: null,
			template: _.template( Template ),

			events: {
				'click .save' : 'save',
				'click .delete' : 'delete',
				'drop' : 'onDrop',
				'dropable .photo' : 'onDrop',
				'dragenter .photo' : 'onDrag',
				'dragstart .photo' : 'dragStart',
				'dragleave .photo' : 'dragLeave',
				'dragend .photo' : 'dragEnd',
				'dragover .photo' : 'dragOver',
				'click .photo' : 'browse',
				'change .upload-file-container input' : 'fileinputChange'
				/*'keypress .edit': 'updateOnEnter' */
			},
			browse: function()
			{
				console.log( this.$el.find(".upload-file-container input")[0] )
				this.$el.find(".upload-file-container input").click();
			},
			save: function()
			{
				console.log("Saving id:"+this.model.get("id"));
				this.model.save( { 
									'name': this.$el.find('input[name="name"]').val(),
									'header': this.$el.find('input[name="header"]').val(),
									'title'	: this.$el.find('input[name="title"]').val(),
									'body'	: this.$el.find('textarea[name="body"]').val(),
									'url'	: this.$el.find('input[name="url"]').val(),									
									'public': this.$el.find('input[name="public"]').is(":checked") ? 1 : 0 
							}, 
							{ 	headers: {'accesskey' :'KEY_CODE_TO_BE_IMPLEMENTED'}, 
								success: this.saved, 
								error: this.errorResult});
			
			},
			saved: function(model, resp)
			{
				alert("Saved ");
				// Need to trigger update of list
				//this.$el.trigger('render');
			},
			delete: function()
			{
				if (window.confirm("Deleting item! Are you sure?"))
				{
					var self = this;
					this.model.destroy( {	headers: {'accesskey' :'KEY_CODE_TO_BE_IMPLEMENTED'}, 
											success: this.deleted, 
											error: this.errorResult,
											wait: true });
				}
			},
			deleted: function(model, resp)
			{
				// Need to trigger update of list
				  this.$el.trigger('delete');

			},
			errorResult: function()
			{
				
				alert("Error ");
			},
			render: function() {
				console.log("Render Assetform "+this.model.get("title"))
				$(this.el).find("#assetform").remove();
				$(this.el).append( this.template( this.model.toJSON() ));
				this.onresize();

				$(this.el).find("#assetform").hide().fadeIn('slow');
			},
			initialize : function()
			{
				_.bindAll(this);
				console.log("loader initiated")
				$(this.loader).hide();
				this.model = new AssetModel;
				this.render();
				this.model.on("change", this.render);
				this.on("complete", this.completed);
				this.on("error", this.error);
				$(window).bind("resize", $.proxy(this.onresize, this));
				this.onresize();	
			},
			onresize: function()
			{
				
			},
			completed: function()
			{
				console.log("loader completed")
				$(this.el).hide();
				$(this.el).empty();
				//this.unbind();
				//this.remove();

			},
			fileUpload: function( result )
			{
				console.log(result);
				if (result.result==-1)
					alert(result.message);
				else
				{
					$(".photo").attr("src", result.path)
					this.model.set("source", result.path);

				}	
				
			},
			doUpload: function( data )
			{

				var uploadPoint = (document.location.hostname == "localhost" ? 'http://localhost/whichDirect' : '') +'/services/upload.php';
		         $.ajax({
		            type: "POST",
		            url: uploadPoint,
			        xhr: function() {  // Custom XMLHttpRequest
			            var myXhr = $.ajaxSettings.xhr();
			            if(myXhr.upload){ // Check if upload property exists
			                myXhr.upload.addEventListener('progress', function(){ console.log("progress")}, false); // For handling the progress of the upload
			            }
			            return myXhr;
			        },
			        //Ajax events
			        beforeSend: function(){ console.log("beforeSend") },
			        success: this.fileUpload,
			        error: function(){ for (var m in arguments) console.log("error "+arguments[m]) },
			        // Form data
			        data: data,
			        dataType: 'json',
			        //Options to tell jQuery not to process data or worry about content-type.
			        cache: false,
			        contentType: false,
			        processData: false
		        });
			},
			fileinputChange: function(e)
			{
				event.preventDefault();
				 var e = event.originalEvent;
				 var files = event.target.files || e.dataTransfer.files;

		        var data = new FormData();
		        data.append( "photo", files[0] );
		        this.doUpload( data );
				console.log("input file change")
			},
			onDrop: function(event) {
				event.preventDefault();
				event.preventDefault();
		        var e = event.originalEvent;
		        e.dataTransfer.dropEffect = 'copy';

		        var files = e.target.files || e.dataTransfer.files;

		        var data = new FormData();
		        data.append( "photo", files[0] );
		        this.doUpload( data );
		        /*
		        $.each(files, function(key, value)
				{
					data.append(key, value);
				});
*/

	    	}, 
	    	onDrag: function(e) {
		        
	    	},  
	    	dragStart: function(event) {
				//event.preventDefault();
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
			error: function(msg)
			{
				var errormsg = msg[1];
				$(this.el).show();
				
				$(this.el).text("Loading error in '" +msg[0]+"'\n").delay(2000).fadeOut('slow')
			}

			
		});

	return LoaderView;

});

