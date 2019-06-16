# Interactive Crime Map in Vancouver

By studying historic crime data, we can analyze the crime trend to identify people and locations at increased risk of crime, and allocate police to patrol at appropriate locations prior to crime happening.

In this project, an interactive crime map was developed to study crime activities at different neighborhoods. The data is dynamic and is automatically updated when [Vancouver Police Department](http://data.vancouver.ca/datacatalogue/crime-data.htm) updates their data.


## Link to the interactive map

Link: https://lavinialau.shinyapps.io/crimestatistics/


## How to read the map?

The interactive crime map was developed for the public to observe the crime trend in different time. Users can zoom in the map or mouse over the map to see the crime details.

For example, from October 1-13, 2017, crime mainly happened in downtown, which is indicated in red. If a place is indicated in yellow, it means the crime is less likely to happen. And green means crime is least likely to happen. (Figure 1)

<I>Figure 1: Vancouver Crime Map (October 1-13, 2017) </I>
![Image of crime map](https://github.com/Lavinialau/Vancouver-Crime-Map/blob/master/graphics/Figure%201%20Map%20indicator.jpg)

You can also see certain spot have higher crime rate than others. For example, Figure 2 shows that totally 15 criminal events were recorded at around 322 Abbott Street from October 1-13, 2017, and most of them are theft. (So it may be a good idea not to leave your personal belongings like bicycles there!)

<I>Figure 2: Crime recorded at 322 Abbott Street from October 1-13, 2017 </I>
![Image of one spot](https://github.com/Lavinialau/Vancouver-Crime-Map/blob/master/graphics/Figure%202%20Crime%20at%20Abbott%20Street.png)


## Crime Trend
Other than the interactive crime map, I have also developed a series of charts to observe the crime trend.

From 2003 to 2017, the number of daily crime has decreased by around 30% (see Figure 3). You can check the crime trend across years, months and hours using the interactive graphs under the “Crime Statistics” tab. By studying crime data in 2017 (Figure 4), the five most frequently happened crime types are Theft from Vehicle (32.6% of all crime), Mischief (13.2% of all crime), Break and Enter Residential/Other (11.4%), Offence Against a Person (10.2%), and Other Theft (9.9%). These five crime types make up nearly 80% of crime happening in Vancouver.

<I>Figure 3: Total Daily Crime against Date (from 2013 to October 13, 2017)</I>
![Crime against time](https://github.com/Lavinialau/Vancouver-Crime-Map/blob/master/graphics/Figure%203%20Total%20Daily%20Crime%20Against%20Date.jpeg)

<I>Figure 4: Crime Type Distribution in 2017</I>
![Crime type distribution](https://github.com/Lavinialau/Vancouver-Crime-Map/blob/master/graphics/Figure%204%20Crime%20Type%20Distribution%202017.jpeg)

Let’s further probe into crime type across years, months, and hours. Despite decreasing daily crime, some crime types are getting worse in recent years. In 2016, there are more theft happening, including Theft from Vehicle, Theft of Bicycle, Theft of Vehicle and Other Theft (Figure 5) comparing to 2015. As for monthly trend, there is not obvious trend except more bicycles are stolen in summer time (Figure 6). A higher crime rate is also expected from afternoon to evening, and some crime has its unique hourly pattern (Figure 7).

<I>Figure 5:Crime type trend across year (2003-2014)</I>
![yearly crime trend](https://github.com/Lavinialau/Vancouver-Crime-Map/blob/master/graphics/Figure%205%20Crime%20Type%20Trend%20Across%20Year.jpeg)

<I>Figure 6:Crime type trend across month (2015-2016)</I>
![monthly crime trend](https://github.com/Lavinialau/Vancouver-Crime-Map/blob/master/graphics/Figure%206%20Crime%20Type%20Trend%20Across%20Month.jpeg)

<I>Figure 7:Crime type across hour (2017)</I>
![hourly crime trend](https://github.com/Lavinialau/Vancouver-Crime-Map/blob/master/graphics/Figure%207%20Crime%20Type%20Across%20Hour.jpeg)


I hope this interactive crime map will serve as an useful tool for public to visualize the crime activities data for better understanding of their neigbourhood.

## R code
R code can be found here: https://github.com/Lavinialau/Vancouver-Crime-Map/tree/master/R


## License
Developed by Lavinia Lau @2017


