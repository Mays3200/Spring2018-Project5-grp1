# Read data
top20<- read.csv('../data/top20.csv')
# Library Packages
library(pltly)
# Change colors
colnames(top20)[6]<-"profile"
colnames(top20)[4]<-"retweet_count"
# Plot Picture
p <- plot_ly(
  data = top20,
  x = ~retweet_count,
  y = ~retweet_status_user_name,
  text= ~ paste('Profile:',profile),
  name = "Top 20",
  type = "bar",
  hoverinfo='x+y+text',
  orientation = 'h',
  color = ~attitude,
  colors = c("#1F77B4","#DDDDDD","#FF7F0E")
)%>%layout(yaxis = xform)
p