var gulp = require('gulp');
var gutil = require('gulp-util');
var debug = require('gulp-debug');
var del = require('del');
var merge = require('merge-stream');
var path = require('path');
var shell = require('shelljs');

var _buildRoot = path.join(__dirname, '_build');

gulp.task('default', ['build']);

gulp.task('build', ['clean'], function () {
    var extension = gulp.src(['docs/**/*', 'images/**/*', 'LICENSE.txt', 'vss-extension.json'], { base: '.' })
        .pipe(debug({title: 'extension:'}))
        .pipe(gulp.dest(_buildRoot));
    var task = gulp.src('task/**/*', { base: '.' })
        .pipe(debug({title: 'task:'}))
        .pipe(gulp.dest(_buildRoot));

    var libPath = path.join(__dirname, 'node_modules', 'vsts-task-sdk', 'VstsTaskSdk');
    if (!shell.test('-d', libPath)) {
        gutil.log(gutil.colors.red('vsts-task-sdk not found: ' + libPath));
        
        return;
    }
    var libs = gulp.src('node_modules/vsts-task-sdk/VstsTaskSdk/**/*', { base: './node_modules/vsts-task-sdk' })
        .pipe(debug({title: 'libs:'}))
        .pipe(gulp.dest(path.join(_buildRoot, 'task', 'ps_modules')));
    
    return merge(extension, task, libs);
});

gulp.task('clean', function() {
   return del([_buildRoot]);
});

gulp.task('test', ['build'], function() {
});