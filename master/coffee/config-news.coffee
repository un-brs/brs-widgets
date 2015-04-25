app.controller('NewsCtrl', ["$location", "$scope",  ($location, $scope) ->
  $scope.conventionsDataSource = {
      type: 'json'
      transport: {
        read: {
          url: "#{baseUrl}/app/json/conventions.json"
        }
      }
  }
  $scope.categoriesDataSource = {
      type: 'json'
      transport: {
        read: {
          url: "#{baseUrl}/app/json/news-categories.json"
        }
      }

  }
  return
])
