module.exports = (grunt) ->
  grunt.initConfig
    includes:
      files:
        src: ['templates/index.html']
        dest: 'public'
        flatten: true
        cwd: '.'
    watch:
      files: ['templates/*']
      tasks: ['includes']
  grunt.loadNpmTasks 'grunt-includes'
  grunt.loadNpmTasks 'grunt-contrib-watch'
