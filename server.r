library(shiny)
library(shinydashboard)
library(httr)
library(jsonlite)
library(dplyr)
library(stringr)
library(leaflet)
library(leaflet.extras)
library(ggplot2)
library(plotly)

get_data <- function(lat, lon, api_key="f2438f3937b40ff3e11b33f2f8a4f9b6") {
  url <- paste0("https://api.openweathermap.org/data/2.5/forecast?lat=", lat, "&lon=", lon, "&appid=", api_key, "&units=metric")
  response <- GET(url)
  content(response, "text") %>% fromJSON()
}

plot <- function(forecast, feature_name) {
  ggplot(forecast, aes(x = time)) +
    geom_line(aes(y = forecast[[feature_name]], color = "red")) +
    geom_point(aes(y = forecast[[feature_name]], color = "black")) +
    labs(y = "", x = "") +
    scale_x_datetime(date_labels = "%d-%m-%y %H:%m", date_breaks = "3 hour") +
    theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))
}

shinyServer(function(input, output) {
  output$map <- renderLeaflet({
    leaflet() %>%
      addTiles() %>%
      setView(105.852289795876, 21.0278445982958, zoom = 15) %>%
      addMarkers(105.852289795876, 21.0278445982958, popup = "Location") %>%
      addControlGPS(options = gpsOptions(position = "topleft", activate=TRUE, autoCenter=TRUE, maxZoom=20, setView=TRUE))
  })
  
  observe({
    lat <- input$map_click[[1]]
    lng <- input$map_click[[2]]
    if (is.null(lat)) {
      lat <- 21.0278445982958
      lng <- 105.852289795876
    }
   
    data <- get_data(lat, lng)
    forecast <- data.frame(time = as.POSIXct(data$list$dt_txt),
                           temp = data$list$main$temp,
                           feels_like = data$list$main$feels_like,
                           temp_min = data$list$main$temp_min,
                           temp_max = data$list$main$temp_max,
                           pressure = data$list$main$pressure,
                           sea_level = data$list$main$sea_level,
                           grnd_level = data$list$main$grnd_level,
                           humidity = data$list$main$humidity,
                           cloudiness = data$list$clouds$all,
                           visibility = data$list$visibility/1000,
                           wind_speed = data$list$wind$speed,
                           wind_deg = data$list$wind$deg,
                           wind_gust = data$list$wind$gust)
      
    map_proxy <- leafletProxy("map") %>% clearMarkers() %>% addMarkers(lat=lat, lng=lng, popup = data$city$name)
      
    output$date <- renderText({format(Sys.Date(), "%d-%m-%Y")})
    output$location1 <- renderText({paste0(data$city$name, " (", lat, ", ", lng, ")")})
    output$condition <- renderText({str_to_title(data$list$weather[[1]]$description)})
    output$temp <- renderText({paste0(data$list$main$temp[1], " °C", " / ", data$list$main$feels_like[1], " °C")})
    output$humidity <- renderText({paste0(data$list$main$humidity[1], "%")})
    output$visibility <- renderText({paste0(data$list$visibility[1]/1000, " km")})
    output$cloudiness <- renderText({paste0(data$list$clouds$all[1], " %")})
    output$wind_speed <- renderText({paste0(data$list$wind$speed[1], " m/s")})
      
    output$location2 <- renderText({paste0(data$city$name, " (", lat, ", ", lng, ")")})
    output$temp_forecast <- renderPlotly({plot(forecast, "temp")})
    output$feels_like_forecast <- renderPlotly({plot(forecast, "feels_like")})
    output$temp_min_forecast <- renderPlotly({plot(forecast, "temp_min")})
    output$temp_max_forecast <- renderPlotly({plot(forecast, "temp_max")})
    output$pressure_forecast <- renderPlotly({plot(forecast, "pressure")})
    output$sea_level_forecast <- renderPlotly({plot(forecast, "sea_level")})
    output$grnd_level_forecast <- renderPlotly({plot(forecast, "grnd_level")})
    output$humidity_forecast <- renderPlotly({plot(forecast, "humidity")})
    output$cloudiness_forecast <- renderPlotly({plot(forecast, "cloudiness")})
    output$visibility_forecast <- renderPlotly({plot(forecast, "visibility")})
    output$wind_speed_forecast <- renderPlotly({plot(forecast, "wind_speed")})
    output$wind_deg_forecast <- renderPlotly({plot(forecast, "wind_deg")})
    output$wind_gust_forecast <- renderPlotly({plot(forecast, "wind_gust")})
  })
})