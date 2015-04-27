app.controller('NewsCtrl', ["$location", "$scope", 'BASE_URL', 'EXCLUDE_NEWS_CATEGORIES',
($location, $scope, BASE_URL, EXCLUDE_NEWS_CATEGORIES) ->

  iframe = document.getElementById("preview-news")

  $scope.conventionsDataSource = {
      type: 'json'
      transport: {
        read: {
          url: "#{BASE_URL}/app/json/conventions.json"
        }
      }
  }
  $scope.categoriesDataSource = new kendo.data.DataSource({
      type: 'json'
      transport: {
        read: {
          url: "#{BASE_URL}/app/json/news-categories.json"
        }
      }
    }
  )

  filters = []
  for category in EXCLUDE_NEWS_CATEGORIES
     filters.push({
       field: "value", operator: "doesnotcontain", value: category
     })
  $scope.categoriesDataSource.filter(filters)

  $scope.themesDataSource ={
    type: 'json'
    transport: {
      read: {
        url: "#{BASE_URL}/app/json/themes.json"
      }
    }
  }

  $scope.tmplDataSource ={
      type: 'json'
      transport: {
        read: {
          url: "#{BASE_URL}/app/json/tmpls.json"
        }
      }
    }

  $scope.timeRangeDataSource ={
      type: 'json'
      transport: {
        read: {
          url: "#{BASE_URL}/app/json/news-range.json"
        }
      }
    }

  $scope.convention = "basel"

  changeCode = ->
    url = $(iframe).attr('src')
    $("#code-news").text('<iframe src="' + url + '" style="'+$(iframe).attr('style')+'" frameborder="0"></iframe>')
    return

  $scope.change = ->
    filters = []
    if $scope.convention
      filters.push {key: "convention", value: $scope.convention}
    if $scope.theme
      filters.push {key: "theme", value: $scope.theme}
    if $scope.categories
      filters.push {key: "categories", value: $scope.categories}
    if $scope.tmpl
      filters.push {key: "tmpl", value: $scope.tmpl}
    if $scope.timeRange
      filters.push {key: "range", value: $scope.timeRange}

    filter_str = ""
    delim = ""
    for filter in filters
      filter_str += "#{delim}#{filter.key}=#{filter.value}"
      delim = "&"

    url = "#{BASE_URL}/news.html#/?#{filter_str}"
    $(iframe).attr("src", url)
    iframe.contentDocument.location.reload(true)
    iframe.src = iframe.src
    changeCode()
    return
  $scope.change()
  return
])
