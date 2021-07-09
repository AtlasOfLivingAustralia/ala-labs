# labs.ala.org.au

# Installation

Install from the `distill` package from CRAN:

``` {r}
install.packages("distill")
```

Clone this repository to a local directory


# Build website

From the [Distill for R Markdown](https://rstudio.github.io/distill/website.html) website:

If you are using R Studio, you can use the **Build Website** button in the Build pane to generate the site:

[image here]

When you build a website, the following things occur:

1. All of the Rmd and md files in the root website directory will be rendered into HTML. Note however that markdown files beginning with “_” are not rendered (this is a convention to designate files that are included by top level documents).

2. Blog posts will be copied into the `posts` sub-directory of the output directory and blog listing pages will be re-generated.

3. The generated HTML files and any supporting files (e.g. CSS and JavaScript) are copied into an output directory (`_site` by default).

The HTML files within the _site directory are now ready to deploy as a standalone static website.

To build a website from the command line, use the `rmarkdown::render_site()` function:

``` {r}
library(rmarkdown)
render_site()
```

Opening the `index.html` page in the `_site` folder will open the rendered site.


# Site Navigation

The `_site.yml` controls the main website information and site navigation.

Elements can be edited to alter navigation paths. For example:
```{r, eval = FALSE}
---
name: "labs.ala.org.au"
title: "Labs"
output_dir: "_site"
theme: theme.css
favicon: images/favicon.ico
collections:
  posts:
    categories: true
navbar:
  logo:
    image: images/ALA_Logo_Stacked_REV.png
    href: index.html
  search: true
  right:
    - text: "Home"
      href: index.html
    - text: "About"
      href: about.html
    - text: "Articles"
      menu: 
        - text: "More Content"
          href: more.html
    - text: "Blog"
      href: blog.html
    - text: "Projects"
      href: projects.html
    - icon: fab fa-github
      href: https://github.com/AtlasOfLivingAustralia/science
output: distill::distill_article
---
```
