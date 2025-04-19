# Welcome to the Landslide Visualization App

Thank you for visiting this app!

This shiny application explores a dataset of landslides recorded around the world since 2007.

The data comes from The Global Landslide Catalog (GLC), and has been published by NASA.

You can find the data set here:[Data Set](https://catalog.data.gov/dataset/global-landslide-catalog-export-e5a5f)

## Data Manipulations

The is a very large data set with outliers, low frequency categories, and irrelevant variables. I take care of these issues in the `global.r` file. 

First, I dropped all of the irrelevant variables, keeping the ones I felt would give a good insight into the data.

I also dropped entries with missing values to ensure the completeness of the data.

Next, I filtered out the inaccurately recorded entries based on `location_accuracy`. 

I then lumped the low frequency categories within `landslide_category`, `landslide_trigger`, and `landslide_setting` to reduce the number of unique values and focus on the higher frequency values. 

Lastly, I joined the landslide data set with the data set used to plot the world map, in order to easily visualize the data on the same plot.
