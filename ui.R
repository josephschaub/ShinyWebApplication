#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#


navbarPage('Landslide Visualization App',
           tabPanel('Welcome!',
                    includeMarkdown('welcome_landslide.md')),
           tabPanel('Categorical Variable Exploration',
                    sidebarLayout(
                      sidebarPanel(
                        uiOutput('select_count_cat')
                                   ),
                      mainPanel(
                                h3('Bar Charts'),
                                plotOutput('plot_barchart_1')
                                )
                    )),
           tabPanel('Continuous Variable Exploration',
                    sidebarLayout(
                      sidebarPanel(
                        uiOutput('select_dist_con')
                      ),
                      mainPanel(
                        h3('Distributions'),
                        plotOutput('plot_histogram')
                      )
                    )),
           tabPanel('Categorical to Continuous Relationships',
                    sidebarLayout(
                      sidebarPanel(
                        uiOutput('select_rel_con'),
                        uiOutput('select_rel_cat')
                      ),
                      mainPanel(
                        h3('Conditional KDE for Selected Variables'),
                        plotOutput('plot_rel'),
                        h3('Boxplot for Selected Variables'),
                        plotOutput('plot_boxplot_1')
                      )
                    )
           ),
           tabPanel('Scatterplots',
                    sidebarLayout(
                      sidebarPanel(
                        uiOutput('select_scat_con_1'),
                        uiOutput('select_scat_con_2')
                      ),
                      mainPanel(
                        h3('Scatter Plot for 2 Continuous Variables'),
                        plotOutput('plot_scatplot')
                      )
                    )
             
           ),
           tabPanel('Map Visualization',
                    sidebarLayout(
                      sidebarPanel(
                        h3('Variable Selections for Map 1:'),
                        uiOutput('select_map_cat_1'),
                        uiOutput('select_map_cat_2'),
                        sliderInput('user_slider_1',
                                    'alpha value:',
                                    min = 0, max = 1, value = .25),
                        h3('Variable Selections for Map 2:'),
                        uiOutput('select_map_cat_3'),
                        uiOutput('select_map_con_1'),
                        sliderInput('user_slider_2',
                                    'alpha value:',
                                    min = 0, max = 1, value = .25)
                      ),
                      mainPanel(
                        h3('Map 1'),
                        plotOutput('plot_map_1'),
                        h3('Map 2'),
                        plotOutput('plot_map_2')
                      )
                    ))
  
)