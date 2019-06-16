#Crime Statistics Vancouver
#PS: Dataset downloaded automatically once a week

#############################################################################
#library
library(shiny)
library(ggplot2)
library(rgdal)
library(dplyr)
library(readr)
library(leaflet)


#############################################################################
#Prepare dataset for shiny server

#import current dataset
working <- read_csv("crime_csv_all_years.csv")


#Test condition for updating dataset
#PS: If day differece < 8, no need to download new dataset

if(Sys.Date() - max(working$DATE) > 8) {
  
  #Download file
  url <- "ftp://webftp.vancouver.ca/opendata/csv/crime_csv_all_years.zip"
  tmp <- tempfile()
  
  download.file(url, tmp, mode = "wb")
  unzip(tmp, "crime_csv_all_years.csv")
  
  working <- read_csv("crime_csv_all_years.csv")
  
  #Date
  working$DATE <- as.Date(paste0(working$YEAR, "-", working$MONTH, "-", working$DAY))
  
  
  #Create weekday
  #PS: assign levels in order so that Sun is first and sat is last
  #working$WEEKDAY <-
  #  factor(
  #    weekdays(working$DATE, abbreviate = TRUE),          #Use abbreviate to make it shorter and easier to plot on graph
  #    levels = c(
  #      "Sun",
  #      "Mon",
  #      "Tue",
  #      "Wed",
  #      "Thu",
  #      "Fri",
  #      "Sat"
  #    ),
  #    ordered = TRUE
  #  )
  
  
  #X and Y coordinates (changed from UTM format to Latitude and longtitude)
  #PS: because only latitude and longtitude can be plotted on ggmap
  
  #prepare UTM coordinates matrix
  #PS: working$X and working$Y are UTM Easting and Northing respectively
  #PS: zone= UTM zone, vancouver is UTM10
  utmcoor<-SpatialPoints(cbind(working$X, working$Y), proj4string=CRS("+proj=utm +zone=10"))
  
  #From utm to latitude or longtitude
  longlatcoor<-data.frame(spTransform(utmcoor,CRS("+proj=longlat")))
  
  colnames(longlatcoor) <- c("Longtitude", "Latitude")
  
  
  #combine the new lat and lon with original dataset
  working <- cbind(working, longlatcoor)
  
  
  #minimize memory
  remove(utmcoor, longlatcoor)
  
  
  #select relevant columns only
  working <-
    working[, c("TYPE",
                "YEAR",
                "MONTH",
                "DAY",
                "HOUR",
                "MINUTE",
                "DATE",
                "Longtitude",
                "Latitude")]
  
  #format(object.size(working), units = "Mb")
  
  #Export data
  write.csv(working,
            "crime_csv_all_years.csv",
            na = "",
            row.names = FALSE)
  
} 


#############################################################################
#Read dataset

#Turn month and hour into int
working$YEAR <- as.numeric(working$YEAR)
working$MONTH <- as.numeric(working$MONTH)
working$HOUR <- as.numeric(working$HOUR)


#summarized dataset
#By crime by month
CrimeHour <- working %>% group_by(YEAR, MONTH, HOUR, TYPE) %>% summarise(
  Count = n()
)

#############################################################################

# Define UI for application
ui <- fluidPage(tabsetPanel(
  
  tabPanel("Interactive Crime Map",
           
           # Application title
           titlePanel("Vancouver Crime Map"),
           
           p(
             "(Developed by",
             a(href = "http://www.linkedin.com/in/livlau", "Lavinia Lau"),
             " | Data Source: ",
             a(href = "http://data.vancouver.ca/datacatalogue/crime-data.htm", "Vancouver Police Department"),
             ")"
           ),
           
           #horizontal line
           hr(),
           
           # Sidebar with a slider input for Year 
           sidebarLayout(
             sidebarPanel(
               sliderInput("YearMap",
                           h4("YEAR: Select a year:"),
                           min = 2003,
                           max = max(working$YEAR),
                           value = 2017),
               
               br(),
               
               #Month slider
               sliderInput("MonthMap",
                           h4("MONTH: Select a month:"),
                           min = 1,
                           max = 12,
                           value = 1),
               
               br(),
               
               #crime type checkbox
               checkboxGroupInput("CrimeTypeMap", 
                                  h4("Select which crime types to display on map:"),
                                  unique(working$TYPE),
                                  selected = unique(working$TYPE)),
               
               p(code("Note: Locations of homocide and offence against a person are hidden in the original data source."))
               
             ),
             
             mainPanel(
               
               h4(strong("Instruction: Zoom in the map or mouse over the map to see the crime details.")),

               br(),

               leafletOutput("CrimeMap", height = "600px")
             )
           )

),

tabPanel("Crime Statistics",
         
         # Application title
         titlePanel("Crime Statistics Across Year, Month and Hour"),

         p(
           "(Developed by",
           a(href = "http://www.linkedin.com/in/livlau", "Lavinia Lau"),
           " | Data Source: ",
           a(href = "http://data.vancouver.ca/datacatalogue/crime-data.htm", "Vancouver Police Department"),
           ")"
         ),
         
         #horizontal line
         hr(), 
         
         
         # Sidebar with a slider input for Year 
         sidebarLayout(
           sidebarPanel(
             
             #Year slider 
             sliderInput("Year",
                         h4("YEAR: Select a year or a range of years"),
                         min = 2003,
                         max = max(working$YEAR),
                         value = c(2003,2017)),
             
             #next line
             br(),
             
             #Month Slider
             sliderInput("Month",
                         h4("MONTH: Select a month or a range of months"),
                         min = 1,
                         max = 12,
                         value = c(1,12)),
             
             #next line
             br(),
             
             
             #crime type
             checkboxGroupInput("CrimeType", 
                                h4("Select which crime types to display"),
                                unique(working$TYPE),
                                selected = unique(working$TYPE))
             
           ),
           
           
           # Show a plot of the generated distribution
           mainPanel(
             plotOutput("PlotYear", height = "600px"),
             br(),
             plotOutput("PlotMonth", height = "600px"),
             br(),
             plotOutput("PlotHour", height = "600px")
           )
         )
)


))

###############################################################
# Define server logic to plot

server <- function(input, output) {


  #Plot Year
  output$PlotYear <- renderPlot({
    ggplot(CrimeHour[CrimeHour$YEAR %in% c(min(input$Year):max(input$Year)) &
                       CrimeHour$MONTH %in% c(min(input$Month):max(input$Month)) &
                       CrimeHour$TYPE %in% input$CrimeType
                     , ], 
           aes(x = as.numeric(YEAR), y = Count, fill = TYPE)) +
      geom_bar(stat = "sum", size=1) +
      labs(title = "Crime Type Trend Across Year", x = "Year", y = "Total Crime") +
      facet_wrap(~TYPE, ncol = 3) +
      theme(text=element_text(size=17),legend.position = "none")
  })
  

  #Plot Month
   output$PlotMonth <- renderPlot({
     ggplot(CrimeHour[CrimeHour$YEAR %in% c(min(input$Year):max(input$Year)) &
                        CrimeHour$MONTH %in% c(min(input$Month):max(input$Month)) &
                        CrimeHour$TYPE %in% input$CrimeType
                        , ], 
            aes(x = as.factor(MONTH), y = Count, fill = TYPE)) +
       geom_bar(stat = "sum", size=1) +
       labs(title = "Crime Type Trend Across Month", x = "Month", y = "Total Crime") +
       facet_wrap(~TYPE, ncol = 3) +
       theme(text=element_text(size=17),legend.position = "none")
   })
   
   
   #Plot Hour
   output$PlotHour <- renderPlot({
     ggplot(CrimeHour[CrimeHour$YEAR %in% c(min(input$Year):max(input$Year)) &
                        CrimeHour$MONTH %in% c(min(input$Month):max(input$Month)) &
                        CrimeHour$TYPE %in% input$CrimeType
                      , ], 
            aes(x = as.numeric(HOUR), y = Count, fill = TYPE)) +
       geom_bar(stat = "sum", size=1) +
       labs(title = "Crime Type Trend Across Hour", x = "Hour", y = "Total Crime") +
       facet_wrap(~TYPE, ncol = 3) +
       theme(text=element_text(size=17),legend.position = "none")
   })
   
   

   #Map
   output$CrimeMap <- renderLeaflet({
     leaflet(working[which(working$YEAR == input$YearMap &
                             working$MONTH == input$MonthMap &
                             !is.na(working$HOUR) &
                             working$TYPE %in% input$CrimeTypeMap), ]) %>%
       addTiles() %>%
       addMarkers(
         lng = ~ Longtitude,
         lat = ~ Latitude,
         label = ~ paste0(TYPE, " (", DATE, ", ", HOUR, ":", MINUTE, ")"),
         clusterOptions = markerClusterOptions()
       )
   })
   
   
}


#########################################
# Run the application 
shinyApp(ui = ui, server = server)


##########################################
#Upload to Shiny Server

#library(rsconnect)
#rsconnect::deployApp('C:/Users/Lavinia/Documents/apps/CrimeStatistics')



