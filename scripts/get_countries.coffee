request = require('request')
fs = require('fs')

SERVICE = 'http://informea.pops.int/CountryProfiles/brsTreatyProfile.svc/countryNames?$select=NameEn,IsoCode2d&$format=json'
OUTPUT = '../countries.json'

handler = (error, response, body) ->
  # for row in body['d']
  #   console.log row['brsContactRoleName']
  data = JSON.parse(body)
  countries = []
  for row in data['d']
    countries.push {"value": row["IsoCode2d"], "text": row["NameEn"]}

  countries.sort (a, b) ->
    if a.text > b.text
      return 1
    else if a.text < b.text
      return -1
    return 0


  fs.writeFile(OUTPUT, JSON.stringify(countries, null, ' '))
  return

request SERVICE, handler
