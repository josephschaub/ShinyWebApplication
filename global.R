### Global Script for the Landslide Visualization App

library(tidyverse)
library(shiny)
library(dplyr)
library(sf)
library(maps)
library(rnaturalearth)

### Import the dataset

landslides <- read.csv(url('https://data.nasa.gov/api/views/dd9e-wu2v/rows.csv?accessType=DOWNLOAD'))

### Remove Irrelevant Columns
### These columns are not any of the variables I want to explore in the app, so we will simply remove them

landslides$source_name <- NULL
landslides$source_link <- NULL
landslides$event_id <- NULL
landslides$event_title <- NULL
landslides$event_description <- NULL
landslides$location_description <- NULL
landslides$photo_link <- NULL
landslides$storm_name <- NULL
landslides$notes <- NULL
landslides$event_time <- NULL
landslides$event_date <- NULL
landslides$event_import_source <- NULL
landslides$event_import_id <- NULL
landslides$country_code <- NULL
landslides$admin_division_name <- NULL
landslides$gazeteer_closest_point <- NULL
landslides$gazeteer_distance <- NULL
landslides$submitted_date <- NULL
landslides$created_date <- NULL
landslides$last_edited_date <- NULL

### Drop the entries that have extremely high location inaccuracy or unknown accuracy, in order to visualize the GIS data more clearly and correctly.

landslides <- landslides %>% filter(!(location_accuracy == 'unknown'))
landslides <- landslides %>% filter(!(location_accuracy == '250km'))
landslides <- landslides %>% filter(!(location_accuracy == '100km'))

### Dropping Outliers
### `fatality_count` and `injury_count` are  right skewed due to outliers, so I will filter out the higher values. I don't wanna filter the
### `admin_division_population` because I dont want to completely remove some places off of the map due to higher population

landslides <- landslides %>% filter(fatality_count <= 25)
landslides <- landslides %>% filter(injury_count <= 25)

### Lumping Low Frequency Categories
### # of the categorical variables have values with very low frequency, so we will lump those together into an 'Other' category

landslides <- landslides %>%
  mutate(landslide_category = fct_lump_prop(landslide_category, prop = .02, other_level = '(OTHER)'),
         landslide_category = fct_infreq(landslide_category),
         landslide_category = fct_rev(landslide_category)
  )

landslides <- landslides %>%
  mutate(landslide_trigger = fct_lump_prop(landslide_trigger, prop = .012, other_level = '(OTHER)'),
         landslide_trigger = fct_infreq(landslide_trigger),
         landslide_trigger = fct_rev(landslide_trigger)
  )

landslides <- landslides %>%
  mutate(landslide_setting = fct_lump_prop(landslide_setting, prop = .02, other_level = '(OTHER)'),
         landslide_setting = fct_infreq(landslide_setting),
         landslide_setting = fct_rev(landslide_setting)
  )

### Drop Missings

landslides <- landslides %>% na.omit()


### Import data important for maps
world <- ne_countries()

world <- st_as_sf( world )

### Add ID' columns to both 'world' and 'landslides' to help join them

world <- tibble::rowid_to_column(world, 'ID')

landslides <- tibble::rowid_to_column(landslides, 'ID')

### Join the datasets to make plotting easier

new_world <- world %>%
  left_join(landslides, by = 'ID')
