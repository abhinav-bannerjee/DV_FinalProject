require("jsonlite")
require("RCurl")
require(ggplot2)
require(dplyr)
require(shiny)
require(shinydashboard)
require(leaflet)
shinyServer(function(input, output) {
 
  df1 <- eventReactive(input$scatter, {data.frame(fromJSON(getURL(URLencode('skipper.cs.utexas.edu:5001/rest/native/?query="select * from TOPCOMPANY "'),httpheader=c(DB='jdbc:oracle:thin:@sayonara.microlab.cs.utexas.edu:1521:orcl', USER='C##cs329e_kc35827', PASS='orcl_kc35827', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE) ))
  })
  output$scatterplot <- renderPlot(height=650, width=1200,{
    df <- df1()%>% arrange(desc(PROFITS))
    plot1 <-ggplot() + 
      scale_colour_gradientn(name = "Profits",colours = rainbow(15, start =0, end = 0.99))+
      coord_cartesian() + 
      scale_x_continuous() +
      scale_y_continuous() +
      labs(title='RANKS') +
      labs(x="Rank", y=paste("Profit")) +
      
      layer(data=df, 
            mapping=aes(x=RANK, y=PROFITS,color = as.numeric(PROFITS)),
            stat="identity", 
            stat_params=list(), 
            geom="point",
            geom_params=list(), 
            position=position_jitter(width=0.3, height=0)
      )+layer(data=slice(df, c(1:10, 20,30,50,80,100,150,200,250,350,450,433,
                                533,
                                633,
                                733,
                                833,
                                933,
                                1033,
                                1133,
                                1233,
                                1333,
                                1433,
                                1533,
                                1633,
                                1733,
                                1833,
                                1933,
                                2033,
                                2133, recursive = FALSE)), 
              mapping=aes(x=RANK, y=PROFITS,label=PROFITS), 
              stat="identity", 
              stat_params=list(), 
              geom="text",
              geom_params=list(colour="red", hjust=-0.3), 
              position=position_identity()
      )+
      stat_smooth(data = df,mapping = aes(x=RANK, y=PROFITS),geom = "smooth", position = "identity",method = "lm",formula= y~log(x))
    return(plot1)})
  #plot2
  output$crosstab <- renderPlot(height=600, width=1200,{
    Low_Value = input$kpi1  
    Medium_Value = input$kpi2
    
    df2<-data.frame(fromJSON(getURL(URLencode('skipper.cs.utexas.edu:5001/rest/native/?query="select * from FE1"'),httpheader=c(DB='jdbc:oracle:thin:@sayonara.microlab.cs.utexas.edu:1521:orcl', USER='C##cs329e_kc35827', PASS='orcl_kc35827', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE)))
    a <- df2  %>% select(TRANS_DESC,DRIVE_DESC,CARLINE,COMB_FE_GUIDE,FE_RATING_1_10)%>% group_by(TRANS_DESC,DRIVE_DESC) %>% summarise(comb_fe = round(mean(as.numeric(as.character(COMB_FE_GUIDE))),2),fe_rating = round(mean(as.numeric(as.character(FE_RATING_1_10))),digits=1))
    a<-na.omit(a)
    a <- a%>% mutate(Efficiency = ifelse(as.numeric(as.character(comb_fe)) < Low_Value, 'Not Efficient', ifelse(as.numeric(as.character(comb_fe)) < Medium_Value, 'Moderate', 'Energy-Efficient')))
    plot2 <- ggplot() + 
      coord_cartesian() + 
      scale_y_discrete() +
      scale_x_discrete(labels=c("Automated Manual","Automated Manual- Selectable","Automatic","Continuously Variable","Manual","Selectable Continuously Variable","Semi-Automatic") )+
      labs(title='CROSSTAB') +
      labs(x=paste("Transmission"), y=paste("Drive")) +
      layer(data=a, 
            mapping=aes(x=TRANS_DESC, y=DRIVE_DESC,fill=Efficiency), 
            stat="identity", 
            stat_params=list(), 
            geom="tile",
            geom_params=list(alpha=0.50), 
            position=position_identity()
      )+
      layer(data=a, 
            mapping=aes(x=TRANS_DESC, y=DRIVE_DESC, label= fe_rating), 
            stat="identity", 
            stat_params=list(), 
            geom="text",
            geom_params=list(colour="black", vjust =2), 
            position=position_identity()
      )+ 
      layer(data=a, 
            mapping=aes(x=TRANS_DESC, y=DRIVE_DESC, label= comb_fe), 
            stat="identity", 
            stat_params=list(), 
            geom="text",
            geom_params=list(colour="black", vjust =4), 
            position=position_identity()
      )
    
    plot2
  })
  #plot3
  df <-eventReactive(input$bar,{data.frame(fromJSON(getURL(URLencode('skipper.cs.utexas.edu:5001/rest/native/?query="select * from FE1"'),httpheader=c(DB='jdbc:oracle:thin:@sayonara.microlab.cs.utexas.edu:1521:orcl', USER='C##cs329e_kc35827', PASS='orcl_kc35827', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE) ))})
  output$barchart <- renderPlot(height=1500, width=2500,{
    
    COMB_FE_ <- df()%>% select(COMB_FE_GUIDE)
    COMB_FE_[COMB_FE_=="null"] <- NA
    COMB_FE_ <- na.omit(COMB_FE_)
    COMB_FE_$COMB_FE_GUIDE <- as.numeric(as.character(COMB_FE_$COMB_FE_GUIDE))
    plot3 <- ggplot() + 
      coord_cartesian() + 
      scale_x_discrete(labels=c("Automated Manual","Automated Manual- Selectable","Automatic","Continuously Variable","Manual","Selectable Continuously Variable","Semi-Automatic") ) +
      scale_y_discrete() +
      facet_wrap(~DIVISION, ncol=6) +
      labs(title='Fuel Economy per Division  ') +
      labs(x=paste("DIVISION"), y=paste("COMB FE GUIDE")) +
      layer(data=COMB_FE_, 
            mapping=aes(yintercept = 12.230), 
            geom="hline",
            geom_params=list(colour="red")
      ) +
      layer(data=df(), 
            mapping=aes(x=TRANS_DESC, y=COMB_FE_GUIDE), 
            stat="identity", 
            stat_params=list(), 
            geom="bar",
            geom_params=list(colour="green"), 
            position=position_identity()
      ) + coord_flip() +
      layer(data=df(), 
            mapping=aes(x=TRANS_DESC, y=(COMB_FE_GUIDE), label=(COMB_FE_GUIDE)), 
            stat="identity", 
            stat_params=list(), 
            geom="text",
            geom_params=list(colour="red", hjust=-0.5), 
            position=position_identity()
      )
    plot3
  })
  
  df1 <- eventReactive(input$hist, {data.frame(fromJSON(getURL(URLencode('skipper.cs.utexas.edu:5001/rest/native/?query="select * from TOPCOMPANY "'),httpheader=c(DB='jdbc:oracle:thin:@sayonara.microlab.cs.utexas.edu:1521:orcl', USER='C##cs329e_kc35827', PASS='orcl_kc35827', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE) ))
  })
  output$Histogram<- renderPlot(height = 650, width = 1200,{
    plot4<-ggplot() + 
      coord_cartesian() + 
      scale_x_continuous() +
      scale_y_continuous()+
      labs(title='Company Profits') +
      labs(x="Profits", y=paste("FREQUENCY")) +
      layer(data=df1(), 
            mapping=aes(x=PROFITS),
            stat="bin",
            stat_params=list(binwidth = 1000),
            geom="bar",
            geom_params=list(colour = "green",fill = "blue"),
            position=position_stack()
      )
    plot4
  })
  
})

