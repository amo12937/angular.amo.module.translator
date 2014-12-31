"use strict"

module.exports = (grunt) ->
  require("load-grunt-tasks") grunt
  require("time-grunt") grunt

  grunt.initConfig
    pkg: grunt.file.readJSON "bower.json"
    clean:
      dist: "src"
    coffee:
      dist:
        files: [
          {
            expand: true
            cwd: "coffee"
            src: "**/*.coffee"
            dest: "src"
            ext: ".js"
          }
        ]
    uglify:
      options:
        banner: "/*! <%= pkg.name %> <%= pkg.version %> | Copyright (c) <%= grunt.template.today('yyyy') %> Author: <%= pkg.authors %> | License: <%= pkg.license %> */"
      build:
        src: "src/translator.js"
        dest: "src/translator.min.js"
    karma:
      unit:
        configFile: "karma.conf.coffee"
        singleRun: true

  grunt.registerTask "build", [
    "clean:dist"
    "coffee:dist"
    "uglify"
  ]

  grunt.registerTask "test", [
    "karma:unit:start"
  ]
