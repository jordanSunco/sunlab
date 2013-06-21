/**
 * 通过REQUIREJS OPTIMIZER来打包所有的js依赖
 * 先cd到这个目录, 在通过Node来运行打包程序
 * node r.js -o build.js
 * 
 * @see http://requirejs.org/docs/optimization.html
 * @see https://github.com/jrburke/r.js/blob/master/build/example.build.js
 */
({
    // preserveLicenseComments: false,
    baseUrl: "../js/",
    name: 'app',
    mainConfigFile: '../js/app.js',
    include: ['../lib/require.js'],
    out: 'app-all.js'
})