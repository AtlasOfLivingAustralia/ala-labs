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

## Site Output

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

## Webpages

Website pages are saved in the top folder using the page name (for example, the content for the About page is in `about.Rmd`).

Additional pages can be added by installing `distilltools` and running:

```{r, eval = FALSE}
library(distilltools)
create_post_from_template("templates/main_page_template.Rmd")
```

Pages can also be added by creating a new R Markdown page in the main website folder with the yaml header:

```{r, eval = FALSE}
---
title: ""
description: |
  
output: 
  distill::distill_article:
    css: theme.css
---
```

These pages can be added to the site navigation in the `_site.yml` under `navbar`


# Editing content

## Posts

### Writing posts

Posts are written in R markdown using a Distill article template. Creating a new ALA Post using the `ALA_posts_template` will create a new page with the correct `yaml` header and sections. To create a new ALA post template, run the following in your R console:

```{r, eval = FALSE}
library(distilltools)
create_post_from_template("templates/posts_template.Rmd")
```


### Rendering posts

If using R studio, you can render your Rmd file as an html to use on the website by clicking the **Knit** button.

When knitting a document, R Studio renders the file using a blank R environment. In other words, the document is run using a blank slate and all packages and .Rdata must be loaded from within the document. This can be frustrating at times, but improves the reproducibility of your document. 

However, some functions require settings from your R environment to run. In these cases, using **Knit** can cause issues. One such case occurs when using galah to download data using `ala_occurrences()` or `ala_media()`. Because you must add your email to `ala_config(email = youremail@email.com)`, Knitting an Rmd file requires that this information is included in the your code, yet we do not wish to share your email in the final html or Rmd file.

Luckily, `rmarkdown::render()` preserves this information (intentionally) compared to using the **Knit** button in R Studio.

To render your .Rmd file using `rmarkdown::render()`, begin by loading galah and setting your email in the R console
```{r}
library(galah)
ala_config(email = "youremail@email.com")
```

Then set your directory of your file. This is easily done using the [here](https://github.com/r-lib/here) package. Put folder names within `""` to your file location
```{r}
library(here)
path <- here("folder", "subfolder", "subfolder", "your-file.Rmd")
```

Now use your `path` to render your R markdown file
```{r}
rmarkdown::render(path)
```

If the file renders successfully, the html file will be updated in your file directory. Open the new `your-file.html` in your directory to view the rendered html page. 

## People

# Theme customisation

Distill uses a CSS framework that can be fully customised. Theme settings are in `theme.css`.

Properties such as website fonts, header and footer sections can be found in labeled sections. For example, settings for the appearance of the website header can be edited in the `.distill-site-header` section:

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

See the [Distill website](https://rstudio.github.io/distill/website.html) page for instructions on how to edit additional website properties.

Properties on the ALA Labs website also use custom CSS, found in `theme.css`.

To edit an element using custom CSS:

1. Build the website or html page you wish to change and click **Open in Browser**

2. Find the object, image or text you wish to change, right click on it and select **Inspect element**. A right hand pane should appear in your browser, showing the Elements and Styles panes. 

3. Determine which element(s) affect the appearance of an object, image or text on the website. The Elements pane displays the html of the web page, and highlights the html container of the element you selected. The Styles pane displays the CSS affecting a selected element or container, and highlights the CSS that is affecting a selected html layer.

4. Edit the CSS style of the element(s) in `theme.css`

The `class` of the html element identifies the name of the CSS style element. In the following example, `class = "text-container"` identifies the name of the CSS style element of the container holding our text element, and `class = "text"` identifies the CSS style element that styles the text "My Text".

```{html, eval = FALSE}
<div class = "text-container">
  <h1 class = "text">My Text</h1>
</div>
```
These classes are styled in CSS, many of which can be found in `theme.css`. For example, style properties in `theme.css` might look like:

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

Add to, edit or create new CSS properties to customise the ALA Labs theme.

`R/functions.R` contains functions to create editable html elements. Save new html elements or edit current html elements functions in `functions.R`.