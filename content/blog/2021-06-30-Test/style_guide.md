---
title: "Style Guide"
author: "Dax Kellie"
date: "2021-07-02"
categories: ["R"]
tags: ["R Markdown", "plot", "regression"]
output:
  blogdown::html_page:
    toc: true
    css: custom.css
    highlight: tango
editor_options: 
  chunk_output_type: inline
---
<link href="/rmarkdown-libs/font-awesome/css/all.css" rel="stylesheet" />
<link href="/rmarkdown-libs/font-awesome/css/v4-shims.css" rel="stylesheet" />
<script src="/rmarkdown-libs/kePrint/kePrint.js"></script>
<link href="/rmarkdown-libs/lightable/lightable.css" rel="stylesheet" />
<script src="/rmarkdown-libs/kePrint/kePrint.js"></script>
<link href="/rmarkdown-libs/lightable/lightable.css" rel="stylesheet" />
<script src="/rmarkdown-libs/kePrint/kePrint.js"></script>
<link href="/rmarkdown-libs/lightable/lightable.css" rel="stylesheet" />



<!-- Picture & Links in upper right corner -->





# Introduction
This document details the Atlas of Living Australia style guide for creating html files from R Markdown

# Style Template

A test of a chunk


```{.r .chunk-highlight}
library(kableExtra)
library(tidyverse)

# a table
head(mtcars, n=5) %>%
  kbl() %>%
  kable_styling()
```

<table class="table" style="margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;">   </th>
   <th style="text-align:right;"> mpg </th>
   <th style="text-align:right;"> cyl </th>
   <th style="text-align:right;"> disp </th>
   <th style="text-align:right;"> hp </th>
   <th style="text-align:right;"> drat </th>
   <th style="text-align:right;"> wt </th>
   <th style="text-align:right;"> qsec </th>
   <th style="text-align:right;"> vs </th>
   <th style="text-align:right;"> am </th>
   <th style="text-align:right;"> gear </th>
   <th style="text-align:right;"> carb </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Mazda RX4 </td>
   <td style="text-align:right;"> 21.0 </td>
   <td style="text-align:right;"> 6 </td>
   <td style="text-align:right;"> 160 </td>
   <td style="text-align:right;"> 110 </td>
   <td style="text-align:right;"> 3.90 </td>
   <td style="text-align:right;"> 2.620 </td>
   <td style="text-align:right;"> 16.46 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 4 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Mazda RX4 Wag </td>
   <td style="text-align:right;"> 21.0 </td>
   <td style="text-align:right;"> 6 </td>
   <td style="text-align:right;"> 160 </td>
   <td style="text-align:right;"> 110 </td>
   <td style="text-align:right;"> 3.90 </td>
   <td style="text-align:right;"> 2.875 </td>
   <td style="text-align:right;"> 17.02 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 4 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Datsun 710 </td>
   <td style="text-align:right;"> 22.8 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 108 </td>
   <td style="text-align:right;"> 93 </td>
   <td style="text-align:right;"> 3.85 </td>
   <td style="text-align:right;"> 2.320 </td>
   <td style="text-align:right;"> 18.61 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 1 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Hornet 4 Drive </td>
   <td style="text-align:right;"> 21.4 </td>
   <td style="text-align:right;"> 6 </td>
   <td style="text-align:right;"> 258 </td>
   <td style="text-align:right;"> 110 </td>
   <td style="text-align:right;"> 3.08 </td>
   <td style="text-align:right;"> 3.215 </td>
   <td style="text-align:right;"> 19.44 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:right;"> 1 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Hornet Sportabout </td>
   <td style="text-align:right;"> 18.7 </td>
   <td style="text-align:right;"> 8 </td>
   <td style="text-align:right;"> 360 </td>
   <td style="text-align:right;"> 175 </td>
   <td style="text-align:right;"> 3.15 </td>
   <td style="text-align:right;"> 3.440 </td>
   <td style="text-align:right;"> 17.02 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
</tbody>
</table>

<br>

------------------------------------------------------------------------------

# Getting started

## Use ALA Template 

Create a new R Markdown document by selecting **File** --> **New File** --> **R Markdown** <br>

In the left window menu, select **New Template**. Then select the ALA Template <br>


## Add your information

1. In the top 3 lines, add your document title, your name and the date. Leave the remainder of the .yaml options unchanged. <br>

2. Next, scroll down to the code chunk named "r upper right bio". This code chunk adds your image and links to your personal websites  
* Save your preferred picture as "picture.jpg" in the current directory  
* Add the urls you wish to link to for the correct websites & icons  

<br> 


## Knit to HTML

Click the **Knit** button in the upper menu (below file tabs, above script) to create an HTML file. A preview of your knitted HTML document can be viewed in the right pane. Code must run successfully from start to finish for a file to be Knit. <br>


In the R Studio viewer pane, click the "*Show in New Window *" button to view the page in your browser.

<br>

------------------------------------------------------------------------------

# Push to Github

<br>

------------------------------------------------------------------------------

# Reproducible workflows

## Safe paths

Using `setwd()` to set a working directory can create issues for folder paths. They often are a cause of issues when making reproducible workflows. <br>

Instead, use the `here()` function from the [here package](https://here.r-lib.org/) to build the path where you read and write files. `here()` automatically creates paths relative to the top level directory. <br>

Read a full description of how to use the `here()` function to create safe paths in [Chapter 3 of What They Forgot to Teach You About R](https://rstats.wtf/safe-paths.html) <br>

For example:

```{.r .chunk-highlight}
library(ggplot2)
library(here)

df <- read.delim(here("projects", , "style_guide", "data.csv"))
p <- ggplot(df, aes(x, y)) + geom_point()
ggsave(here("plots", "foofy_scatterplot.png"))
```
To set the project root path according to your current code file:

```{.r .chunk-highlight}
here::i_am("style_guide.rmd")
```


# Make understandable code

##  Code chunk size

In writing, we use sentences and paragraphs of varying lengths to build a flowing, logical story or argument. In the same way, code chunks can be used to structure lines of code to build a flowing, logical analysis or plot. <br>

Code chunks should be brief. They should also offer notes or visual output that provides context to any transformations or outputs. Users should be able to follow each transformation that is made to your data, each output that results from a transformation, and any final output. <br>

There is no single correct code chunk size - you must use your best judgement. If it seems that the result of one or several lines of code is unclear a potential reader, you may need to split the code chunks to make the results easier to follow. <br>


## Brief summaries
For others to understand what your code does and why you made the choices you did, it is helpful to include brief summaries or your logic or what each line of your code does. It is also good to provide a brief interpretation of model output <br>

## Style code using `styler`

Use the `styler` package to ensure your code is formatted correctly and/or consistently, The `styler` package formats your code according to the tidyverse style guide (or another custome style) prior to uploading a finished file document.  <br>

See the `styler` [github](https://github.com/r-lib/styler) and [tidyverse](https://www.tidyverse.org/blog/2017/12/styler-1.0.0/) pages for more information <br>

Install the `styler` package to add style buttons to your R Markdown Addins dropdown menu. Clicking **Addins** -> **style active file** will reformat the code in your active file. Clicking ** Addins** -> **style active section** will reformat code in your current section. <br>

Alternatively, you `style_file()` or `style_text()` can be run in the console. <br>

# Output style

See the [R Markdown cheat sheet](https://www.rstudio.com/wp-content/uploads/2015/02/rmarkdown-cheatsheet.pdf) for more information on R Markdown formatting <br>

For tips to make your R Markdown output pretty, see [Pimp my RMD](https://holtzy.github.io/Pimp-my-rmd/) by Yan Holtz <br>


## Tables

Several packages can create tables with nice formatting. <br>

One example is `kableExtra`:

```{.r .chunk-highlight}
library(kableExtra)
kable(
  head(mtcars, n=5)) %>% kable_styling()
```

<table class="table" style="margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;">   </th>
   <th style="text-align:right;"> mpg </th>
   <th style="text-align:right;"> cyl </th>
   <th style="text-align:right;"> disp </th>
   <th style="text-align:right;"> hp </th>
   <th style="text-align:right;"> drat </th>
   <th style="text-align:right;"> wt </th>
   <th style="text-align:right;"> qsec </th>
   <th style="text-align:right;"> vs </th>
   <th style="text-align:right;"> am </th>
   <th style="text-align:right;"> gear </th>
   <th style="text-align:right;"> carb </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Mazda RX4 </td>
   <td style="text-align:right;"> 21.0 </td>
   <td style="text-align:right;"> 6 </td>
   <td style="text-align:right;"> 160 </td>
   <td style="text-align:right;"> 110 </td>
   <td style="text-align:right;"> 3.90 </td>
   <td style="text-align:right;"> 2.620 </td>
   <td style="text-align:right;"> 16.46 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 4 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Mazda RX4 Wag </td>
   <td style="text-align:right;"> 21.0 </td>
   <td style="text-align:right;"> 6 </td>
   <td style="text-align:right;"> 160 </td>
   <td style="text-align:right;"> 110 </td>
   <td style="text-align:right;"> 3.90 </td>
   <td style="text-align:right;"> 2.875 </td>
   <td style="text-align:right;"> 17.02 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 4 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Datsun 710 </td>
   <td style="text-align:right;"> 22.8 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 108 </td>
   <td style="text-align:right;"> 93 </td>
   <td style="text-align:right;"> 3.85 </td>
   <td style="text-align:right;"> 2.320 </td>
   <td style="text-align:right;"> 18.61 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 1 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Hornet 4 Drive </td>
   <td style="text-align:right;"> 21.4 </td>
   <td style="text-align:right;"> 6 </td>
   <td style="text-align:right;"> 258 </td>
   <td style="text-align:right;"> 110 </td>
   <td style="text-align:right;"> 3.08 </td>
   <td style="text-align:right;"> 3.215 </td>
   <td style="text-align:right;"> 19.44 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:right;"> 1 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Hornet Sportabout </td>
   <td style="text-align:right;"> 18.7 </td>
   <td style="text-align:right;"> 8 </td>
   <td style="text-align:right;"> 360 </td>
   <td style="text-align:right;"> 175 </td>
   <td style="text-align:right;"> 3.15 </td>
   <td style="text-align:right;"> 3.440 </td>
   <td style="text-align:right;"> 17.02 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
</tbody>
</table>

<br>

`kableExtra` is also able to be used using `magittr` or `base` piping:

```{.r .chunk-highlight}
mtcars %>% 
  group_by(gear) %>% 
  summarise(cyl = mean(cyl),
            disp = mean(disp)) %>%
  kbl() %>%
  kable_styling()
```

<table class="table" style="margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:right;"> gear </th>
   <th style="text-align:right;"> cyl </th>
   <th style="text-align:right;"> disp </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:right;"> 7.466667 </td>
   <td style="text-align:right;"> 326.3000 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 4.666667 </td>
   <td style="text-align:right;"> 123.0167 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 5 </td>
   <td style="text-align:right;"> 6.000000 </td>
   <td style="text-align:right;"> 202.4800 </td>
  </tr>
</tbody>
</table>


```{.r .chunk-highlight}
head(mtcars |>
  subset(select = c("cyl", "disp", "gear")), n = 5) |>
  kbl() |>
  kable_styling()
```



## Figures

Controlling the size of figures can help when you want people to focus on trends of many plots or on details of a single plot. <br>

You can control how many columns your plots created in a chunk are printed into.  
Add `out.width = c("50%", "50%"), fig.show = "hold"`:

```{.r .chunk-highlight}
``{r out.width=c('50%', '50%'), fig.show='hold'}
boxplot(1:10)
plot(rnorm(10))
`
```
<img src="/blog/2021-06-30-Test/style_guide_files/figure-html/unnamed-chunk-8-1.png" width="50%" /><img src="/blog/2021-06-30-Test/style_guide_files/figure-html/unnamed-chunk-8-2.png" width="50%" />

Control other parts of figure output in the chunk header as well. For example:


```{.r .chunk-highlight}
``{r, fig.align="center", fig.width=6, fig.height=6, fig.cap="Figure: Here is a really important caption."}
```


```{.r .chunk-highlight}
library(tidyverse)
mpg %>%
  ggplot( aes(x=reorder(class, hwy), y=hwy, fill=class)) + 
    geom_boxplot() +
    xlab("class") +
    theme(legend.position="none")
```

<div class="figure" style="text-align: center">
<img src="/blog/2021-06-30-Test/style_guide_files/figure-html/unnamed-chunk-10-1.png" alt="Figure: Here is a really important caption." width="576" />
<p class="caption">Figure 1: Figure: Here is a really important caption.</p>
</div>


## Model output

Run a model and want to show output? Use the `model_parameters()` function from the [parameters package](https://easystats.github.io/parameters/) to make your output clear and organised. The `model_parameters()` function can be considered as a lightweight alternative to `broom::tidy()`: 

```{.r .chunk-highlight}
library(parameters)
model <- lm(Sepal.Width ~ Petal.Length * Species + Petal.Width, data = iris)

# regular model parameters
model_parameters(model)
```

```
## Parameter                           | Coefficient |   SE |         95% CI | t(143) |      p
## -------------------------------------------------------------------------------------------
## (Intercept)                         |        2.89 | 0.36 | [ 2.18,  3.60] |   8.01 | < .001
## Petal.Length                        |        0.26 | 0.25 | [-0.22,  0.75] |   1.07 | 0.287 
## Species [versicolor]                |       -1.66 | 0.53 | [-2.71, -0.62] |  -3.14 | 0.002 
## Species [virginica]                 |       -1.92 | 0.59 | [-3.08, -0.76] |  -3.28 | 0.001 
## Petal.Width                         |        0.62 | 0.14 | [ 0.34,  0.89] |   4.41 | < .001
## Petal.Length * Species [versicolor] |       -0.09 | 0.26 | [-0.61,  0.42] |  -0.36 | 0.721 
## Petal.Length * Species [virginica]  |       -0.13 | 0.26 | [-0.64,  0.38] |  -0.50 | 0.618
```
  

`model_parameters()` can also be used for parameter standardization:

```{.r .chunk-highlight}
# standardized parameters
model_parameters(model, standardize = "refit")
```

```
## Package 'effectsize' required to calculate standardized coefficients. Please install it.
```

```
## Parameter                           | Coefficient |   SE |         95% CI | t(143) |      p
## -------------------------------------------------------------------------------------------
## (Intercept)                         |        2.89 | 0.36 | [ 2.18,  3.60] |   8.01 | < .001
## Petal.Length                        |        0.26 | 0.25 | [-0.22,  0.75] |   1.07 | 0.287 
## Species [versicolor]                |       -1.66 | 0.53 | [-2.71, -0.62] |  -3.14 | 0.002 
## Species [virginica]                 |       -1.92 | 0.59 | [-3.08, -0.76] |  -3.28 | 0.001 
## Petal.Width                         |        0.62 | 0.14 | [ 0.34,  0.89] |   4.41 | < .001
## Petal.Length * Species [versicolor] |       -0.09 | 0.26 | [-0.61,  0.42] |  -0.36 | 0.721 
## Petal.Length * Species [virginica]  |       -0.13 | 0.26 | [-0.64,  0.38] |  -0.50 | 0.618
```
<br>


## Code chunk options

See the [R markdown documentation](https://rmarkdown.rstudio.com/lesson-3.html) to view chunk options. <br>

### Example: `echo` and `eval`

Readers should be able to identify where every file in a workflow comes from (little is more frustrating than wondering where a required data file is located). Code used to load or extract data (from `galah`, for example) should be clearly identified. <br>

However, some code takes a very long time to run and you may have saved it locally or in a repository to save time and/or space. In this case, it is possible to show code without running it. <br>

Add `eval = FALSE` to the chunk header to display the code but prevent the chunk from running: 

```{.r .chunk-highlight}
``{r, eval = FALSE}
ala_counts(group_by = "phylum")
`
```


You can then load a local file in the background, without showing the code. <br>

Add `echo = FALSE` to your chunk header to run the code but prevent the chunk from displaying:

```{.r .chunk-highlight}
``{r, echo = FALSE}
data <- readRDS(file = "local_file.rds")
`
```



