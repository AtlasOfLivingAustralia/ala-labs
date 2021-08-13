# labs.ala.org.au

# Installation

Install the `distill` package from CRAN:

``` {r}
install.packages("distill")
```

Clone this repository to a local directory.

# Build website

From the [Distill for R Markdown](https://rstudio.github.io/distill/website.html) website:

If you are using R Studio, you can use the **Build Website** button in the Build pane to generate the site. This pane appears next to the Environment, History and Connections panes.

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

# Site customisation

See the [Distill website](https://rstudio.github.io/distill/website.html) page for instructions on website structure, editing and customisation.

## Adding Main Web Pages

Main web pages (ie. pages in the navigation bar) are saved in the top folder by their page name (for example, the content for the About page is in `about.Rmd`).

Additional pages can be added by creating a new R Markdown page in the main website folder with the yaml header:

```{r, eval = FALSE}
---
title: ""
description: |
  
output: 
  distill::distill_article:
    css: theme.css
---
```

Add pages to the website by adding them to the site navigation in `_site.yml` under `navbar`

## Site Output and Navigation

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


# Editing content

## Posts

### Writing new posts

Posts are written in R markdown. New posts should be created in the [AtlasofLivingAustralia/science Github repository](https://github.com/AtlasOfLivingAustralia/science). Posts must be created using the correct Post template.

To create a new post:

1.  Create a new folder in the [comms folder within the AtlasofLivingAustralia/science Github repository](https://github.com/AtlasOfLivingAustralia/science/tree/main/comms). If your new post is based on an existing R script already saved in a comms folder, navigate to the comms folder containing your R script

2.  Within the website repository, navigate to the `templates` folder

3.  Copy the `posts_template.Rmd` file and paste it into your comms folder 

4.  Rename the file to your preferred file name. If your new Post is based on an existing R script, name the file the same name as your R script

5.  Fill the YAML header with correct title, description, author and categories metadata

6.  Between the `<aside>` brackets, ensure the `image_path` is the correct image of the author


### Rendering posts

Post Rmd files must be **Knit** into html files to be used on the website. If using R studio, you can render your Rmd file as an html by clicking the **Knit** button.

When you **Knit** a document, R Studio renders the file starting with a blank slate - all packages and .Rdata must be loaded within the document, even if data or packages exist in your local environment. Rendering in this way improves the reproducibility of your document (though it can be frustrating at times). 

Some functions, however, require input or settings that are private (like your personal email address) that you may not wish to share in your final Rmd or html. Using **Knit** will cause issues because R requires that this information is included in the document. This issue will occur frequently when using galah to download data using `ala_occurrences()` or `ala_media()` because you must add your email to `ala_config(email = youremail@email.com)`, so your email is required when you **Knit** your Rmd file.

Luckily, `rmarkdown::render()` preserves this information (intentionally) compared to using the **Knit** button in R Studio.

A useful workflow is to create a new temporary R script that sets `ala_config()` and creates the path for `rmarkdown::render()` using `here::here()`. Running this code will render your Rmd file with `ala_config()` settings applied:

```{r}
library(galah)
ala_config(email = "youremail@email.com")

library(here)
path <- here("folder", "subfolder", "subfolder", "your-file.Rmd")
rmarkdown::render(path)
```

If the file renders successfully, the html file will be rendered in your file directory set by `path`. Open this html file to view the rendered html page. 

### Adding new posts to the website

Once your post is ready to be added to the website, it's a good idea to double-check that the rendered html file of the post is the correct final version. New posts should be saved in a new folder within the `_posts` folder. Posts based on R script in the ALA/Science git repo should be named with the same folder name as in the Science repo


# Theme customisation

Distill uses a CSS framework that can be fully customised. CSS theme settings are in `theme.css`. See the [Distill website](https://rstudio.github.io/distill/website.html) page for instructions on how to edit additional website properties.

Some properties can be found in labeled sections, like settings for website fonts, header and footer sections. For example, website header settings can be found in the `.distill-site-header` section:

```{r}
/*-- WEBSITE HEADER + FOOTER --*/
/* These properties only apply to Distill sites and blogs  */

.distill-site-header {
  --title-size:       18px;    
  --text-color:       #ff414b; /* edited */
  --text-size:        15px;
  --hover-color:      #dd424c; /* edited */
  --bkgd-color:       #ffd8db; /* edited */
}
```

Other properties are edited using custom CSS.


## Editing custom CSS

Custom CSS is also found in `theme.css`.

To edit an element using custom CSS:

1. **Build** the website or **Knit** the html page you wish to change and click **Open in Browser**

2. Find the object, image or text you wish to change. Right click on it and select **Inspect element**. A right hand pane should appear in your browser, showing the Elements and Styles tab panes. 

3. Determine which element(s) affect the appearance of an object, image or text on the website. 

TO find this information first using the Elements pane. The *Elements* pane displays the html of the web page, and highlights the html container of the element you selected. Hovering over the code will also highlight elements affected by each html container. Once you identify relevant html container(s), next use the Styles pane. The *Styles* pane displays the CSS properties that are styling a selected html element or html container, and highlights the affected element. A good way to tell what a CSS property is affecting is to use the checkboxes next to each CSS property to turn style properties on and off.

4. Edit the CSS style of the element(s) in `theme.css`

The `class` of an html element or html container identifies the name of the CSS properties element. 

Let's look at an example. In the following html code, `class = "text-container"` identifies the name of the CSS style element that affects `<div>`, a container for our text. Alternatively, `class = "text"` identifies the CSS style element that affects `<h1>`, or "heading 1", which contains "My Text".

```{html, eval = FALSE}
<div class = "text-container">
  <h1 class = "text">My Text</h1>
</div>
```

These classes are styled in CSS property of the same name, many of which can be found in `theme.css`. In our example, style properties in `theme.css` might look like:

```{css}
.text-container {
display: block;
margin-left: 40%;
margin-right:60%;
}

.text {
font-size: 13px;
}
```

Edit or create new CSS properties to customise the ALA Labs website theme.

## Custom html elements using R functions

`R/functions.R` contains functions that create html elements within ALA Labs website.

The `R/functions.R` uses the [htmlTools](https://rstudio.github.io/htmltools/) package to write html code using R syntax. For example, the following R function and html code will both create a link of `class = "article-link"` that can be edited using CSS:

```{r, eval = FALSE}
# R function
add_link_to_article <- function(title, url){
  tags$a(
    class = "article-link",
    href = url,
    "text"
  )
}

add_link_to_article(text = "my text", url = "https://ala.org.au/")
```

```{html, eval = FALSE}
<!-- html -->
<a class = "article-link" href = "https://ala.org.au/">my text</a>
```

The benefits of writing R functions to create html elements are:

1.  Rather than trying to edit html elements that the Distill package runs in the back-end to build the website, adding html elements using R functions is easier and less prone to errors 

2.  It is easier for people familiar in R to reuse and edit the content of existing html elements created by R functions 

To use functions in the `R/functions.R` file on a website page or post, add the following code block somewhere below the YAML header

```{r, eval = FALSE}
``{r, include=FALSE}
library(htmltools)
source("R/functions.R")
``
```
