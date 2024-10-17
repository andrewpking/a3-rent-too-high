# Rent Too High - CSE 442

Authors: [Drew King](https://www.github.com/andrewpking/), [Dan Sutton](https://github.com/suttodan), [Joey Kreuger](https://github.com/jkru3), [Jack Rosenbloom](https://github.com/jackcodesstuff)

## Dataset

- [Personal Income Data from Bureau of Economic Analysis](https://apps.bea.gov/regional/histdata/releases/1122lapi/CAINC1.zip)
- [Zillow Rent Index (ZORI) for all homes from Zillow](https://www.zillow.com/research/data/)

## Problem

The rent is too high. In fact it is so high that ZORI data only captures the average from the 35th to 65th percentile of rents, so it generally skews down from the true average rent. It is likely they have a vested interest in hiding the true average rent. Despite this limitation, a brief analysis using R and creating a tableau dashboard has shown that rents are outpacing wages as a proportion in most areas.

## Proposed Solution

An interactive data visualization written in Vega-Lite that allows people to explore the rising costs of rent over time, with data that is adjusted for wages.

### Data Cleaning and Data Taxonomy

Drew found data in non-normal forms. They are familiar with R so they wrote an [R script](https://github.com/andrewpking/a3-rent-too-high/blob/master/Data%20Cleaning%20Rent.R) that pivots and joins two tables:

- Incomes by county over time: [CAINC1__ALL_AREAS_1969_2021.csv](https://github.com/andrewpking/a3-rent-too-high/blob/master/CAINC1__ALL_AREAS_1969_2021.csv)
- Rents by region over time: [city_zori_all_homes.csv](https://github.com/andrewpking/a3-rent-too-high/blob/master/city_zori_all_homes.csv)

This script then calculates:

- The average rent for each county.
- The proportion of income per capita for each county spent on rent.
- Rent increase year over year as a number.
- Rent increases year over year as a percent.

It is worth noting that some data was lost when merging the two tables, but in order to normalize rent to income for an area, it was required to drop some areas. You can check out the resulting table: [rent_and_income.csv](https://github.com/andrewpking/a3-rent-too-high/blob/master/rent_and_income.csv)

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
