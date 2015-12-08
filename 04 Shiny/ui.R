#ui.R 

library(shiny)

navbarPage(
  title = "Final Project",
  tabPanel(title = "Scatter Plot",
           fluidRow(column(5),column(7,
                                     actionButton(inputId = "scatter",  label = "Generate Scatter Plot")
           )),
           
           fluidRow(column(1,offset = 1,
                           mainPanel(plotOutput("scatterplot")
                           )))
  ),
  tabPanel(title = "Crosstab",
           fluidRow(column(2),column(5,sliderInput(inputId = "kpi1", label = "Count Rank(low fence)",min = 1, max = 158,  value = 5)),
                    column(5,sliderInput(inputId = "kpi2", label = "Count Rank (medium fence)",min = 1, max = 158,  value = 20))),
           mainPanel(plotOutput("crosstab"))
  ),
  tabPanel(title = "Bar Chart",
           fluidRow(column(5),column(7,
                                     actionButton(inputId = "bar",  label = "Generate Bar Chart"))),
           mainPanel(plotOutput("barchart"))
  ),
  
  tabPanel(title = "Histogram",
           fluidRow(column(3),column(5,sliderInput(inputId = "hist1", label = "Binsize",min = 0, max =5000 ,  value = 1000)),
           mainPanel(plotOutput("Histogram"))
  )
),
tabPanel(title = "Pie Chart",
         fluidRow(column(5),column(7,radioButtons("radio", label = h3("Slect the Measure"),
                                                choices = list("Count of Rank" = 1, "Market Value" = 2
                                                               ),selected = 1))),
         
         fluidRow(column(5),column(7,
                                   actionButton(inputId = "piechar",  label = "Generate Pie Chart")
         )),
         
         mainPanel(plotOutput("piechart")
                         )
)
)


