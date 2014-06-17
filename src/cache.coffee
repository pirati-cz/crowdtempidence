request = require('request')
fs = require('fs')

class Cache

  @dir = './cache/'

  @request: (url, callback) ->
    filename = Cache.dir + Cache.slugify(url)
    fs.exists(filename, (exists) ->
      if exists
        Cache.olderThan(filename, 3600*1000, (older) ->
          if older
            Cache.refresh(url, callback)
          else
            fs.readFile(filename, (err, data) ->
              callback(null, null, data)
            )
        )
      else
        Cache.refresh(url, callback)
    )

  @refresh: (url, callback) ->
    filename = Cache.dir + Cache.slugify(url)
    request(url, (error, response, html) ->
      if !error
        fs.writeFile(filename, html, (err) ->
          throw err if err
          callback(error, response, html) if callback
        )
    )

  @olderThan: (filename, miliseconds, callback) ->
    fs.stat(filename, (err, stats) ->
      mtime = stats.mtime.getTime()
      now = new Date(); now = now.getTime()
      callback(now > mtime + miliseconds)
    )

  @slugify: (s) ->
    _slugify_strip_re = /[^\w\s-]/g
    _slugify_hyphenate_re = /[-\s]+/g
    s = s.replace(_slugify_strip_re, '').trim().toLowerCase()
    s = s.replace(_slugify_hyphenate_re, '-')
    return s

module.exports = Cache.request
