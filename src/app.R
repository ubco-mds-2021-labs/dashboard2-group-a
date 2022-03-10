library(dash)
library(dashCoreComponents)
library(ggplot2)
library(dashBootstrapComponents)
library(plotly)
library(tidyverse)
library(dplyr)

#Read the file
temp_df <- read.csv("https://raw.githubusercontent.com/ubco-mds-2021-labs/dashboard1-group-a/main/data/temperature_df_full.csv")
app <- dash_app()

#Plot1
mean_data <- group_by(temp_df,month,room_type) %>%
             summarise(temperature = mean(temperature, na.rm = TRUE),date,hour_of_day,day_of_week)
plot1 <- ggplot(mean_data) +
    aes(x = month,
        y = temperature,
        color=room_type,group=room_type) + geom_line()

#Plot2
mean_data1 <- group_by(temp_df,month,room_type) %>%
             summarise(humidity = mean(humidity, na.rm = TRUE),date,hour_of_day,day_of_week)
plot2 <- ggplot(mean_data1) +
    aes(x = month,
        y = humidity,
        color=room_type,group=room_type) + geom_line()

 app %>% set_layout(
    h1("The average of temperature of the selected rooms is plotted with the selected time range"),
    dccGraph(figure=ggplotly(plot1)),
    h2("The average of humidity of the selected rooms is plotted with the selected time range"),
    dccGraph(figure=ggplotly(plot2))
    )
app %>% run_app()