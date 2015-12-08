require(dplyr)
Low_Value = 5
Medium_Value = 20
df3 <-inner_join(df,df2,by = c("Country" = "COUNTRYNAME"))
a <- df3 %>%select(Industry,CONTINENTNAME,Rank)%>%group_by(Industry,CONTINENTNAME)%>%summarise(n = n())
a <- a %>% mutate(Count_of_Rank = ifelse(n < Low_Value, 'Low', ifelse(n < Medium_Value, 'Moderate', 'High')))
  ggplot() + 
  coord_cartesian() + 
  scale_y_discrete() +
  scale_x_discrete()+
  labs(title='CROSSTAB') +
  labs(x=paste("Industry"), y=paste("Continent")) +
  layer(data=a, 
        mapping=aes(x=Industry, y=CONTINENTNAME,fill=Count_of_Rank), 
        stat="identity", 
        stat_params=list(), 
        geom="tile",
        geom_params=list(alpha=0.50), 
        position=position_identity()
  )+coord_flip()+ layer(data=a, 
                        mapping=aes(x=Industry, y=CONTINENTNAME, label= n), 
                        stat="identity", 
                        stat_params=list(), 
                        geom="text",
                        geom_params=list(colour="black", vjust =0.5), 
                        position=position_identity()
  )
    
