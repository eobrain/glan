# Glan

Glan (Irish for "clean", pronounced /_glawn_/) is an extremely simple way to build a web site.

* Source: <https://github.com/eobrain/glan>
* Homepage: <http://glawn.org>


## Features

* Extremely fast
* Fully static, so can be served out of cheap cloud storage from
  Amazon or S3 (and optionally served through a CDN for worldwide speed)
* Markdown page authoring, so no HTML knowledge required
* Structured hierarchically
* Styled with Twitter Bootstrap

## Authoring

To modify an existing Glan web site. you will need to make changes as follows

1. Edit the file [web/site/config.json](site/config.json) to set the
title of the web site and other properties.
2. Replace the image [web/site/logo.png](site/logo.png) with your logo
3. Edit the file [web/site/footer.txt](site/footer.txt) to set the
text that goes on the bottom ofeach page.
4. Edit the file [web/site/structure.json](site/structure.json) to
specify all the pages in your web site and how they are arranged
hierarchically.
5. For every entry in the `structure.json` add a `.txt` file in
Markdown format in
[web/site/pages/](site/pages/).  For example
[web/site/pages/home.txt](site/pages/home.txt) is the home page. 
6. Specify rotating images in [web/site/rotimg/](site/rotimg/)


## Setup and Administration

[...]
