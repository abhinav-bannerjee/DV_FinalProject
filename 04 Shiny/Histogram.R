#a <- df1 %>%select(Industry,Rank)%>%group_by(Industry)%>%summarise(n = n()/2008*100)
ggplot() + 
  
  coord_cartesian() + 
  scale_x_continuous() +
  scale_y_continuous()+
  labs(title='Online Credit Card Fraud') +
  labs(x="Profits", y=paste("FREQUENCY")) +
  layer(data=df1, 
        mapping=aes(x=PROFITS),
        stat="bin",
        stat_params=list(binwidth = 1000),
        geom="bar",
        geom_params=list(colour = "green",fill = "blue"),
        position=position_stack()
  )
