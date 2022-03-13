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
   plot1 <- ggplot(data, aes_string(colnames(data)[1], colnames(data)[2])) + geom_point() 

}



#Plot2
mean_data1 <- group_by(temp_df,month,room_type) %>%
             summarise(humidity = mean(humidity, na.rm = TRUE),date,hour_of_day,day_of_week)
plot2 <- ggplot(mean_data1) +
    aes(x = month,
        y = humidity) + geom_line()


app <- dash_app()

 app %>% set_layout(
    time_scale,
    h1("The average of temperature of the selected rooms is plotted with the selected time range"),
    dccGraph(id = "plot1"),
    h2("The average of humidity of the selected rooms is plotted with the selected time range"),
    dccGraph(figure = ggplotly(plot2))
    )

app$callback(
    output("plot1", "figure"),
    list(input("time_scale", "value")),
    function(time) {
        if (time == "full") {
             new_temp <-  group_by(temp_df, date) %>%
             summarise(temperature = mean(temperature))
        }
        else if (time == "month") {
             new_temp <-  group_by(temp_df, month) %>%
             summarise(temperature = mean(temperature))
        }
        else if (time == "daily") {
             new_temp <- group_by(temp_df, day_of_week) %>%
             summarise(temperature = mean(temperature))
        }
        else if (time == "hourly") {
             new_temp <-  group_by(temp_df, hour_of_day) %>%
             summarise(temperature = mean(temperature))
        }
        p <- plot1_func(new_temp)
        ggplotly(p)
    }
)

app %>% run_app()