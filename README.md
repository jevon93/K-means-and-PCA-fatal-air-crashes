# KmeansAirline
K-Means Cluster Analysis of Airlines Data using R


This file uses data from the R package fivethirtyeight on airline accidents over the years of 1985-2014.
We demonstrate the use of a k-means cluster analysis for identifying distinct classes of airlines.

Depending on if n=3, 4, or 5 we can see distinct groups of bad aircraft accident and fatality rates across a number of
modern airline companies. Using fviz_cluster and gg_plot we can visualise these clusters and make the necessary
judgements we need to make.

It is apparent from the analysis of this data that most airlines which had bad accident rates in the 1985-1999 period
continued to have high accident and fatality rates relevant to other airlines in the following years. And that
specific groups of airlines seem to be consistent outliers.

This type of cluster analysis could be used on any type of qualitative data. It is very useful for classifying distinct groups
and informing decisions. For instance, we would not reccomend flying or investing in Malaysian Airlines, Air France, United/Continental
or Delta/Northwest. 

K-Means analysis is a powerful clustering method that is suited for most types of classification problems.
