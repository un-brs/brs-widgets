# @codekit-prepend "config-common"
app = angular.module('NewsApp', [ 'kendo.directives', 'WidgetsApp.config'])
app.controller('NewsCtrl'
  ["$location", "$scope", "BASE_URL", "THEME_URL", "EXCLUDE_NEWS_CATEGORIES"
  ($location, $scope, BASE_URL, THEME_URL, EXCLUDE_NEWS_CATEGORIES) ->
    themeTmpl = kendo.template(THEME_URL)
    initList = (mode) ->
      $("#content").kendoListView(
        {
          template: kendo.template($("#tmpl-" + mode).html())
          dataSource: $scope.newsDataSource
        }
      )
      $("#pager-news").kendoPager({
        dataSource: $scope.newsDataSource
        buttonCount: 5
      })


    # =========================================================================
    # Get parameters from url
    # =========================================================================
    params = $location.search()

    # =========================================================================
    # Theme
    # =========================================================================
    if params["theme"]
      theme = params["theme"]
    else
      theme = "silver"
    $("#theme").attr("href", themeTmpl({"theme": theme}))

    # =========================================================================
    # Template
    # =========================================================================
    if params["tmpl"]
      $scope.tmpl = "#{params.tmpl}-news"
    else
      $scope.tmpl = "full-news"

    # =========================================================================
    # Convention
    # =========================================================================
    if params["convention"]
      $scope.convention = params["convention"]
    else
      $scope.convention = "convention"

    if params["categories"]
      categories = params["categories"].split(',')
    else
      categories = []

    if params["range"]
      startDate = new Date()
      startDate.setMonth(startDate.getMonth() - params["range"])
    # =========================================================================
    # DataSource
    # =========================================================================
    $scope.newsDataSource = new kendo.data.DataSource(
      {
        type: 'odata'
        pageSize: 10
        serverPaging: true
        serverFiltering: true
        serverSorting: true,
        sort: { field: "dateCreated", dir: "desc" }
        transport: {
          read: {
            url: 'http://informea.pops.int/MobileApp/brsMobileApp2.svc/Articles'
          }
        }
        schema: {
          model: {
            fields: {
              dateCreated: { type: "date"}
            }
          }
          parse: (response) -> (
            for o in response.d.results
              o.description = $('<div/>').html(o.description).text()
              o.title = $('<div/>').html(o.title).text()
            return response
          )
        }
      }
    )

    # =========================================================================
    # Change form
    # =========================================================================
    filters = [
      {
        field: "categories", operator: "neq", value: null
      }
    ]
    for category in EXCLUDE_NEWS_CATEGORIES
      filters.push({
        field: "categories", operator: "doesnotcontain", value: category
      })

    for category in categories
      filters.push({
        field: "categories", operator: "contains", value: category
      })

    if startDate
      filters.push({
        field: "dateCreated", operator: "gt", value: startDate
      })

    if $scope.convention
      filters.push({
        field: "treaty", operator: "equals", value: $scope.convention
      })

    $scope.newsDataSource.filter(filters)
    # =========================================================================
    #$scope.change()
    # =========================================================================
    initList($scope.tmpl)

    return
  ])

