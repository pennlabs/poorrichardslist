module.exports = (grunt) ->
  grunt.initConfig
    includes:
      files:
        cwd: '.'
        src: ['templates/index.html']
        dest: 'public'
        flatten: true
    coffee:
      glob_to_multiple:
          cwd: '.'
          src: ['client/*']
          dest: 'public/js/'
          ext: '.js'
          expand: true
          flatten: true
    sass:
      dist:
        options:
          style: 'expanded'
        files: [
          cwd: '.'
          src: ['styles/*']
          dest: 'public'
          ext: '.css'
          expand: true
          flatten: true
        ]

    watch:
      html:
        files: ['templates/*']
        tasks: ['includes']
      js:
        files: ['client/*']
        tasks: ['coffee']
      css:
        files: ['styles/*']
        tasks: ['sass']
  grunt.loadNpmTasks 'grunt-includes'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-sass'
