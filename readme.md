# Rent Too High - CSE 442

Authors: Drew King, Dan Sutton, Joey Kreuger, Jack Rosenbloom

## Dataset

- [Personal Income Data from Bureau of Economic Analysis](https://apps.bea.gov/regional/histdata/releases/1122lapi/CAINC1.zip)
- [Zillow Rent Index (ZORI) for All Homes from Zillow](https://www.zillow.com/research/data/)

## Problem

The rent is too high. In fact it is so high that ZORI data only captures the average from the 35th to 65th percentile of rents, so it generally skews down from the true average rent. It is likely they have a vested interest in hiding the true average rent. Despite this limitation, a brief analysis using R and creating a tableau dashboard has shown that rents are outpacing wages as a proportion in most areas.

## Proposed Solution

An interactive data visualization written in Vega-Lite that allows people to explore the rising costs of rent over time, with data that is adjusted for wages.

A prototype has been created with [Tableau dashboards](https://public.tableau.com/views/A3-TheRentIsTooHigh/TheRentisTooHigh-FromZORIDataset?:language=en-US&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link) to highlight potential interactive components.
