# Load necessary libraries
library(tidyverse)
library(tidygeocoder) # You may have to install this with devtools.

# Load the rent_data
zori_all_homes <- read_csv("data/city_zori_all_homes.csv")
income_per_capita <- read_csv("data/CAINC1__ALL_AREAS_1969_2021.csv")

# Normalize the rent_data
pivot_zori <- zori_all_homes %>%
  pivot_longer(
    cols = contains("-"),
    names_to = "Month_Year",
    values_to = "Rent"
  ) %>%
  separate(Month_Year, into = c("Year", "Month"), sep = "-", remove = FALSE) %>%
  filter(!is.na(Rent)) %>%
  group_by(Year, CountyName) %>%
  mutate(`Avg Rent` = mean(Rent)) %>%
  distinct(Year, State, CountyName, `Avg Rent`) %>%
  mutate(County = str_remove(CountyName, " County")) %>%
  ungroup() %>%
  mutate(Year = as.numeric(Year)) %>%
  select(Year, State, County, `Avg Rent`)

pivot_income_per_capita <- income_per_capita %>%
  filter(str_detect(Description, "2/")) %>%
  pivot_longer(
    cols = num_range("", 2015:2021),
    names_to = "Year",
    values_to = "Income per capita"
  ) %>%
  select(GeoFIPS, Year, GeoName, `Income per capita`) %>%
  separate(GeoName, into = c("County", "State"), sep = ", ", remove = TRUE) %>%
  filter(!is.na(State)) %>%
  mutate(Year = as.numeric(Year)) %>% 
  mutate(
    State =  str_remove_all(State, "\\*")
  )

pivot_population <- income_per_capita %>%
  filter(str_detect(Description, "1/")) %>%
  pivot_longer(
    cols = num_range("", 2015:2021),
    names_to = "Year",
    values_to = "Population"
  ) %>%
  select(GeoFIPS, Year, GeoName, Population) %>%
  separate(GeoName, into = c("County", "State"), sep = ", ", remove = TRUE) %>%
  filter(!is.na(State)) %>%
  mutate(Year = as.numeric(Year)) %>%
  mutate(
    State =  str_remove_all(State, "\\*")
  )

pivot_gross_income <- income_per_capita %>%
  filter(str_detect(Description, "(thousands of dollars)")) %>%
  pivot_longer(
    cols = num_range("", 2015:2021),
    names_to = "Year",
    values_to = "Gross Income"
  ) %>%
  select(GeoFIPS, Year, GeoName, `Gross Income`) %>%
  separate(GeoName, into = c("County", "State"), sep = ", ", remove = TRUE) %>%
  filter(!is.na(State)) %>%
  mutate(Year = as.numeric(Year)) %>%
  mutate(
    State =  str_remove_all(State, "\\*")
  )

county_info <- pivot_income_per_capita %>%
  inner_join(pivot_population) %>%
  inner_join(pivot_gross_income) %>%
  mutate(County = str_remove(County, " County"))

rent_and_income <- county_info %>%
  left_join(pivot_zori) %>%
  mutate(
    `Income per capita` = as.numeric(`Income per capita`),
    `Population` = as.numeric(`Population`),
    `Gross Income` = as.numeric(`Gross Income`)
  ) %>%
  mutate(
    `Rent as Percent Income` = (`Avg Rent` * 12) / `Income per capita` * 100
    ) %>%
  group_by(State, County) %>%
  arrange(State, County, Year) %>%
  mutate(
    `Rent Change YOY` = case_when(
      n() == 1 ~ NA_real_,  # If the county has only one row, NA
      min(Year) == Year ~ NA_real_,  # If it's the first year for the county, NA
      TRUE ~ `Avg Rent` - lag(`Avg Rent`)  # Otherwise, calculate the difference
    )
  )%>%
  mutate(
    `Percent Rent Change YOY` = case_when(
      n() == 1 ~ NA_real_,
      min(Year) == Year ~ NA_real_,
      TRUE ~ (`Rent Change YOY` / lag(`Avg Rent`)) * 100
    )
  ) %>%
  mutate(
    `Rent as Percent Income Change YOY` = case_when(
      n() == 1 ~ NA_real_,
      min(Year) == Year ~ NA_real_,
      TRUE ~ `Rent as Percent Income` - lag(`Rent as Percent Income`)
    )
  )

# Data validation
single_entries <- rent_and_income %>% group_by(State, County) %>% filter(n() == 1)
start_entries <- rent_and_income %>% group_by(State, County) %>% filter(min(Year) == Year)

# Save the joined tables to a new CSV file
write_csv(rent_and_income, "data/rent_and_income.csv")


# Now lets take a weighted average for each state by year
states_rent <- rent_and_income %>%
  filter(!is.na(`Avg Rent`)) %>%
  group_by(Year, State) %>%
  summarise(
    `GeoFIPS` = first(str_replace(GeoFIPS, "\\d{3}$", "000")), # Replace the last 3 of 5 digits with zeroes
    `Avg Rent` = sum(`Avg Rent` * Population, na.rm = TRUE) / sum(Population, na.rm = TRUE),
    `Income per capita` = sum(`Income per capita` * Population, na.rm = TRUE) / sum(Population, na.rm = TRUE),
    `Population` = sum(Population)
    ) %>%
  filter(State %in% state.abb) %>%
  mutate(`Avg Rent` = case_when(`Avg Rent` == 0 ~ NA_real_, TRUE ~ `Avg Rent`)) %>%
  mutate(`Rent as Percent Income` = (`Avg Rent` * 12) / `Income per capita` * 100) %>%
  group_by(State) %>%
  arrange(State, Year) %>%
  mutate(
    `Rent Change YOY` = case_when(
      n() == 1 ~ NA_real_,  # If the county has only one row, NA
      min(Year) == Year ~ NA_real_,  # If it's the first year for the county, NA
      TRUE ~ `Avg Rent` - lag(`Avg Rent`)  # Otherwise, calculate the difference
    )
  )%>%
  mutate(
    `Percent Rent Change YOY` = case_when(
      n() == 1 ~ NA_real_,
      min(Year) == Year ~ NA_real_,
      TRUE ~ (`Rent Change YOY` / lag(`Avg Rent`)) * 100
    )
  ) %>%
  mutate(
    `Rent as Percent Income Change YOY` = case_when(
      n() == 1 ~ NA_real_,
      min(Year) == Year ~ NA_real_,
      TRUE ~ `Rent as Percent Income` - lag(`Rent as Percent Income`)
    )
  )
  
write_csv(states_rent, "data/rent_and_income_state.csv")
