library(dash)
library(dashHtmlComponents)
install.packages("devtools")
library(devtools)
install_github('facultyai/dash-bootstrap-components@r-release')
library(dashBootstrapComponents)

temperature_df_full<-read.csv("../data/temperature_df_full.csv")
energy_df_full<-read.csv("../data/energy_df_full.csv")

app <- Dash$new(external_stylesheets = dbcThemes$BOOTSTRAP,suppress_callback_exceptions = TRUE)

# function for sidebar1

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






SIDEBAR1 <- list(dbcRow("Energy Dashboard",style=list('font-size'='30px')),
                 dbcRow("___________________________________________"),
                 br(),
                 dbcRow("This dashboard figure out which factors make a difference to house temperature and humidity. You can choose the factors from the dropdown below."),
                 br(),
                 dbcLabel("Compare Across:",style=list('font-size'='20px')),
                 br(),
                 dbcRow(TAB1_DROPDOWN),
                 br(),
                 dbcRow(tab1_selector),
                 br(),
                 dbcRow(time_scale)
                 
)

room_list = list(
  list(label="Bedroom",value = "Bedroom"),
  list(label="Functional Space",value = "Functional Space"),
  list(label="Living Area",value = "Living area"),
  list(label="Outside",value = "Outside")
)
sunlight_list = list(
  list(label="West Facing",value = "West Facing"),
  list(label="East Facing",value = "East Facing"),
  list(label="Outside",value = "Outside")
)
floor_list = list(
  list(label="Ground Floor",value = "Ground Floor"),
  list(label="Second Floor",value = "Second Floor"),
  list(label="Outside",value = "Outside")

)
daynight_list = list(
  list(label="Morning",value = "Morning"),
  list(label="Afternoon",value = "Afternoon"),
  list(label="Evening",value = "Evening"),
  list(label="Night",value = "Night")
)


# function for sidebar2

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
  list(label="temperature_outside",value = "temperature_outside"),
  list(label="dewpoint",value = "dewpoint"),
  list(label="humidity_outside",value = "humidity_outside"),
  list(label="pressure",value = "pressure"),
  list(label="windspeed",value = "windspeed"),
  list(label="visibility",value = "bisibility")
)

humidity_list = list(
  list(label="Low Humidity",value = "Low Outside Humidity"),
  list(label="Mid-low Humidity",value = "Mid-Low Outside Humidity"),
  list(label="Mid-high Humidity",value = "Mid-High Outside Humidity"),
  list(label="High Humidity",value = "High Outside Humidity")
)
temp_list = list(
  list(label="Low Temperature",value = "Low Outside Temperature"),
  list(label="Mid-low Temperature",value = "Mid-Low Outside Temperature"),
  list(label="Mid-high Temperature",value = "Mid-High Outside Temperature"),
  list(label="High Temperature",value = "High Outside Temperature")
)
wind_list = list(
  list(label="Low Windspeed",value = "Low Outside Windspeed"),
  list(label="Mid-low Windspeed",value = "Mid-Low Outside Windspeed"),
  list(label="Mid-high Windspeed",value = "Mid-High Outside Windspeed"),
  list(label="High Windspeed",value = "High Outside Windspeed")
)


choice = dccDropdown(
  id="chart_dropdown",
  value="temperature_outside",
  style=list(color="blue"),
  options=weather_list,
)

SIDEBAR2 <- list(dbcRow("Energy Dashboard",style=list('font-size'='30px')),
            dbcRow("___________________________________________"),
            br(),
            dbcRow("This dashboard explores the relationship between climate factors and energy usage. You can choose the factors from the dropdown below."),
            br(),
            dbcLabel("Choose Date Range:",style=list('font-size'='20px')),
            br(),
            dbcRow(date_picker),
            br(),
            dbcLabel("Choose Climate Factor:"),
            br(),
            dbcRow(choice),
            br()
            # br(),
            # dbcRow(TAB2_DROPDOWN),
            # br(),
            # dbcRow(tab2_selector)
)

background_style<-list('color' = 'white',
           'background-color' = 'grey', 
           'font-size' = '20px',
           'padding-left' = '30px',
           'padding-top' = '20px',
           'top-margin' = '0',
           'left-mergin' = '5')


# function for sidebar layout interface

SIDEBAR = dbcCol(id="sidebar",
                 md=3,
                 style=background_style)

# function for tab1
TAB1 <- list(
    "This is Tab1"
  )

# function for tab2
TAB2<-list(
  "This is Tab2"
  )


# function for tab layout interface
tabs <- dbcCol(
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
  ),md = 9
)



LAYOUT <- div(
dbcRow(
  list(
    SIDEBAR,
    tabs
  )
)
)



app$layout(LAYOUT)


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

app$callback(
  output("selection_tab1", "options"),
  list(input("tab1_dropdown", "value")),
  function(tab1_dropdown){
  if (tab1_dropdown==1){
   return (room_list)
  }else if(tab1_dropdown==2){
   return(sunlight_list)
  }else if(tab1_dropdown==3){
  return(floor_list)
  }else if (tab1_dropdown==4){
  return(daynight_list)
  }
  }
)

app$callback(
  output("selection_tab2", "options"),
  list(input("tab2_dropdown", "value")),
  function(tab2_dropdown){
    if (tab2_dropdown==1){
      return (humidity_list)
    }else if(tab2_dropdown==2){
      return(temp_list)
    }else if(tab2_dropdown==3){
      return(wind_list)
    }
  }
)

app$run_server(debug = T)

