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
      labs(title='RANKS~Profits') +
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
  df3 <- data.frame(fromJSON(getURL(URLencode('skipper.cs.utexas.edu:5001/rest/native/?query="select * from TOPCOMPANY "'),httpheader=c(DB='jdbc:oracle:thin:@sayonara.microlab.cs.utexas.edu:1521:orcl', USER='C##cs329e_kc35827', PASS='orcl_kc35827', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE) ))
  df31 <-data.frame(fromJSON(getURL(URLencode('skipper.cs.utexas.edu:5001/rest/native/?query="select * from CONTINENT "'),httpheader=c(DB='jdbc:oracle:thin:@sayonara.microlab.cs.utexas.edu:1521:orcl', USER='C##cs329e_kc35827', PASS='orcl_kc35827', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE) ))
  output$crosstab <- renderPlot(height=1200, width=1200,{
    Low_Value = input$kpi1  
    Medium_Value = input$kpi2
    joined <-inner_join(df3,df31,by = c("COUNTRY" = "COUNTRYNAME"))
    a <- joined %>%select(INDUSTRY,CONTINENTNAME,RANK)%>%group_by(INDUSTRY,CONTINENTNAME)%>%summarise(n = n())
    a <- a %>% mutate(Count_of_Rank = ifelse(n < Low_Value, 'Low', ifelse(n < Medium_Value, 'Moderate', 'High')))
    plot3 <- ggplot() + 
      coord_cartesian() + 
      scale_y_discrete() +
      scale_x_discrete()+
      labs(title='CROSSTAB') +
      labs(x=paste("Industry"), y=paste("Continent")) +
      layer(data=a, 
            mapping=aes(x=INDUSTRY, y=CONTINENTNAME,fill=Count_of_Rank), 
            stat="identity", 
            stat_params=list(), 
            geom="tile",
            geom_params=list(alpha=0.50), 
            position=position_identity()
      )+coord_flip()+ layer(data=a, 
                            mapping=aes(x=INDUSTRY, y=CONTINENTNAME, label= n), 
                            stat="identity", 
                            stat_params=list(), 
                            geom="text",
                            geom_params=list(colour="black", vjust =0.5), 
                            position=position_identity()
      )
    
    
    
    
    plot3
  })
  df2 <- data.frame(fromJSON(getURL(URLencode('skipper.cs.utexas.edu:5001/rest/native/?query="select * from TOPCOMPANY "'),httpheader=c(DB='jdbc:oracle:thin:@sayonara.microlab.cs.utexas.edu:1521:orcl', USER='C##cs329e_kc35827', PASS='orcl_kc35827', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE) ))
  output$barchart <- renderPlot(height=1500, width=1200,{
    a <- df2 %>%select(INDUSTRY,RANK)%>%group_by(INDUSTRY)%>%summarise(n = n()/2008*100) %>% arrange(desc(n))
    a$INDUSTRY <-factor(a$INDUSTRY, levels =a$INDUSTRY[order(a$n)])
    plot2<-ggplot() + 
      coord_cartesian() + 
      scale_x_discrete() +
      scale_y_discrete() +
      labs(title='Rank~Industry') +
      labs(x=paste("Industry"), y=paste("% of Total #Rank")) +
      layer(data=a, 
            mapping=aes(x=INDUSTRY, y= n,color = n), 
            stat="identity", 
            stat_params=list(), 
            geom="bar",
            geom_params=list(colour="green"), 
            position=position_identity()
      )+coord_flip()+
      layer(data= a, 
            mapping=aes(x=INDUSTRY, y=n,label = paste(round(n,digits = 2),"%")), 
            stat="identity", 
            stat_params=list(), 
            geom="text",
            geom_params=list(colour="red", hjust=-1), 
            position=position_identity()
      )+layer(data=a, 
              mapping=aes(yintercept = 0.8), 
              geom="hline",
              geom_params=list(colour="red")
      ) 
    plot2
  })
  df4 <- data.frame(fromJSON(getURL(URLencode('skipper.cs.utexas.edu:5001/rest/native/?query="select * from TOPCOMPANY "'),httpheader=c(DB='jdbc:oracle:thin:@sayonara.microlab.cs.utexas.edu:1521:orcl', USER='C##cs329e_kc35827', PASS='orcl_kc35827', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE) ))
  output$Histogram<- renderPlot(height=600, width=1200,{
    plot4<-ggplot() + 
      coord_cartesian() + 
      scale_x_continuous() +
      scale_y_continuous()+
      labs(title='Company Profits') +
      labs(x="Profits", y=paste("FREQUENCY")) +
      layer(data=df4, 
            mapping=aes(x=PROFITS),
            stat="bin",
            stat_params=list(binwidth = input$hist1),
            geom="bar",
            geom_params=list(colour = "green",fill = "blue"),
            position=position_stack()
      )
    plot4
  })
  df5 <-eventReactive(input$piechar, {data.frame(fromJSON(getURL(URLencode('skipper.cs.utexas.edu:5001/rest/native/?query="select * from TOPCOMPANY "'),httpheader=c(DB='jdbc:oracle:thin:@sayonara.microlab.cs.utexas.edu:1521:orcl', USER='C##cs329e_kc35827', PASS='orcl_kc35827', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE) ))
  })
  output$piechart <- renderPlot(height=1800, width=1800,{
    if (input$radio == 1){
      c <-df5() %>%select(INDUSTRY,RANK)%>%group_by(INDUSTRY)%>%summarise(n = round((n()/2008*100), digits=2 ))%>%arrange(desc(n))
      crank1 <- c(c$n)
      lbls <- paste(c$INDUSTRY,c$n,sep="  ")
      lbls <- paste(lbls,"%")
      pie(crank1,labels = lbls, col=rainbow(length(crank1)),main="Pie Chart of Rank")
    }
    else{
      c <-df5() %>%select(INDUSTRY,MARKET_VALUE)%>%group_by(INDUSTRY)%>%summarise(n = sum(MARKET_VALUE))%>%arrange(desc(n))%>%mutate(pe = sum(n))
      crank1 <- c(c$n)
      crank2 <- slice(select(c,3),1)
      lbls <- paste(c$INDUSTRY,round(c$n /c(crank2$pe)*100, digits = 2),sep="  ")
      lbls <- paste(lbls,"%")
      pie(crank1,labels = lbls, col=rainbow(length(crank1)),main="Pie Chart of Market Value")
      
    }
   
   
    
    
  })
})


