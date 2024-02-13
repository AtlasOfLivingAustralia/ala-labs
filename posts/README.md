# Posts

A main goal of ALA Labs is to share possible solutions to scientific problems, like how to run analyses or make data visualisations. 

Posts are how-to articles that are blog-like, with the intention to share brief coding tutorials on how to perform analyses and make plots.

## Creating a post

Before making a new post, please create a new branch from `main`. On your new branch, the easiest way to start a new Post is to create a new folder, name it (detailed in the next section), and copy/paste the contents of an existing Post folder into your new folder - ideally one that has a similar structure or uses the same coding language for your article.

Each Post on ALA Labs is saved in `/posts` within its own subfolder. Each subfolder will contain the following components that all work together to render a Post:

  *  `index.qmd`: The article
  *  `preview-dataviz.png`: A final dataviz that you wish to use as a preview image (displayed on the Post listing page)
  *  `/images`: Folder containing logos necessary to build the footer

Without all of these components, a Post will not render correctly on the website.

### Folder naming

Posts are listed in order by date, with the most recent date appearing first. Folders should be named in the format:

*yyyy-mm-dd_short-post-name*

Ideally your short post name will be very similar to the title of your eventual Post because this folder name will be used within the url of your eventual post. For example, the url for the Post titled "Alternatives to box plots: Using beeswarm and raincloud plots to summarise ecological data" is [https://labs.ala.org.au/posts/2023-08-28_alternatives-to-box-plots/post.html](https://labs.ala.org.au/posts/2023-08-28_alternatives-to-box-plots/post.html).

## Using data in a Post

A lot of Posts will use data or files from external sources which need to be saved and loaded from their file location (e.g., `read_csv("data.csv")). If you want to load files into a Post, **do not add data files to your Post's folder**. GitHub has limitations to the size of a repository, so odds are you won't be able to push your data onto the repository.

Files should be saved locally in `/posts/data` and loaded from this folder. This folder is in `.gitignore` and so any files in this folder will not be loaded to the repository.

To allow others to be able to build your Post even though your data isn't pushed to the `ala-labs` repository, save a copy of your files in the Science and Decision Support Teams folder in `/Data/ala-labs/data/`. If you have access to this folder, you can access it [using this link](https://csiroau.sharepoint.com/:f:/r/sites/AtlasofLivingAustraliaTeams/Shared%20Documents/Teams/Science%20and%20Decision%20Support/Data/ala-labs/data?csf=1&web=1&e=H8SQRS).

## Writing a Post

### Article structure

ALA Labs Post are intended to be brief but informative. When describing code, authors should aim to break data wrangling steps into digestible chunks, and display mid-way `data.frame` structure to the user so they can follow along more easily.

Posts will contain:
  
  *  A brief description used in the Post preview
  *  A short introduction, outlining the problem and what the Post will show
  *  A concluding remark with limitations or links to other resources
  
#### Main title

The goal of the main title is to make it something that might be returned by a Google search to solve a problem, make something or use a package.

*Bad*: Distribution of magpies in Australia

*Good*: Make a map of species observations using ggplot2

#### Subtitles

Titles and subtitles within the Post should be as short as reasonably possible (e.g. "Download data", "Make map"). See existing Posts for examples.

### Metadata

Every Post begins with a `yaml` header and additional code to build html components like the date/author/photo banner. These options shouldn't be deleted but will need to be edited for your new article. To help you avoid deleting anything important, there is a note to let you know where to start writing your Post content:

`<!------------------------ Post starts here ------------------------>`

**The first thing you should do before writing your post is add `draft: true` to the `yaml` header.** This ensures that even if the Post is accidentally pushed onto the `main` branch, your unfinished Post will not be added to the Post listing page.

Things that should be updated in the `yaml` of each article include:

  *  `title`
  *  `description` - displayed in the Post listing preview
  *  `author`
  *  `date`
  *  `categories` - Tags for your Post. All posts should have at least one of the following tags:
       *  `Maps`, `Summaries` or `Trees`
       *  Taxonomic names of the species your article is about down to at least class, but no lower than family (e.g. `Eukaryota`, `Animalia`)
       *  `R`, `Python`
  *  `image` (updated with the eventual image-preview name)
       
Things that should be updated in the html components code:

  *  Author name & url to their People page  
      *  e.g. `[firstName lastName](https://labs.ala.org.au/about/lastName_firstName/index.html)`
  *  Date
  *  Url to author image in `::: author-card-image` section
      *  e.g., `knitr::include_graphics("https://raw.githubusercontent.com/AtlasOfLivingAustralia/ala-labs/main/images/people/firstName.jpg")`


### Session info

For transparency and reproducibility, every Post contains session info at the end of the article. This is contained within the `<details>` section. Please do not delete this code, and use the code block that matches the coding language of your article.

As an example, the R session info looks like this:

```
<details><summary style = "color: #E06E53;">Expand for session info</summary>

``{r, echo = FALSE}
library(sessioninfo)
# save the session info as an object
pkg_sesh <- session_info(pkgs = "attached")
# print it out
pkg_sesh
``

</details>

```

