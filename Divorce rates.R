### Test script ###

## Divorce rates! ##
####################
rm(list=ls())
library(readxl)

##Read in data
url<-"https://www.ons.gov.uk/file?uri=/peoplepopulationandcommunity/birthsdeathsandmarriages/divorce/datasets/divorcesinenglandandwales/2023/divorcesworkbook2023final.xlsx"

temp_file <- tempfile(fileext = ".xlsx")
download.file(url, temp_file, mode = "wb")
divorced_by_anniverasy <- read_excel(temp_file, sheet = "6a", range = "A11:BJ71")
divorced_by_anniverasy[,3:62]<-divorced_by_anniverasy[,3:62]/100 #Need to divide by 100 to get %s

colnames(divorced_by_anniverasy)[3:62]<-col_names<-paste("Year", 1:60)

##Plot % of marriages ending in divorce by Year 5
divorced_by_anniverasy$Year<-1963:2022

library(ggplot2)
myplot<-ggplot(divorced_by_anniverasy, aes(x = Year, y = `Year 5`))+
  geom_line()+
  labs(title="Proportion of marriages ending in divorce by the fifth anniversary",
       x="Year of marriage",
       y = "Proportion divorced")+
  theme_minimal()
myplot

jpeg(file = "reports/5yeardivorcerates.jpeg")
print(myplot)
jpeg(file = "5yeardivorcerates.jpeg")
print(myplot)
jpeg(file = "git_reports/5yeardivorcerates.jpeg")
print(myplot)
dev.off()

##Generate number of divorces per year

divorces_per_year<-data.frame(matrix(ncol = 61, nrow= 60))
colnames(divorces_per_year)<-col_names<-c("Year of marriage", paste("Year", 1:60))
divorces_per_year$`Year of marriage`<-divorced_by_anniverasy$`Year of marriage`
divorces_per_year[,2]<-divorced_by_anniverasy$`Number of marriages`*(divorced_by_anniverasy[,3])
for(i in 3:61) {
  divorces_per_year[,i]<-divorced_by_anniverasy$`Number of marriages`*(divorced_by_anniverasy[,i+1]-divorced_by_anniverasy[,i])
}

##Generate surviving marriages
surviving_marriages<-data.frame(matrix(ncol = 61, nrow= 60))
colnames(surviving_marriages)<-col_names<-c("Year of marriage", paste("Year", 1:60))
surviving_marriages[,1:2]<-divorced_by_anniverasy[,1:2]
for(i in 3:61) {
  surviving_marriages[,i]<-divorced_by_anniverasy$`Number of marriages`*(1-divorced_by_anniverasy[,i+1])
}
##Generate divorce rates

