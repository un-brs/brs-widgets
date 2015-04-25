app.controller('ContactsCtrl', ["$scope", "$location", ($scope, $location) ->

    iframe = document.getElementById("preview")
    # @codekit-prepend "variables.coffee";
    #$(iframe).attr("src", $location.absUrl().substr(0, document.URL.lastIndexOf('/')) + "/contacts.html")
    $scope.countriesDataSource = {
      type: 'json'
      transport: {
        read: {
          url: "#{baseUrl}/app/json/countries.json"
        }
      }
    }

    $scope.rolesDataSource ={
      type: 'json'
      transport: {
        read: {
          url: "#{baseUrl}/app/json/roles.json"
        }
      }
    }

    $scope.themesDataSource ={
      type: 'json'
      transport: {
        read: {
          url: "#{baseUrl}/app/json/themes.json"
        }
      }
    }

    $scope.tmplDataSource ={
      type: 'json'
      transport: {
        read: {
          url: "#{baseUrl}/app/json/tmpls.json"
        }
      }
    }

    changeCode = ->
      url = $(iframe).attr('src')
      $("#code").text('<iframe src="' + url + '" style="'+$(iframe).attr('style')+'" frameborder="0"></iframe>')
      return

    $scope.changeShowSearchForm = ->
      if $scope.showSearchForm
        $(iframe).height($(iframe).height() + 113)
      else
        $(iframe).height($(iframe).height() - 113)
      $scope.change()

    $scope.changeHidePager = ->
      if $scope.hidePager
        $(iframe).height($(iframe).height() - 30)
      else
        $(iframe).height($(iframe).height() + 30)
      $scope.change()

    $scope.change = ->
      filters = []
      if $scope.country
        filters.push {key: "country", value: $scope.country}
      if $scope.theme
        filters.push {key: "theme", value: $scope.theme}
      if $scope.roles
        filters.push {key: "roles", value: $scope.roles}
      if $scope.tmpl
        filters.push {key: "tmpl", value: $scope.tmpl}
      if $scope.showSearchForm
        filters.push {key: "showSearchForm", value: $scope.showSearchForm}

      if $scope.hidePager
        filters.push {key: "hidePager", value: $scope.hidePager}

      filter_str = ""
      delim = ""
      for filter in filters
        filter_str += "#{delim}#{filter.key}=#{filter.value}"
        delim = "&"
      url = "#{baseUrl}/contacts.html#/?#{filter_str}"
      $(iframe).attr("src", url)
      iframe.contentDocument.location.reload(true)
      iframe.src = iframe.src
      changeCode()
      return
    $scope.change()
    return
  ])

