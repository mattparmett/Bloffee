# Bloffee #
Bloffee is a static-file blog engine written in CoffeeScript.  Bloffee is powered by Node.js, Express, Jade, and Markdown.

Bloffee takes Markdown files and displays them in clean, valid HTML and CSS.

## Installation ##
To host on Heroku:

```shell
git clone https://github.com/mattparmett/bloffee.git
cd bloffee
npm install # Assumes node and npm are installed globally
rm -rf .git && git init && git add .
git commit -m "initial commit"
heroku create
git push heroku master
heroku open
```

To host on your own server:

```shell
git clone https://github.com/mattparmett/bloffee.git
cd bloffee
rm -rf .git
npm install # Assumes node and npm are installed globally
node bloffee.js
```

## Configuration ##
To configure the blog title and header, rename ```blog.md.example``` to ```blog.md``` and edit the title and description text inside the file.

To change Bloffee's appearance, edit ```/public/css/main.css```.

To change your blog's favicon, edit ```/public/ico/favicon.ico```.

To alter your blog's html, edit the ```.jade``` files in ```views/```.  To do this, you'll have to have knowledge of the Jade templating language.

## Posting ##
Bloffee posts are written in [Markdown](http://daringfireball.net/projects/markdown/) and stored in the ```posts/``` folder with an ```.md``` extension.  A typical blog post may look like the following example, taken from ```posts/welcome.md```:

```markdown
---
Date: 8/28/2012
Title: Welcome to Bloffee!
Published: true
---

This is an example Bloffee post.  The date, title, and published status of the post must be specified at the top of the markdown file, as seen above.  (The dashed lines are unnecessary and Bloffee will ignore them, but they are useful to separate metadata from content.  In fact, the metadata can go anywhere in the post, as long as the above format is maintained.)

The body of the post is interpreted as Markdown, so all *Markdown syntax* will be translated into the appropriate html automatically.

You're going to want to customize the site header and description up top; to do that, rename blog.md.example to blog.md and follow the instructions inside the file.

If you want to alter how your Bloffee site looks, edit public/css/main.css to your liking.

Enjoy using Bloffee!  Any questions/comments are welcome at Bloffee's [GitHub page](http://github.com/mattparmett/bloffee).
```

All posts must include a Date and Title line to tell Bloffee about the title and order of the post.  The Published line is optional; if Published is set to false, Bloffee will ignore the post.

The list of blog posts is updated every time a reader visits the site (but not if a visitor visits a single post), so there's no need to worry about manually updating/synchronizing your posts.  However, if you're hosting your blog on Heroku, you'll have to push new blog posts via git:

```shell
git add posts
git commit -m "added new post"
git push heroku master
```

## Comments ##
All comments/suggestions are welcome via pull request.