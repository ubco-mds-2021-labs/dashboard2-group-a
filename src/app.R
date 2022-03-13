library(dash)
library(dashCoreComponents)
library(ggplot2)
library(dashBootstrapComponents)
library(plotly)
library(tidyverse)
library(dashHtmlComponents)

#Read the file
temp_df <- read.csv("https://raw.githubusercontent.com/ubco-mds-2021-labs/dashboard1-group-a/main/data/temperature_df_full.csv")


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


#Plot1
plot1_func <- function(data) {
     # nolint
    plot1 <- ggplot(data) +
    aes(x = time,
        y = temperature,
        color = room_type, group = room_type) + geom_line()

}



#Plot2
mean_data1 <- group_by(temp_df,month,room_type) %>%
             summarise(humidity = mean(humidity, na.rm = TRUE),date,hour_of_day,day_of_week)
plot2 <- ggplot(mean_data1) +
    aes(x = month,
        y = humidity,
        color = room_type,group = room_type) + geom_line()


app <- dash_app()

 app %>% set_layout(
    time_scale,
    h1("The average of temperature of the selected rooms is plotted with the selected time range"),
    dccGraph(id = "plot1"),
    h2("The average of humidity of the selected rooms is plotted with the selected time range"),
    dccGraph(figure = ggplotly(plot2))
    )

app |> add_callback(
    output("plot1", "figure"),
    list(input("time_scale", "value")),
    function(time_scale) {
        if (time_scale == "full") {
             new_temp <-  group_by(temp_df, date, room_type) %>%
             summarise(temperature = mean(temperature, na.rm = TRUE),time = date)
        }
        else if (time_scale == "month") {
             new_temp <-  group_by(temp_df, month, room_type) %>%
             summarise(temperature = mean(temperature, na.rm = TRUE),time = month)
        }
        else if (time_scale == "daily") {
             new_temp <- group_by(temp_df, day_of_week, room_type) %>%
             summarise(temperature = mean(temperature, na.rm = TRUE),time = day_of_week)
        }
        else if (time_scale == "hourly") 
        {
             new_temp <-  group_by(temp_df, hour_of_day, room_type) %>%
             summarise(temperature = mean(temperature, na.rm = TRUE),time = hour_of_day)
        }
       
        p <- plot1_func(new_temp)
        ggplotly(p)
    }
)

app %>% run_app()