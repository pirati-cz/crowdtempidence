var gulp = require('gulp');
var coffee = require('gulp-coffee');

var paths = {
  scripts: {
    in: 'src/**/*coffee',
    out: 'lib'
  },
};

gulp.task('scripts', function() {
  return gulp.src(paths.scripts.in)
    .pipe(coffee())
    .pipe(gulp.dest(paths.scripts.out));
});

gulp.task('watch', function() {
  gulp.watch(paths.scripts.in, ['scripts']);
});

gulp.task('default', ['scripts', 'watch']);
