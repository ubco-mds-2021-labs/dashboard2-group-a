library(dash)
library(dashCoreComponents)
library(dashBootstrapComponents)
library(ggplot2)
library(plotly)
library(tidyverse)
library(rlang)

#data import section 
energy <- read_csv("https://raw.githubusercontent.com/ubco-mds-2021-labs/dashboard1-group-a/main/data/energy_df_full.csv")

#functions section

start_date <- "2016-01-25"
end_date <- "2016-01-30"

energy_plot <- function(){
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
    p1
}

weather_plot <-function(){
    p2 <- energy %>%
    filter(date >= start_date & date <= end_date) %>%
    ggplot()+
        aes(
        x = date,
        y = temperature_outside
        )+
        geom_line()
    p2
}

#Helper Function
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

# #plotting section 

p1 <- energy_plot()
# p2 <- weather_plot() 

# Create a Dash app
app <- dash_app()

# Set the layout of the app
app %>% set_layout(
  h1('Tab 2: Energy Use!!'),
  div("Tab2: Plot1"), 
  dccGraph(figure=ggplotly(p1)), 
  div("Tab2: Plot2"),
  dccDropdown(id="weather_yaxis", options=choice2, value="temperature_outside"),
  dccGraph(id="weather_plot") 
)

#Callback functions
app %>% add_callback(
    output("weather_plot", "figure"), 
    input("weather_yaxis", 'value'), 
function(y){
    p <- energy %>%
    filter(date >= start_date & date <= end_date) %>%
    ggplot()+
        aes(
        x = date,
        y = !!sym(y)
        ) +
        geom_line()
    
    ggplotly(p)
    }
    
)


# Run the app
app %>% run_app()