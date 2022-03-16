library(dash)
library(dashHtmlComponents)
#install.packages("devtools")
library(devtools)
#install_github('facultyai/dash-bootstrap-components@r-release')
library(dashBootstrapComponents)
library(ggplot2)
library(plotly)
library(tidyverse)
library(dashHtmlComponents)

temp_df <- read.csv("https://raw.githubusercontent.com/ubco-mds-2021-labs/dashboard2-group-a/data_work/data/temperature_df_full.csv") # nolint
energy <- read_csv("https://raw.githubusercontent.com/ubco-mds-2021-labs/dashboard1-group-a/main/data/energy_df_full.csv")

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
                 #dbcRow(tab1_selector),
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
  start_date=as.Date(c("2016-01-12")),
  end_date=as.Date(c("2016-01-13"))
)



weather_list <-list(
  "temperature_outside",
  "dewpoint",
  "humidity_outside",
  "pressure",
  "windspeed",
  "visibility"
)

choice2 <- lapply(
  weather_list,
  function(wl) {
    list(label = wl,
         value = wl)
  }
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
  id="weather_yaxis",
  value="temperature_outside",
  style=list(color="blue"),
  options=choice2,
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
  h3("The average of temperature of the selected rooms is plotted with the selected time range"), # nolint
  dccGraph(id = "plot1"),
  h3("The average of humidity of the selected rooms is plotted with the selected time range"), # nolint
  dccGraph(id = "plot2")
  )

# function for tab2
TAB2<-list(
  div("Home Energy Usage over Time"),
  br(), 
  dccGraph(id="energy_plot"),
  br(), 
  div("Climate Factor over Time"),
  br(),
  dccGraph(id="weather_plot") 
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


app <- Dash$new(external_stylesheets = dbcThemes$BOOTSTRAP,suppress_callback_exceptions = TRUE)
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

app %>% add_callback(
  output("plot1", "figure"),
  list(input("time_scale", "value"),input("tab1_dropdown", "value")), # nolint
  function(time_scale, dropdown) {
    
    
    if (dropdown == 1) {
      temp_df <- temp_df %>% select(room_type,date,month,day_of_week,hour_of_day,temperature) %>% mutate(compare_across=room_type) # nolint
    }
    else if (dropdown == 2) {
      temp_df <- temp_df %>% select(direction,date,month,day_of_week,hour_of_day,temperature) %>% mutate(compare_across=direction) # nolint
    }
    else if (dropdown == 3) {
      temp_df <- temp_df %>% select(floor,date,month,day_of_week,hour_of_day,temperature) %>% mutate(compare_across=floor) # nolint
    }
    else if (dropdown == 4) {
      temp_df <- temp_df %>% select(time_of_day,date,month,day_of_week,hour_of_day,temperature) %>% mutate(compare_across=time_of_day) # nolint
    }
    
    
    if (time_scale == "full") {
      temp_df$date <- as.Date(temp_df$date)
      new_temp <-  group_by(temp_df, date, compare_across) %>%
        summarise(temperature = mean(temperature), compare_across)
      plot1 <- ggplot(new_temp, aes(date,temperature,group=compare_across, color=compare_across)) +  # nolint
        geom_point() + geom_line() + theme_bw() + labs(x = "Date", y = "Mean of temperature") # nolint
      ggplotly(plot1)
      
    }
    else if (time_scale == "month") {
      new_temp <-  group_by(temp_df, month, compare_across) %>%
        summarise(temperature = mean(temperature))
      plot1 <- ggplot(new_temp, aes(month, temperature, group = compare_across,color = compare_across)) +  # nolint
        geom_point() + geom_line() + theme_bw() + labs(x = "Month", y = "Mean of temperature")# nolint
      ggplotly(plot1)
    }
    else if (time_scale == "daily") {
      new_temp <- group_by(temp_df, day_of_week, compare_across) %>%
        summarise(temperature = mean(temperature))
      plot1 <- ggplot(new_temp, aes(x = factor(day_of_week, c("Monday",
                                                              "Tuesday",
                                                              "Wednesday",
                                                              "Thursday",
                                                              "Friday",
                                                              "Saturday",
                                                              "Sunday")), y=temperature, group = compare_across, color = compare_across)) +  # nolint
        geom_point() + geom_line() + theme_bw() + labs(x = "Day of week", y = "Mean of temperature")# nolint
      ggplotly(plot1)
    }
    else if (time_scale == "hourly") {
      new_temp <-  group_by(temp_df, hour_of_day, compare_across) %>%
        summarise(temperature = mean(temperature))
      plot1 <- ggplot(new_temp, aes(hour_of_day, temperature, group = compare_across, color = compare_across)) +  # nolint
        geom_point() + geom_line() + theme_bw() + labs(x = "Hour of day", y = "Mean of temperature") # nolint
      ggplotly(plot1)
    }       # nolint
  }
)

app %>% add_callback(
  output("plot2", "figure"),
  list(input("time_scale", "value"), input("tab1_dropdown", "value")),
  function(time_scale, dropdown) {
    if (dropdown == 1) {
      temp_df <- temp_df %>% select(room_type, date, month, day_of_week, hour_of_day, humidity) %>% mutate(compare_across=room_type) # nolint
    }
    else if (dropdown == 2) {
      temp_df <- temp_df %>% select(direction, date, month, day_of_week, hour_of_day, humidity) %>% mutate(compare_across=direction) # nolint
    }
    else if (dropdown == 3) {
      temp_df <- temp_df %>% select(floor, date, month, day_of_week, hour_of_day, humidity) %>% mutate(compare_across=floor) # nolint
    }
    else if (dropdown == 4) {
      temp_df <- temp_df %>% select(time_of_day, date, month, day_of_week, hour_of_day, humidity) %>% mutate(compare_across=time_of_day) # nolint
    }
    if (time_scale == "full") {
      temp_df$date <- as.Date(temp_df$date)
      new_temp <-  group_by(temp_df, date, compare_across) %>%
        summarise(humidity = mean(humidity), compare_across)
      plot1 <- ggplot(new_temp, aes(date, humidity, group = compare_across, color = compare_across)) +  # nolint
        geom_point() + geom_line() + theme_bw() + labs(x = "Date", y = "Mean of humidity")# nolint
      ggplotly(plot1)
      
    }
    else if (time_scale == "month") {
      new_temp <-  group_by(temp_df, month, compare_across) %>%
        summarise(humidity = mean(humidity))
      plot1 <- ggplot(new_temp, aes(month, humidity, group = compare_across,color = compare_across)) + # nolint
        geom_point() + geom_line() + theme_bw() + labs(x = "Month", y = "Mean of humidity") # nolint
      ggplotly(plot1)
    }
    else if (time_scale == "daily") {
      new_temp <- group_by(temp_df, day_of_week, compare_across) %>%
        summarise(humidity = mean(humidity))
      plot1 <- ggplot(new_temp, aes(x = factor(day_of_week, c("Monday",
                                                              "Tuesday",
                                                              "Wednesday",
                                                              "Thursday",
                                                              "Friday",
                                                              "Saturday",
                                                              "Sunday")), y=humidity, group = compare_across, color = compare_across)) +  # nolint
        geom_point() + geom_line() + theme_bw() + labs(x = "Day of week", y = "Mean of humidity") # nolint
      ggplotly(plot1)
    }
    else if (time_scale == "hourly") {
      new_temp <-  group_by(temp_df, hour_of_day, compare_across) %>%
        summarise(humidity = mean(humidity))
      plot1 <- ggplot(new_temp, aes(hour_of_day, humidity,group = compare_across, color = compare_across)) +  # nolint
        geom_point() + geom_line() + theme_bw() + labs(x = "Hour of day", y = "Mean of humidity") # nolint
      ggplotly(plot1)
    }
  }
)
app %>% add_callback(
  output("energy_plot", "figure"),
  list( 
    input("my-date-picker-range", 'start_date'),
    input("my-date-picker-range", 'end_date')
  ), 
  function(start_date, end_date){
    p1 <- energy %>%
      filter(date >= start_date & date <= end_date) %>%
      pivot_longer("energy_appliances":"energy_lights", names_to ="source", values_to ="energy_usage") %>% 
      ggplot() +
      aes(
        x = date,
        y = energy_usage,
        fill = source
      ) +
      geom_area(stat="identity") +
      labs(x="Time Elapsed", y="Energy Used in kWh")
    
    ggplotly(p1)
  }
)

#Callback for plot 2
app %>% add_callback(
  output("weather_plot", "figure"),
  list( 
    input("my-date-picker-range", 'start_date'),
    input("my-date-picker-range", 'end_date'),
    input("weather_yaxis", 'value')
  ), 
  function(start_date, end_date, y){
    p2 <- energy %>%
      filter(date >= start_date & date <= end_date) %>%
      ggplot()+
      aes(
        x = date,
        y = !!sym(y)
      ) +
      geom_line() +
      labs(x="Time Elapsed")
    
    ggplotly(p2)
  }
  
)

app$run_server(host = "0.0.0.0", port = Sys.getenv('PORT', 8050))

