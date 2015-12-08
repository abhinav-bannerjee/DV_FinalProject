df <- df%>% arrange(desc(Profits))
ggplot() + 
  scale_colour_gradientn(name = "Profits",colours = rainbow(15, start =0, end = 0.99))+
  coord_cartesian() + 
  scale_x_continuous() +
  scale_y_continuous() +
  labs(title='RANKS') +
  labs(x="Rank", y=paste("Profit")) +

  layer(data=df, 
        mapping=aes(x=Rank, y=Profits,color = as.numeric(Profits)),
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
                           2133)), 
          mapping=aes(x=Rank, y=Profits,label=Profits), 
          stat="identity", 
          stat_params=list(), 
          geom="text",
          geom_params=list(colour="red", hjust=-0.3), 
          position=position_identity()
  )+
  stat_smooth(data = df,mapping = aes(x=Rank, y=Profits),geom = "smooth", position = "identity",method = "lm",formula= y~log(x))
                
