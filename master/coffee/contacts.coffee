angular
  .module('ContactsApp', [ 'kendo.directives' ])
  .controller('ContactsCtrl', ["$location", "$scope",  ($location, $scope) ->
    # @codekit-prepend "variables.coffee";
    initList = (mode) ->
      $("#content").kendoListView(
        {
          template: kendo.template($("#tmpl-" + mode).html())
          dataSource: $scope.contactsDataSource
        }
      )
      $("#pager").kendoPager({
        dataSource: $scope.contactsDataSource
        buttonCount: 5
      })

    initGrid = ->
      if $scope.hidePager
        pageable = false
      else
        pageable = { buttonCount: 2 }
      # =======================================================================
      # Kendo Grid
      # =======================================================================
      $("#content").kendoGrid(
        {
          dataSource: $scope.contactsDataSource
          height: 380
          scrollable: true
          filterable: {
            extra: false
            operators: {
              string: {
                startswith: "Starts with"
                eq: "Is equal to",
                neq: "Is not equal to"
              }
            }
          }
          columns: [{
            field: "brsPartyNameEn"
            title: "Country"
          }
          {
            field: "brsFullName"
            title: "Full Name"
            filterable: true

          }
          {
            field: "brsContactRoleName"
            title: "Roles"
          }
          {
            field: "email"
            title: "E-mail"
          }
          {
            field: "phoneNumber"
            title: "Phone"
            filterable: false
          }
          ]
          pageable: pageable
        }
      )
    # =========================================================================
    # Get parameters from url
    # =========================================================================
    params = $location.search()

    # =========================================================================
    # Theme
    # =========================================================================
    if params["theme"]
      $("#theme").attr("href", params["theme"])
    # =========================================================================
    # Template
    # =========================================================================
    if params["tmpl"]
      $scope.tmpl = params["tmpl"]
    else
      $scope.tmpl = "full"

    # =========================================================================
    # Show search box
    # =========================================================================
    if params["showSearchForm"]
      $scope.showSearchForm = (params["showSearchForm"] == "true")

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
    else
      $scope.showSearchForm = false
    # =========================================================================
    # Show pager
    # =========================================================================
    $scope.hidePager = false
    if params["hidePager"]
      $scope.hidePager = (params["hidePager"] == "true")

    # =========================================================================
    # Filters
    # =========================================================================
    if params["country"]
      $scope.country = params["country"]

    if params["roles"]
      $scope.roles = params["roles"].split(',')
    # =========================================================================
    # DataSource
    # =========================================================================
    $scope.contactsDataSource = new kendo.data.DataSource(
      {
        type: 'odata'
        pageSize: if $scope.hidePager then false else 10
        serverPaging: true
        serverFiltering: true
        transport: {
          read: {
            url: 'http://informea.pops.int/Contacts2/brsContacts.svc/Contacts'
          }
        }
        schema: {
          model: {
            fields: {
              brsFullName: { type: "string"}
            }
          }
        }
      }
    )

    # =========================================================================
    # Change form
    # =========================================================================
    $scope.change = ->
      filters = []
      if $scope.country
        filters.push({
          field: "country", operator: "equals", value: $scope.country
        })
      if $scope.roles
        role_filters = []
        for role in $scope.roles
          role_filters.push(
            {
              field: "brsContactRoleName"
              operator: "contains"
              value: role
            }
          )
        filters.push(
          {
            logic: "or"
            filters: role_filters
          }
        )
      $scope.contactsDataSource.filter(filters)
    # =========================================================================
    $scope.change()
    # =========================================================================
    switch $scope.tmpl
      when "grid" then initGrid()
      else initList($scope.tmpl)

    return
  ])

