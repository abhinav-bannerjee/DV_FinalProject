a <- df %>%select(Industry,Rank)%>%group_by(Industry)%>%summarise(n = n()/2008*100)
ggplot() + 
  coord_cartesian() + 
  scale_x_discrete() +
  scale_y_discrete() +
  labs(title='Rank~Industry') +
  labs(x=paste("Industry"), y=paste("% of Total #Rank")) +
  layer(data=a, 
        mapping=aes(x=Industry, y=n,color = n), 
        stat="identity", 
        stat_params=list(), 
        geom="bar",
        geom_params=list(colour="green"), 
        position=position_identity()
  )+coord_flip()+
  layer(data=a, 
        mapping=aes(x=Industry, y=n,label = round(n,digits = 2)), 
        stat="identity", 
        stat_params=list(), 
        geom="text",
        geom_params=list(colour="red", hjust=-0.5), 
        position=position_identity()
  )
