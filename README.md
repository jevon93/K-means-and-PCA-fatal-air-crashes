# KmeansAirline
K-Means Cluster Analysis of Airlines Data using R


This file uses data from the R package fivethirtyeight on airline accidents, incidents, and fatalities for 57 of the worlds largest airliners over the last 25 years.

We demonstrate the use of a k-means cluster analysis for identifying distinct groups of airlines and use principal component analysis
in order to find our most important features for cluster prediction.

Depending on what we set n to we can see distinct groups of bad aircraft accident and fatality rates across a number of
modern airline companies. Using fviz_cluster and gg_plot we can visualise these clusters and see it for ourselves.

It is apparent from the analysis of this data that most airlines which had bad accident rates in the 1985-1999 period
continued to have high accident and fatality rates relevant to other airlines in the following years. And that
specific clusters of airlines are consistent outliers.

We also use principal component analysis to find the most important features in a data set. Both sets of fatalities features account for a whopping 95% of overall variability in our data.

This type of cluster analysis can be used on any type of quantitative data. It is very useful for classifying distinct groups
and informing decisions. For instance, we would not reccomend flying or investing in Malaysian Airlines, Air France, United/Continental
or Delta/Northwest.

K-Means analysis is a powerful clustering method that is suited for most types of classification problems. And principal component
analysis can tell us what the most important features are in order to predict future clusters.

For qualitative or binary outcomes, K-nn clustering can be used to similar effect.
