create_team_photo = function(img_src){
  tags$div(
    class = "main-column",
    tags$img(class="team-img",
             src=img_src,
             style="width:550px; height:100%")
    )
}

create_team_about = function(text){
  tags$div(
    class = "main-column",
    tags$div(
      class = "main-about-body",
      p(class = "about-text", text)
    ),
    tags$div(
      class = "arrow bounce",
      tags$a(
        class = "arrow-link fa fa-arrow-down fa-2x", 
        href = "#team-photo-grid", 
        style = "will-change:scroll-position; text-decoration:none;"
      )
    )
  )
}

# Index page: Our Values boxes

create_values_box1 = function(value, icon, text){
  tags$div(
    class = "col-lg-4 px-0",
    tags$div(
      class = "value-block value-feature-1",
      h3(class = "value-text", 
         tags$i(class = icon), value),
      p(text)
    )
  )
}

create_values_box2 = function(value, icon, text){
  tags$div(
    class = "col-lg-4 px-0",
    tags$div(
      class = "value-block value-feature-2",
      h3(class = "value-text", 
         tags$i(class = icon), value),
      p(text)
    )
  )
}

create_values_box3 = function(value, icon, text){
  tags$div(
    class = "col-lg-4 px-0",
    tags$div(
      class = "value-block value-feature-3",
      h3(class = "value-text", 
         tags$i(class = icon), value),
      p(text)
    )
  )
}

# Project cards - note: these are not in use

create_proj_card = function(img_src, url, title, text, text2){
  tags$div(
    class = "card",
    tags$img(class="card-img-top",
             src=img_src,
             style="width:250px;height:100%"),
    tags$div(
      class = "card-body",
      h4(
        a(href = url,  
          title)),
      p(class = "card-text", 
        text, br(), text2)
    )
  )
  
}

# About: Team member card

create_team_card <- function(person_page, img_src, name, alt, text, url_web, url_twitter, url_github) {
  tags$div(
    class = "card-column",
    tags$div(
      class = "team-card",
      a(href = person_page,
      tags$img(class ="team-image", src = img_src, alt = name, style = "width:100%")),
      tags$div(
        class = "container",
        a(href = person_page, 
          h3(class = "name", name)),
        p(class = "job-title", text)
      )))
}


# About: Personal link buttons

create_button <- function(icon, url) {
  tags$div( 
    class = "button-column",
    tags$button(
      class = "button-2",
      tags$i(
        href = url,
        class = icon
    )))
}

create_category_button <- function(silhouette_image, url, color) {
  tags$div( 
    class = "category-column",
    tags$button(
      class = "category-button",
      tags$i(
        href = url,
        class = icon,
        style = paste0("color: ", color)
      )))
}


# Footer logos and acknowledgement of traditional land owners

add_footer = function(){
  tags$div(class = "footer-row",
  tags$div(
    class = "column-footer footer-logo",
    tags$p(
      class = "footer-text",
      "The ALA is made possible by contributions from its partners, is supported 
      by ", 
      tags$a(href = "https://www.education.gov.au/national-collaborative-research-infrastructure-strategy-ncris", 
             class = "footer-link",
             "NCRIS"), 
      ", is hosted by ",
      tags$a(href = "https://csiro.au/",
             class = "footer-link",
             "CSIRO"), 
      ", and is the Australian node of",
      tags$a(href = "https://www.gbif.org/en/", 
             id = "d-article",
             class = "footer-link",
             "GBIF"), 
      "."),
    tags$img(
      src = "images/logos/NCRIS_logo.png",
      style = "width:auto;height:90px;margin-left:0px;margin-right:2px"),
    tags$img(
      src = "images/logos/CSIRO_logo.png",
      style = "width:auto;height:90px;margin-left:2px;margin-right:0px"),
    tags$img(
      src = "images/logos/GBIF-2015.png",
      style = "width: auto;height:90px;margin-left:-10px;margin-right:0px"
    )
  ),
  tags$div(
    class = "column-footer footer-logo",
    tags$p(
      class = "footer-text",
      tags$strong("Acknowledgement of Traditional Owners and Country")
    ),
    tags$p(
      class = "footer-text-small",
      "The Atlas of Living Australia acknowledges Australia's Traditional Owners 
      and pays respect to the past and present Elders of the nation's Aboriginal 
      and Torres Strait Islander communities. We honour and celebrate the 
      spiritual, cultural and customary connections of Traditional Owners to 
      country and the biodiversity that forms part of that country."
    )
  )
  )
}