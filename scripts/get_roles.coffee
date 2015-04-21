request = require('request')
fs = require('fs')

SERVICE = 'http://informea.pops.int/Contacts2/brsContacts.svc/Contacts?&$select=brsContactRoleName&$format=json'
OUTPUT = '../roles.json'

handler = (error, response, body) ->
  # for row in body['d']
  #   console.log row['brsContactRoleName']
  data = JSON.parse(body)
  roles = {}
  for row in data['d']
    for role in row['brsContactRoleName'].split(',')
      roles[role.trim()] = true

  values = []
  for role, v of roles
    values.push(role)
  values.sort()

  result = []
  for role in values
    result.push({'value': role})

  fs.writeFile(OUTPUT, JSON.stringify(result, null, ' '))
  return

request SERVICE, handler
