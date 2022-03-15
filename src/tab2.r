library(dash)
library(dashCoreComponents)
library(dashBootstrapComponents)
library(ggplot2)
library(plotly)
library(tidyverse)

#data import section 
energy <- read_csv("https://raw.githubusercontent.com/ubco-mds-2021-labs/dashboard1-group-a/main/data/energy_df_full.csv")

#Helper Functions
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

date_picker = dccDatePickerRange(
  id="my-date-picker-range",
  min_date_allowed=as.Date(c("2016-01-11")),
  max_date_allowed=as.Date(c("2016-05-27")),
  initial_visible_month=as.Date("2016-01-11"),
  start_date=as.Date(c("2016-01-12")),
  end_date=as.Date(c("2016-01-13"))
)

# Create a Dash app
app <- dash_app()

# Set the layout of the app
app %>% set_layout(
  h1('Tab 2: Energy Use!!'),
  div("Tab2: Plot1"),
  dbcLabel("Choose Date Range:", style=list('font-size'='20px')),
  br(),
  dbcRow(date_picker),
  br(), 
  dccGraph(id="energy_plot"),
  br(), 
  div("Tab2: Plot2"),
  br(),
  dccDropdown(id="weather_yaxis", options=choice2, value="temperature_outside"),
  br(),
  dccGraph(id="weather_plot") 
)

#Callback functions

##Callback for plot1
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
    ggplot()+
        aes(
        x = date,
        y = energy_usage,
        fill = source
        )+
        geom_area(stat="identity")
    
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
        geom_line()
    
    ggplotly(p2)
    }
    
)


# Run the app
app %>% run_app()