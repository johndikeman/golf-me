request = require 'request'
prompt = require 'prompt'
cheerio = require 'cheerio'
chalk = require 'chalk'
print = console.log
url = 'http://codegolf.stackexchange.com'

li = no
ind = 0

exports.main = ()->
  print 'welcome to golf-me!'
  request(url+'?tab=week',callback)

callback = (err,response,body)->
  if err
    print err
  else
    li = body.match(/<h3><a href=".+" class="question-hyperlink"/g)
    viewer(0)

viewer = () ->
  q_url = "#{url}#{li[ind].split('\"')[1]}"
  print '\n================================================================'
  print chalk.bgGreen(q_url)
  request(q_url,question_callback)

question_callback = (err,response,body)->
  if err
    print err
  else
    text = cheerio.load(cheerio.load(body)('#question').html())('.post-text').text()
    num = text.match('var QUESTION')
    # print num
    if num
      text = text[0..num.index]
    print text
    print chalk.bgGreen('next: n back: b')
    ret = prompt.get('response',
    ((err,ret)->
      ret = ret.response
      if ret == 'n'
        ind++
        if ind >= li.length
          ind = 0
        viewer()
      else if ret == 'b'
        ind--
        if ind < 0
          ind = li.length - 1
        viewer()
    ))
