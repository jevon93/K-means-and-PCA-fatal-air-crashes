library(factoextra) ##for fviz_cluster
library(class) ## for knn
library(gridExtra) ##for visualisation
library(ggplot2) ##for visualisation
library(fivethirtyeight) ## for airline data

##First of all we read the airlines data from the package fivethirtyeight and omit any NA observations
##This data contains informations on airline safety from 1985-1989 for the 56 largest airline companies 

airlines<-airline_safety
airlines<- na.omit(airlines)


##A few exploratory plots

plot(log(avail_seat_km_per_week) ~ incidents_85_99)
plot(log(avail_seat_km_per_week) ~ fatal_accidents_85_99)
plot(log(avail_seat_km_per_week) ~ incidents_00_14)
plot(log(avail_seat_km_per_week) ~ fatal_accidents_00_14)


##Since all airlines are different sizes, we standardize the variable seatkmperweek so that the average
##is one and transform all variable by their standardized coefficient.


airlines$seatkmperweekstd<-airlines$avail_seat_km_per_week/mean(airlines$avail_seat_km_per_week)


airlines$incidents_85_99 <- airlines$incidents_85_99 * airlines$seatkmperweekstd
airlines$fatal_accidents_85_99 <- airlines$fatal_accidents_85_99 * airlines$seatkmperweekstd
airlines$fatalities_85_99 <- airlines$fatalities_85_99 * airlines$seatkmperweekstd
airlines$incidents_00_14 <- airlines$incidents_00_14 * airlines$seatkmperweekstd
airlines$fatalities_00_14 <- airlines$fatalities_00_14 * airlines$seatkmperweekstd
airlines$fatal_accidents_00_14 <- airlines$fatal_accidents_00_14 * airlines$seatkmperweekstd



##Now we can take a look at our data and attempt to cluster it

km.out <- kmeans(airlines[,c(2,3,4,5,6,7,8)], 3, nstart = 50)
table(fatal_accidents_00_14, km.out$cluster)
table(fatalities_00_14, km.out$cluster)
table(incidents_00_14, km.out$cluster)
km.out



##As we can see three clusters explains the majority of our data. However we may want to check other
##possible values of n

k2 <- kmeans(airlines[,c(-1,-2,-3,-10)], centers = 2, nstart = 25)
k3 <- kmeans(airlines[,c(-1,-2,-3,-10)], centers = 3, nstart = 25)
k4 <- kmeans(airlines[,c(-1,-2,-3,-10)], centers = 4, nstart = 25)
k5 <- kmeans(airlines[,c(-1,-2,-3,-10)], centers = 5, nstart = 25)

# plots to compare
p1 <- fviz_cluster(k2, geom = "point", data = airlines[,c(-1,-2,-3,-10)]) + ggtitle("k = 2")
p2 <- fviz_cluster(k3, geom = "point",  data = airlines[,c(-1,-2,-3,-10)]) + ggtitle("k = 3")
p3 <- fviz_cluster(k4, geom = "point",  data = airlines[,c(-1,-2,-3,-10)]) + ggtitle("k = 4")
p4 <- fviz_cluster(k5, geom = "point",  data = airlines[,c(-1,-2,-3,-10)]) + ggtitle("k = 5")

#View plots
grid.arrange(p1, p2, p3, p4, nrow = 2)

##It looks like 5 distinct clusters can be seen. Lets take a closer look
k5


##These 5 groups account for 95.5% of the data sets total variation. Outlier Groups include clusers 2,4 and 5.
##The name of these airlines are Air Malaysia, Air France, United/Continental and Delta/Northwest as well as Aeroflot


##Add clusters as a variable and visualise them all by name by ggplot
airlines$cluster <- k5$cluster
g1<-ggplot(airlines, aes(incidents_00_14, fatalities_00_14, color = factor(airlines$cluster), label = airline)) +
  geom_text()
g2<-ggplot(airlines, aes(incidents_85_99, fatalities_85_99, color = factor(airlines$cluster), label = airline)) +
  geom_text()
g3<-ggplot(airlines, aes(fatal_accidents_85_99, fatal_accidents_00_14, color = factor(airlines$cluster), label = airline)) +
  geom_text()
g4<-ggplot(airlines, aes(fatal_accidents_00_14, fatalities_00_14, color = factor(airlines$cluster), label = airline)) +
  geom_text()

grid.arrange(g1, g2, g3, g4, nrow = 2)

##We can see by these plots that these same bad actor airlines are all high in some respect to fatalities,
##accidents and incidents.