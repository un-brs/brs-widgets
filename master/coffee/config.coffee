angular.module('WidgetsApp.config', [])
  .constant('BASE_URL', '')
  .constant('THEME_URL', '//cdn.kendostatic.com/2014.3.1411/styles/kendo.#= theme #.min.css')

app = angular.module('WidgetsApp', [ 'kendo.directives', 'WidgetsApp.config'])
# @codekit-append "config-contacts"
# @codekit-append "config-news"
