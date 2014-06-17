request = require('./cache')
cheerio = require('cheerio')

class Scrape

  @list = {}

  @scrapeList: (done) ->
    console.log("scraping list")
    url = 'https://www.pirati.cz/lide/start?do=index'

    request(url, (error, response, html) ->
      if (!error)
        $ = cheerio.load(html)

        $('li.level2').filter(() ->
          data = $(this)
          link = data.children().first().children().first()

          name = link.text()
          tag = link.attr('title')?.replace('lide:', '')
          href = link.attr('href')

          json = { name : "", tag : "", url : "", data: {} }

          json.name = name
          json.tag = tag
          json.url = href

          Scrape.list[tag] = json if tag
        )

      console.log("/scraping list")
      done() if done
    )

  @scrapeAll: () ->
    @scrapeOne(tag) for tag, someone of @list

  @scrapeOne: (tag) ->
    console.log("scraping: " + tag)
    return unless tag
    url = Scrape.list[tag].url
    console.log("\t" + url)

    request(url, (error, response, html) ->
      if (!error)
        $ = cheerio.load(html)

        $('table.inline tr').filter(() ->
          data = $(this)
          attribute = data.children().first().text().trim()
          value = data.children().last().text().trim()
          if Scrape.list[tag].data[attribute]
            Scrape.list[tag].data[attribute] = ', '+value
          else
            Scrape.list[tag].data[attribute] = value
        )

      console.log("/scraping: " + tag)
    )

module.exports = Scrape
