express = require('express')
fs       = require('fs')
app     = express()
Scrape  =  require('./scrape')

list = null

Scrape.scrapeList( () -> Scrape.scrapeAll() )

app.get('/', (req, res) ->
  list = Scrape.list
  output = ''
  output += '<a href="/tag/'+tag+'">'+json.name+'</a><br/>' for tag, json of list #when json.data.length > 0
  res.send(output)
)

app.get('/refresh', (req, res) ->
  list = Scrape.list
  output = ''
  output += '<a href="/tag/'+tag+'">'+json.name+'</a><br/>' for tag, json of list
  res.send(output)
)

app.get(/^\/tag\/(.+)$/, (req, res) ->
  tag = req.params[0]
  Scrape.scrapeOne(tag)
  res.send(Scrape.list[tag])
)

searchos = (json, word) ->
  re = new RegExp(word, 'gi')
  found = []
  (found.push(attribute) if value.match(re)) for attribute, value of json.data
  console.log(found)
  if found.length <= 0
    return ''
  output  = '<a href="/tag/'+json.tag+'">'+json.name+'</a><br/>'
  output += '  '+f+' : "'+json.data[f]+'"<br/>' for f in found
  return output

app.get(/^\/search\/(.+)$/, (req, res) ->
  console.log(req.params)
  word = req.params[0]
  list = Scrape.list
  output = ''
  output += searchos(json, word) for tag, json of list
  res.send(output)
)

app.listen('8001')
console.log('Magic happens on port 8001')
exports = module.exports = app
