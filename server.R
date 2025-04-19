#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#


# Define server logic required to draw a histogram
function(input, output, session) {
  
  ### Create a list of the categorical variable names
  ### Filter out the country names
  
  cat_names <- reactive({
    landslides %>%
      purrr::discard(is.numeric) %>%
      select(-country_name) %>%
      names()
  })
  
  ### Create a list of continuous variables
  ### Filter out the location data and ID
  
  con_names <- reactive({
    landslides %>%
      purrr::keep(is.numeric) %>%
      select(-ID) %>%
      select(-latitude) %>%
      select(-longitude) %>%
      names()
  })
  
  ### con_names without admin_division_population
  con_names_fil <- reactive({
    landslides %>%
      purrr::keep(is.numeric) %>%
      select(-ID) %>%
      select(-latitude) %>%
      select(-longitude) %>%
      select(-admin_division_population) %>%
      names()
  })
  
  
  ### test to print out cat list
  
  output$print_cat_names <- renderPrint({
    print(cat_names())
  })
  
  ### test to print out con list
  
  output$print_con_names <- renderPrint({
    print(con_names())
  })
  
  ### display categorical variable options for user input
  
  output$select_count_cat <- renderUI({
    selectInput('user_count_cat_1',
                'Select Categorical Variable:',
                choices = cat_names(),
                selected = cat_names()[1]
                )
  })
  
  ### Display continuous variable doptions for user input
  
  output$select_dist_con <- renderUI({
    selectInput('user_dist_con',
                'Select Continuous Variable:',
                choices = con_names(),
                selected = con_names()[1])
  })
  
  
  ### Catorigorical Variables Main Panel
  
  ### Plotting 1 Categorical Variable on a Bar Chart
  
  output$plot_barchart_1 <- renderPlot({
    landslides %>%
      ggplot(aes(y = .data[[input$user_count_cat_1]])) +
      geom_bar(fill = 'lightblue', color = 'navy') +
      theme_bw()
    
  })
  
  
  
  ### Continuous Variables Main Panel
  
  ### Plotting Distribution of Continuous Variable
  
  output$plot_histogram <- renderPlot({
    landslides %>%
      ggplot(aes(x = .data[[input$user_dist_con]])) +
      geom_histogram(fill = 'lightpink', color = 'hotpink', bins = 55) +
      theme_bw()
  })
  
  ### Variable Selections for the Map 1
  
  output$select_map_cat_1 <- renderUI({
    selectInput('user_map_cat_1',
                'Select Categorical Variable for Color:',
                choices = cat_names(),
                selected = cat_names()[1]
                )
  })
  
  output$select_map_cat_2 <- renderUI({
    selectInput('user_map_cat_2',
                'Select Categorical Variable for Size:',
                choices = cat_names(),
                selected = cat_names()[1]
    )
  })
  

  
  ### Variable Selections for the Map 2
  
  output$select_map_cat_3 <- renderUI({
    selectInput('user_map_cat_3',
                'Select Categorical Variable for Color:',
                choices = cat_names(),
                selected = cat_names()[1]
    )
  })
  
  output$select_map_con_1 <- renderUI({
    selectInput('user_map_con_1',
                'Select Continuous Variable for Size:',
                choices = con_names(),
                selected = con_names()[1]
    )
  })
  
  ### Variable Selections for Relationships Tab
  
  output$select_rel_con <- renderUI({
    selectInput('user_rel_con',
                'Select Continuous Variable for Distribution:',
                choices = con_names_fil(),
                selected = con_names_fil()[0]
                )
  })
  
  output$select_rel_cat <- renderUI({
    selectInput('user_rel_cat',
                'Select Categorical Variable for Color:',
                choices = cat_names(),
                selected = cat_names()[1]
    )
  })
  
  ### Relationships Main Panel
  
  ### Plotting the Condiointal KDE
  
  output$plot_rel <- renderPlot({
    landslides %>%
      ggplot(aes(x = .data[[input$user_rel_con]])) +
      geom_density(aes(color = .data[[input$user_rel_cat]]), linewidth = 1.2) +
      theme_bw()
  })
  
  ### Plotting the Boxplot
  
  output$plot_boxplot_1 <- renderPlot({
    landslides %>%
      ggplot(aes(y = .data[[input$user_rel_cat]], x = .data[[input$user_rel_con]])) +
      geom_boxplot(fill = 'lightblue') +
      theme_bw()
    
  })
  
  ### Selecting variables for scatter plot
  
  output$select_scat_con_1 <- renderUI({
    selectInput('user_scat_con_1',
                'Select First Continuous Variable:',
                choices = con_names(),
                selected = con_names()[0]
    )
  })
  
  output$select_scat_con_2 <- renderUI({
    selectInput('user_scat_con_2',
                'Select First Continuous Variable:',
                choices = con_names(),
                selected = con_names()[0]
    )
  })
  
  ### Scatter plot main panel
  
  output$plot_scatplot <- renderPlot({
    landslides %>%
      ggplot(aes(x = .data[[input$user_scat_con_1]], y = .data[[input$user_scat_con_2]])) +
      geom_point() +
      theme_bw()
  })
  
  ### Map Main Panel
  
  ### Plotting map graphic with categoricals
  
  output$plot_map_1 <- renderPlot({
    new_world %>% 
      ggplot() +
      geom_sf() +
      geom_point(mapping = aes(x = longitude, y = latitude, color = .data[[input$user_map_cat_1]], size = .data[[input$user_map_cat_2]]), alpha = input$user_slider_1) +
      theme_void()
  })
  
  ### Plotting map graphic with 1 categorical as color and 1 continuous as size
  
  output$plot_map_2 <- renderPlot({
    new_world %>% 
      ggplot() +
      geom_sf() +
      geom_point(mapping = aes(x = longitude, y = latitude, color = .data[[input$user_map_cat_3]], size = .data[[input$user_map_con_1]]), alpha = input$user_slider_2) +
      theme_void()
  })
}
