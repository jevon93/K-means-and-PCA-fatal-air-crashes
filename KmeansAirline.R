library(factoextra) ##for fviz_cluster
library(class) ## for k means
library(gridExtra) ##for visualisation
library(ggplot2) ##for visualisation
library(fivethirtyeight) ## for airline data

##First of all we read the airlines data from the package fivethirtyeight and omit any NA observations
##This data contains informations on airline safety from 1985-2014 for the 56 largest airline companies 

airlines<-airline_safety
airlines<- na.omit(airlines)


##A pairs plot of all features to explore. We can see a few consistent outliers and a (possibly) linear relationship between variables

pairs(airlines[,2:8])


##Since all airlines transport different numbers of people varying amounts of distances in total, we standardize all features by 
##seatkmperweek, which contains the # of people * distance in km travelled.


airlines$seatkmperweekstd<-airlines$avail_seat_km_per_week/mean(airlines$avail_seat_km_per_week)

airlines$incidents_85_99 <- airlines$incidents_85_99 * airlines$seatkmperweekstd
airlines$fatal_accidents_85_99 <- airlines$fatal_accidents_85_99 * airlines$seatkmperweekstd
airlines$fatalities_85_99 <- airlines$fatalities_85_99 * airlines$seatkmperweekstd
airlines$incidents_00_14 <- airlines$incidents_00_14 * airlines$seatkmperweekstd
airlines$fatalities_00_14 <- airlines$fatalities_00_14 * airlines$seatkmperweekstd
airlines$fatal_accidents_00_14 <- airlines$fatal_accidents_00_14 * airlines$seatkmperweekstd



##Now we can take a look at our data and attempt to cluster it
##We only need columns 2-8 for this since these are our features

km.out <- kmeans(airlines[,c(2,3,4,5,6,7,8)], 3, nstart = 50)
table(fatal_accidents_00_14, km.out$cluster)
table(fatalities_00_14, km.out$cluster)
table(incidents_00_14, km.out$cluster)
km.out



##As we can see from output three clusters explains 85% of our data. However we want to check other values of n

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

##It looks like 5 distinct clusters explain this data well. Lets take a closer look.
k5


##These 5 groups account for 95.5% of the data sets total variation. Outlier Groups include clusers 2,4 and 5.
##The name of these airlines are Air Malaysia, Air France, United/Continental and Delta/Northwest as well as Aeroflot


##There are a few main distinctions between these groups, however groups 2, 4, and 5 have all had a high number of fatalities
##due to accidents at some point.


##Add clusters as a variable and visualise names with ggplot

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

##As we saw from our cluster k5 before, 2 of our features accounted for the vast majority of variance in this data


##Now we can apply principal component analysis to find out which of these variables account for most of the
## variability in our data. We dont need columns 1,2,3 or 10

ir.pca <- prcomp(airlines[,c(-1,-2,-3,-10)],
                 center = TRUE,
                 scale. = TRUE)

print(ir.pca)

plot(ir.pca, type = "l")


##As we can see from our results and the plot above, two variables - fatalities_00_14 and fatalities_85_99
##account for a whopping 95% of the variance in our data 


##Incidents and airline accidents can both be predicted by the number of fatalities an airline has had

##The plot below visualises the relationships between Principal Component 1, 2 with all features

theta <- seq(0,2*pi,length.out = 100)
circle <- data.frame(x = cos(theta), y = sin(theta))
p <- ggplot(circle,aes(x,y)) + geom_path()

loadings <- data.frame(ir.pca$rotation, 
                       .names = row.names(ir.pca$rotation))
p + geom_text(data=loadings, 
              mapping=aes(x = PC1, y = PC2, label = .names, colour = .names)) +
  coord_fixed(ratio=1) +
  labs(x = "PC1", y = "PC2")

##This type of analysis can be applied to all types of quantitative data. Outcomes may vary
##A section which utilises the 85-99 as training data to predict the 00-14  "test" data via k-means will be added soon
