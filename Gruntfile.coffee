module.exports = (grunt) ->
  grunt.initConfig
    includes:
      files:
        src: ['templates/index.html']
        dest: 'public'
        flatten: true
        cwd: '.'
    coffee:
      glob_to_multiple:
          expand: true
          flatten: true
          cwd: '.'
          src: ['client/*']
          dest: 'public/js/'
          ext: '.js'
    watch:
      html:
        files: ['templates/*']
        tasks: ['includes']
      js:
        files: ['client/*']
        tasks: ['coffee']
  grunt.loadNpmTasks 'grunt-includes'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
