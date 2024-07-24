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

shinyUI(dashboardPage(
  dashboardHeader(title = "WHERETHER?"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("CURRENT WEATHER", tabName = "current"),
      menuItem("5 DAY FORECAST", tabName = "forecast")
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "current",
        box(width = 12,
          fluidRow(
            box(title = p("YOUR DATE"), width = 6, textOutput("date")),
            box(title = p("CURRENT LOCATION"), width = 6, textOutput("location1")),
            box(title = p("WEATHER CONDITION"), status = "success", solidHeader = TRUE, width = 4, textOutput("condition")),
            box(title = p("CURRENT TEMPERATURE / FEELS LIKE"), status = "danger", solidHeader = TRUE, width = 4, textOutput("temp")),
            box(title = p("HUMIDITY"), status = "success", solidHeader = TRUE, width = 4, textOutput("humidity")),
            box(title = p("VISIBILITY"), status = "warning", solidHeader = TRUE, width = 4, textOutput("visibility")),
            box(title = p("CLOUDINESS"), status = "primary", solidHeader = TRUE, width = 4, textOutput("cloudiness")),
            box(title = p("WIND SPEED"), status = "warning", solidHeader = TRUE, width = 4, textOutput("wind_speed"))
          )
        ),
        leafletOutput("map"),
      ),
      
      tabItem(tabName = "forecast",
        box(title = p("CURRENT LOCATION"), width = 6, textOutput("location2")),
        tabsetPanel(
          tabPanel("Temperature", plotlyOutput("temp_forecast")),
          tabPanel("Feels Like", plotlyOutput("feels_like_forecast")),
          tabPanel("Temperature Min", plotlyOutput("temp_min_forecast")),
          tabPanel("Temperature Max", plotlyOutput("temp_max_forecast")),
          tabPanel("Pressure", plotlyOutput("pressure_forecast")),
          tabPanel("Sea Level", plotlyOutput("sea_level_forecast")),
          tabPanel("GRND Level", plotlyOutput("grnd_level_forecast")),
          tabPanel("Humidity", plotlyOutput("humidity_forecast")),
          tabPanel("Cloudiness", plotlyOutput("cloudiness_forecast")),
          tabPanel("Visibility", plotlyOutput("visibility_forecast")),
          tabPanel("Wind Speed", plotlyOutput("wind_speed_forecast")),
          tabPanel("Wind Deg", plotlyOutput("wind_deg_forecast")),
          tabPanel("Wind Gust", plotlyOutput("wind_gust_forecast"))
        )
      )
    )
  )
))