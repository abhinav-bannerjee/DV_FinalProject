#ui.R 

library(shiny)

navbarPage(
  title = "Visualization",
  tabPanel(title = "Scatter Plot",
           fluidRow(column(5),column(7,
                                     actionButton(inputId = "scatter",  label = "Generate Scatter Plot")
           )),
           
           fluidRow(column(1,offset = 1,
                           mainPanel(plotOutput("scatterplot")
                           )))
  ),
  tabPanel(title = "Crosstab",
           fluidRow(column(2),column(5,sliderInput(inputId = "kpi1", label = "Low_value",min = 12, max = 44,  value = 20)),
                    column(5,sliderInput(inputId = "kpi2", label = "Medium_value",min = 12, max = 44,  value = 31))),
           mainPanel(plotOutput("crosstab"))
  ),
  tabPanel(title = "Bar Chart",
           fluidRow(column(5),column(7,
                                     actionButton(inputId = "bar",  label = "Generate Bar Chart"))),
           mainPanel(plotOutput("barchart"))
  ),
  
  tabPanel(title = "Histogram",
           fluidRow(column(2),column(5,sliderInput(inputId = "hist", label = "Low_value",min = 12, max = 44,  value = 20)),
                    column(5,sliderInput(inputId = "hist2", label = "Medium_value",min = 12, max = 44,  value = 31))),
           mainPanel(plotOutput("Histogram"))
  )
)


