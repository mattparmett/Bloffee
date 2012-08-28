###
Bloffee
A little static-file blog engine written in CoffeeScript.
Powered by Node.js, Express, Jade, and Markdown.
Written by Matt Parmett (mattparmett.com)
###

# Requires
express = require 'express'
fs = require 'fs'
showdown = require 'showdown'

# Express config
app = express()
app.use express.static(process.cwd() + '/public')
app.set 'view engine', 'jade'

# Helpers
app.locals {md: `function(text){ md_converter = new showdown.converter();
  return md_converter.makeHtml(text);}`}

# Functions
# PostReader - Read title, body, date, pub, path of post md file
PostReader = (fn, fs) ->
  title = ""
  body = ""
  date = ""
  published = true
  for line in fs.readFileSync(fn).toString().split('\n')
    if line.indexOf("Title: ") != -1
      title = line.replace("Title: ", "")
    else if line.indexOf("Date: ") != -1
      d = line.replace("Date: ", "").split("-")
      date = new Date(d)
    else if line.indexOf("Published: ") != -1
      if line.replace("Published: ", "") is "false"
        published = false
      else
        published = true
    else
      body = body + "\n" + line unless line.indexOf("---") == 0
  path = fn.replace("posts", "post").replace(".md", "").split(" ").join("-")
  return {title: title, body: body, date: date, published: published, fn: path}

# Read blog metadata, fall back to default
MetaReader = (fn, fs) ->
  if fs.existsSync fn
      p = PostReader(fn, fs)
      return {title: p.title, description: p.body}
  else
    return {title: "Bloffee", description: "A little static-file blog engine written in CoffeeScript."}
  
# Set blog metadata
metadata = MetaReader('blog.md', fs)
global.blog_title = metadata.title
global.blog_desc = metadata.description

  
# Routes
app.get '/', (req, resp) ->
  resp.redirect('/1')

app.get '/post/:post_title', (req, resp) -> 
  fn = process.cwd() + '/posts/' + req.params.post_title.split("-").
    join(" ") + ".md"
  post = PostReader(fn, fs)
  
  if post.published == true
    resp.render 'post', {title: post.title, body: post.body, date: post.date
    , published: post.published, fn: '/post/' + req.params.post_title
    , page: @page, blog_title: blog_title, blog_desc: blog_desc}
  else
    resp.redirect("/#{@page}")
 
app.get '/:page', (req, resp) ->
  # Set current page global var (makes nice back buttons possible)
  @page = parseInt(req.params.page)
  
  # Handle funky param values
  resp.redirect('/') if @page <= 0
  
  # Set posts per page
  posts_per_page = 5
  
  # Read filenames of all posts in posts folder
  post_files = fs.readdirSync('posts')
  
  # Get title, body, date, published, path of each post,
  # aggregating into master array of posts
  posts = (PostReader('posts/' + post, fs) for post in post_files when post.indexOf(".md") != -1)
  # Filter out posts with published = false
  posts = (post for post in posts when post.published != false)
  total_pages = Math.ceil(posts.length / posts_per_page)
  
  # Sort posts by date
  posts.sort (a,b) -> return if a.date < b.date then 1 else -1

  # Get this page's posts
  start_post = ((@page - 1) * posts_per_page)
  # Make sure we're not trying to display more posts than we have;
  # If we are, go to last viable page
  resp.redirect("/#{(posts.length / posts_per_page)}") if start_post >= posts.length
  posts = posts.slice(start_post, start_post + posts_per_page)
  
  resp.render 'postlist', {posts: posts, page: @page, total_pages: total_pages
  , blog_title: blog_title, blog_desc: blog_desc}

app.listen process.env.PORT || 3000