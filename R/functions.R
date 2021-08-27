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

create_team_card <- function(person_page, img_src, name, alt, text, url_web, url_twitter, url_github) {
  tags$div(
    class = "column",
    tags$div(
      class = "team-card",
      a(href = person_page,
      tags$img(class ="team-image", src = img_src, alt = name, style = "width:100%")),
      tags$div(
        class = "container",
        a(href = person_page, 
          h3(class = "name", name)),
        p(class = "job-title", text)
      ),
      p(
        tags$button(
          class = "button",
          tags$i(
            href = url_web, # personal website
            class = "fas fa-globe"
          )
        ),
        tags$button(
          class = "button",
          tags$i(
            href = url_twitter, # twitter
            class = "fab fa-twitter"
          )
        ),
        tags$button(
          class = "button",
          tags$i(
            href = url_github, # github
            class = "fab fa-github"
          )
        ) 
      )
    )
  )
}
# To add more icons/links:
#| paste another tags$button section in the order you would like it to appear
#| add the url_name to the function heading
#| add the url_name info to the about.Rmd page for each team member


