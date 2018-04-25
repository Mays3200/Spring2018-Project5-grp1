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


##### Attitude visualization
## plot theme
plotTheme <- function(base_size = 12) {
  theme(
    text = element_text( color = "black"),
    plot.title = element_text(size = 10,colour = "black",hjust=0.5),
    plot.subtitle = element_text(face="italic"),
    plot.caption = element_text(hjust=0),
    axis.ticks = element_blank(),
    panel.background = element_blank(),
    panel.grid.major = element_line("grey80", size = 0.1),
    panel.grid.minor = element_blank(),
    strip.background = element_rect(fill = "grey80", color = "white"),
    strip.text = element_text(size=8),
    axis.title = element_text(size=5),
    axis.text = element_text(size=5),
    axis.title.x = element_text(hjust=3),
    axis.title.y = element_text(hjust=3),
    plot.background = element_blank(),
    legend.background = element_blank(),
    legend.title = element_text(colour = "black"),
    legend.text = element_text(colour = "black"))
}

## Vader neg/neu/pos
data <- read.csv("/Users/mengqichen/Desktop/data_with_vadersentiment.csv", header = T, stringsAsFactors = F)
head(data)
# subsplit created_at into date and time 
Time <- data$created_at
data$date <- format(as.POSIXct(strptime(Time, "%Y-%m-%d %H:%M", tz="")), format = "%Y/%m/%d")

#length(d1[d1<=-0.05])/length(d1)
#length(d1[d1<0.05&d1>-0.05])/length(d1)
#length(d1[d1>=0.05])/length(d1)

attitude <- matrix(NA, length(unique(data$date)), 3)
d <- c()
for (i in 1:length(unique(data$date))) {
  d <-  data$compound[data$date==unique(data$date)[i]]
  l <- length(d)
  attitude[i,1] <-  length(d[d<=-0.05])/l
  attitude[i,2] <-  length(d[d<0.05&d>-0.05])/l
  attitude[i,3] <-  length(d[d>=0.05])/l
}
attitude <- as.data.frame(attitude)
attitude$date <- unique(data$date)
colnames(attitude) <- c("neg","neu","pos", "date")
rownames(attitude) <- unique(data$date)

library(ggplot2)
library(reshape2)
datalong <- melt(attitude, id.vars = c("date"), value.name = "proportion")
names(datalong)[2] <- "attitude"
p <- ggplot(data = datalong)+geom_bar(aes(x=date, y=proportion, fill= attitude), stat = "identity")+plotTheme()+coord_flip()+scale_fill_manual(values=c("#56B4E9", "gainsboro", "coral1"))
# library(plotly)
# p1 <- ggplotly(p)

## LSTM support or not support

l <- read.csv("model_of_LSTM.csv")
l$date <-format(as.POSIXct(strptime(l$created_at, "%Y-%m-%d %H:%M", tz="")), format = "%Y/%m/%d")
attitude1 <- matrix(NA, 15, 2)
d1 <- c()
for (i in 1:length(unique(l$date))) {
  d1<- l$support_or_not[l$date==unique(l$date)[i]]
  l1 <- length(d1)
  attitude1[i,1] <- length(d1[d1==0])/l1
  attitude1[i,2] <- length(d1[d1==1])/l1
}
attitude1 <- as.data.frame(attitude1)
attitude1$date <- unique(l$date)
colnames(attitude1) <- c("not support","support", "date")
datalong1 <- melt(attitude1, id.vars = c("date"), value.name = "proportion")
names(datalong1)[2] <- "attitude"
p1 <- ggplot(data = datalong1)+geom_bar(aes(x=date, y=proportion, fill= attitude), stat = "identity")+plotTheme()+coord_flip()+scale_fill_manual(values=c("#56B4E9","coral1"))


### The most active users in this topic ###
### (we did not put in the final version since it does not make much sense)
users <- table(data$user_id)
user_active_100 <- head(sort(users, decreasing = T), 100)
user_active_100 <- as.data.frame(user_active_100)
names(user_active_100) <- c('user', "times")


active_user <- c() 
for (i in 1:100) {
  active_user[i] <- head(data$user_name[data$user_id==user_active_100$user[i]],1)
}

active_user_info <-data[active_user, ]


