# Rent Too High - CSE 442

Authors: [Drew King](https://www.github.com/andrewpking/), [Dan Sutton](https://github.com/suttodan), [Joey Kreuger](https://github.com/jkru3), [Jack Rosenbloom](https://github.com/jackcodesstuff)

## Dataset

- [Personal Income Data from Bureau of Economic Analysis](https://apps.bea.gov/regional/histdata/releases/1122lapi/CAINC1.zip)
- [Zillow Rent Index (ZORI) for all homes from Zillow](https://www.zillow.com/research/data/)

## Problem

### Skewed Data

The rent is too high. In fact it is so high that Zillow changed their index from the [ZRI](https://www.zillow.com/research/zillow-rent-index-methodology-2393/) to [ZORI, which only captures the average from the 35th to 65th percentile](https://www.zillow.com/research/methodology-zori-repeat-rent-27092/#:~:text=Beginning%20in%20May%202020%20with%20publication%20of,that%20other%20measures%20of%20rental%20prices%20cannot.) of rents. This new methodology generally skews below the true average rent. It is likely they have a vested interest in hiding the real cost of housing. Despite this limitation, a brief analysis using R and creating a tableau dashboard has shown that rents are outpacing wages as a proportion in most areas.

### Social Costs

If someone is spending more than 30% of their income on rent they are considered [rent burdened](https://www.huduser.gov/portal/pdredge/pdr_edge_featd_article_092214.html). The number of places where people are rent burdened is rising, with [nearly 50% of households being rent burdened in 2023](https://www.census.gov/newsroom/press-releases/2024/renter-households-cost-burdened-race.html#:~:text=September%2012%2C%202024-,Nearly%20Half%20of%20Renter%20Households%20Are,Burdened%2C%20Proportions%20Differ%20by%20Race&text=SEPT.,whom%20rent%20burden%20is%20calculated.). This project seeks to highlight the inequity of the housing market that is fueling the cost of living crisis in the United States.

## Proposed Solution

An interactive data visualization written in Vega-Lite that allows people to explore the rising costs of rent over time, with data that is adjusted for wages.

### Data Cleaning and Data Taxonomy

Drew found data in non-normal forms. They are familiar with R so they wrote an [R script](https://github.com/andrewpking/a3-rent-too-high/blob/master/data/Data%20Cleaning%20Rent.R) that pivots and joins two tables:

- Incomes by county over time: [CAINC1__ALL_AREAS_1969_2021.csv](https://github.com/andrewpking/a3-rent-too-high/blob/master/data/CAINC1__ALL_AREAS_1969_2021.csv)
- Rents by region over time: [city_zori_all_homes.csv](https://github.com/andrewpking/a3-rent-too-high/blob/master/data/city_zori_all_homes.csv)

This script then calculates:

- The average rent for each county.
- The proportion of income per capita for each county spent on rent.
- Rent increase year over year as a number.
- Rent increases year over year as a percent.

It is worth noting that some data was lost when merging the two tables, but in order to normalize rent to income for an area, it was required to drop some areas. You can check out the resulting table: [rent_and_income.csv](https://github.com/andrewpking/a3-rent-too-high/blob/master/data/rent_and_income.csv)

### Prototyping

An [interactive prototype](https://public.tableau.com/views/A3-TheRentIsTooHigh/TheRentisTooHigh-FromZORIDataset?:language=en-US&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link) has been created with Tableau dashboards visualizing the proportion of income spent on rent by county. Supported interactions include:

- Filter by state
- Tooltip with detailed stats
- Color encoding to indicate which counties are rent burdened.
- A bar graph with each county to show more granular detail of which is the least affordable.

### Development Roadmap

Some features that would be nice to support in the vega-lite version of this visualization would be:

- Filter on a map by region with a dragging interaction
- Tooltip with detailed stats.
- Bar graph to show more detailed stats.
- Choose which statistic to visualize with a menu.

We look forward to sharing the results of our labor!
