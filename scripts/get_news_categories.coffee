request = require('request')
fs = require('fs')

SERVICE = 'http://informea.pops.int/MobileApp/brsMobileApp2.svc/Articles?$select=categories&$format=json'
OUTPUT = '../app/json/news-categories.json'

handler = (error, response, body) ->
  # for row in body['d']
  #   console.log row['brsContactRoleName']
  data = JSON.parse(body)
  # console.log(data['d']['results'])
  categories = {}
  for row in data['d']['results']
    if row['categories']
      for c in row['categories'].split(',')
        categories[c.trim()] = true

  values = []
  for c, v of categories
    values.push(c)
  values.sort()

  result = []
  for c in values
    result.push({'value': c})

  fs.writeFile(OUTPUT, JSON.stringify(result, null, ' '))
  return

request SERVICE, handler
