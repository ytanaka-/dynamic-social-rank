module.exports = function (grunt) {
  'use strict';
  grunt.initConfig({
    pkg: grunt.file.readJSON("package.json"),
    watch: {
      files: ['assets/coffee/*.coffee'],
      tasks: 'coffee'
    },
    bower: {
      install: {
        options: {
          targetDir: './public/lib',
          layout: 'byType',
          install: true,
          verbose: false,
          cleanTargetDir: true,
          cleanBowerDir: false
        }
      }
    },
    coffee: {
      compile: {
        expand: true,
        cwd: 'assets/coffee',
        src: ['*.coffee'],
        dest: 'public/js/',
        ext: '.js'
      }
    },
  });
  grunt.loadNpmTasks('grunt-bower-task');
  grunt.loadNpmTasks('grunt-contrib-coffee');
  grunt.loadNpmTasks('grunt-contrib-watch');
  grunt.registerTask('default', ['bower:install','coffee:compile','watch']);
};