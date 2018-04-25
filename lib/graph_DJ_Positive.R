library(plotly)
library(dplyr)

DJ <- read.csv("../data/DJIA.csv", stringsAsFactors = F)
datalong <- read.csv("../data/datalong.csv", stringsAsFactors = F)[, -1]

DJ <- DJ[!DJ$DJIA == ".", ]

colnames(datalong) <- c("Date", "Attitude", "Proportion")
DJ$DJIA <- as.numeric(DJ$DJIA)
DJ$Date <- as.Date(DJ$Date, "%m/%d/%Y")
datalong$Date <- as.Date(datalong$Date, "%Y/%m/%d")

df <- inner_join(datalong, DJ, by = "Date")
df.positive <- df[df$Attitude == "positive", ]

df.positive$Date <- as.character(df.positive$Date)
df.positive$Date <- substring(df.positive$Date, 6, 10)
df.positive$Date <- gsub("-", "/", df.positive$Date)

ay <- list(
  tickfont = list(color = "red"),
  overlaying = "y",
  side = "right",
  title = "Dow Jones Industrial Average"
)


p <- plot_ly(data = df.positive) %>%
  add_lines(x = ~Date, y = ~DJIA, name = "DJIA", yaxis = "y2") %>%
  add_bars(x = ~Date, y = ~Proportion, name = "Pos Proportion") %>%
  layout(
    title = "Proportion and DJIA",  
    yaxis = list(title = "Positive Proportion"),
    yaxis2 = ay,
    xaxis = list(title = "Date", tickangle = -30)
  )

p