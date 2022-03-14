library(dash)
library(dashCoreComponents)
library(ggplot2)
library(dashBootstrapComponents)
library(plotly)
library(tidyverse)
library(dashHtmlComponents)

#Read the file
temp_df <- read.csv("https://raw.githubusercontent.com/ubco-mds-2021-labs/dashboard2-group-a/data_work/data/temperature_df_full.csv") # nolint

TAB1_DROPDOWN = dccDropdown(  # nolint
  options = list(
    list(label = "Room Type", value = 1),
    list(label = "Sun light", value = 2),
    list(label = "Floor of House", value = 3),
    list(label = "Daytime/Nighttime", value = 4)
  ),
  id = "tab1_dropdown",
  value = 1,
  style = list(color = "blue")
)


time_scale = htmlDiv( # nolint
  list(
    dbcLabel("Timescale:"),
    dbcRadioItems(
      id = "time_scale",
      options = list(
        list(label = "Full", value = "full"),
        list(label = "Month", value = "month"),
        list(label = "Day of the week", value = "daily"),
        list(label = "Hour of the day", value = "hourly")
      ),
      value = "full",
      inline = FALSE,
    )
  )
)


app <- dash_app()

 app %>% set_layout(
    time_scale, TAB1_DROPDOWN,
    h1("The average of temperature of the selected rooms is plotted with the selected time range"), # nolint
    dccGraph(id = "plot1"),
    h2("The average of humidity of the selected rooms is plotted with the selected time range"), # nolint
    dccGraph(id = "plot2")
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

app %>% run_app()