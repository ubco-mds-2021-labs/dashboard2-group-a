library(dash)
library(dashHtmlComponents)
install.packages("devtools")
library(devtools)
install_github('facultyai/dash-bootstrap-components@r-release')
library(dashBootstrapComponents)
app <- dash_app()


TAB1_DROPDOWN = dccDropdown(
  options=list(
    list(label="Room Type", value = 1),
    list(label="Sun light", value = 2),
    list(label="Floor of House", value = 3),
    list(label="Daytime/Nighttime", value = 4)
  ),
  id="tab1_dropdown",
  value=1,
  style=list(color="blue")
)

tab1_selector = htmlDiv(
  list(
    dbcLabel("Include:"),
    dbcChecklist(
      id="selection_tab1",
      options=list(
        list(label="Bedroom",value = "Bedroom"),
        list(label="Functional Space",value = "Functional Space"),
        list(label="Living Area",value = "Living area"),
        list(label="Outside",value = "Outside")
      ),
      value='Functional Space',
      
      inline=FALSE,
    )
  )
)

time_scale= htmlDiv(
  list(
    dbcLabel("Timescale:"),
    dbcRadioItems(
      id="time_scale",
      options=list(
        list(label="Full",value = "full"),
        list(label="Month",value = "month"),
        list(label="Day of the week",value = "daily"),
        list(label="Hour of the day",value = "hourly")
      ),
      value="full",
      inline=FALSE,
    )
  )
)



font_style_title<-list(size = "30px")
font_style_label<-list(size = "20px")

SIDEBAR1 <- list(dbcRow("Energy Dashboard",style=font_style_title),
                 dbcRow("___________________________________________"),
                 br(),
                 dbcRow("This dashboard figure out which factors make a difference to house temperature and humidity. You can choose the factors from the dropdown below."),
                 br(),
                 dbcLabel("Compare Across:",style=font_style_label),
                 br(),
                 dbcRow(TAB1_DROPDOWN),
                 br(),
                 dbcRow(tab1_selector),
                 br(),
                 dbcRow(time_scale)
                 
)



TAB2_DROPDOWN = dccDropdown(
  id="tab2_dropdown",
  options=list(
    list(label="Outside Humidity", value=1),
    list(label= "Outside Temperature", value=2),
    list(label= "Windspeed", value=3)

  ),
  value = 1,
  style=list(color="blue")
)

tab2_selector = htmlDiv(
  list(
    dbcLabel("Include:"),
    dbcChecklist(
      id="selection_tab2",
      options=list(
        list(label = "Low Humidity", value="Low Outside Humidity"),
        list(label = "Mid-low Humidity", value="Mid-low Humidity"),
        list(label = "Mid-high Humidity", value="Mid-High Outside Humidity"),
        list(label = "High Humidity", value="High Outside Humidity")
      ),
      value='Low Outside Humidity',
      
      inline=FALSE,
    )
  )
)

date_picker = dccDatePickerRange(
  id="my-date-picker-range",
  min_date_allowed=as.Date(c("2016-01-11")),
  max_date_allowed=as.Date(c("2016-05-27")),
  initial_visible_month=as.Date("2016-01-11"),
  start_date=as.Date(c("2016-01-11")),
  end_date=as.Date(c("2016-05-27"))
)



weather_list = list(
  "temperature_outside",
  "dewpoint",
  "humidity_outside",
  "pressure",
  "windspeed",
  "visibility"
)

choice = dccDropdown(
  id="chart_dropdown",
  value="temperature_outside",
  style=list(color="blue"),
  options=weather_list,
)

SIDEBAR2 <- list(dbcRow("Energy Dashboard",style=font_style_title),
            dbcRow("___________________________________________"),
            br(),
            dbcRow("This dashboard explores the relationship between climate factors and energy usage. You can choose the factors from the dropdown below."),
            br(),
            dbcLabel("Choose Date Range:",style=font_style_label),
            br(),
            dbcRow(date_picker),
            br(),
            dbcLabel("Choose Climate Factor:",style=font_style_label),
            br(),
            dbcRow(choice),
            br()
            # br(),
            # dbcRow(TAB2_DROPDOWN),
            # br(),
            # dbcRow(tab2_selector)
)

background_style<-list(backgroundColor="grey",color="white")


SIDEBAR = dbcCol(id="sidebar",
                 width=3,
                 style=background_style)

TAB1 <- list(
    "This is Tab1"
  )

TAB2<-list(
  "This is Tab2"
  )

# LAYOUT = dbcContainer(
#   fluid=TRUE,
#   children=dbcRow(
#     children=list(
#       SIDEBAR,
#       dbcCol(
#         md=9,
#         children=dbcTabs(
#           children=list(TAB1, TAB2), id="tab_selection", active_tab="tab-0"
#         )
#       )
#   )
#   )
# )
tabs <- div(
  list(
    dbcTabs(
      list(
        dbcTab(label = "House Climate", tab_id = "tab-0"),
        dbcTab(label = "Energy Usage", tab_id = "tab-1")
      ),
      id = "tabs",
      active_tab = "tab-0"
    ),
    div(id = "content")
  )
)



LAYOUT = dbcRow(
  list(
    dbcCol(SIDEBAR,width=3),
    dbcCol(tabs)
  )
)

app |> set_layout(LAYOUT)


app$callback(
  output("content", "children"),
  list(input("tabs", "active_tab")),
  function(at) {
    if (at == "tab-0") {
      return(TAB1)
    } else if (at == "tab-1") {
      return(TAB2)
    }
    return(p("This should not ever be displayed"))
  }
)

app$callback(
  output("sidebar", "children"),
  list(input("tabs", "active_tab")),
  function(at) {
    if (at == "tab-0") {
      return(SIDEBAR1)
    } else if (at == "tab-1") {
      return(SIDEBAR2)
    }
    return(p("This should not ever be displayed"))
  }
)

app$run_server(debug = T)

