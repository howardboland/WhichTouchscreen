/*global module:false*/
module.exports = function(grunt) {

// Project configuration.
grunt.initConfig({
	lint: {
		files: ['grunt.js', 'jquery.prettydate.js', 'test/**/*.js']
	},
	qunit: {
		files: ['test/**/*.html']
	},
	watch: {
		files: '<config:lint.files>',
		tasks: 'lint qunit'
	},
	jshint: {
		options: {
			curly: true,
			eqeqeq: true,
			immed: true,
			latedef: true,
			newcap: true,
			noarg: true,
			sub: true,
			undef: true,
			boss: true,
			eqnull: true,
			browser: true
		},
		globals: {
			jQuery: true,
			QUnit: true
		}
	}
});

// Default task.
grunt.registerTask('default', 'lint qunit');

};
