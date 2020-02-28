library(ggplot2)
library(tidyverse)
library(shiny)
library(shinydashboard)
library(DT)
dashboardPage(
    dashboardHeader(title = "Polity Score Comparison", titleWidth = 300),
    dashboardSidebar( width = 300,
        sidebarMenu(
            menuItem(text = "Polity Score", tabName = 'dem_score', icon = icon('globe')),
            menuItem(text = "Income", tabName = 'income', icon = icon('dollar-sign')),
            menuItem(text = "Literacy", tabName = 'literacy', icon = icon('book-reader')),
            menuItem(text = "CO2 Emission", tabName = 'emission', icon = icon('industry')),
            menuItem(text = "Life Expectancy", tabName = 'life_expectancy', icon = icon('heartbeat')),
            menuItem(text = "Water Access", tabName = 'water_access', icon = icon('tint')),
            menuItem(text = "Employment", tabName = 'employment_rate', icon = icon('warehouse')),
            menuItem(text = "CPI", tabName = 'cpi_rate', icon = icon('dharmachakra')),
            menuItem(text = "Democracy Level Map",  icon = icon('globe-asia'),
                     menuSubItem('Autocracy', tabName = 'autocracy'),
                     menuSubItem('Closed Anocracy', tabName = 'closed_anocracy'),
                     menuSubItem('Open Anocracy', tabName = 'open_anocracy'),
                     menuSubItem('Democracy', tabName = 'democracy'),
                     menuSubItem('Full Democracy', tabName = 'full_democracy')
            ),
            menuItem(text = "Comparison",  icon = icon('not-equal'),
                    menuSubItem('Income Compare', tabName = 'income_compare'),
                    menuSubItem('Literacy Compare', tabName = 'literacy_compare'),
                    menuSubItem('CO2 Emission Compare', tabName = 'emission_compare'),
                    menuSubItem('Life Expectancy Compare', tabName = 'life_expectancy_compare'),
                    menuSubItem('Water Access Compare', tabName = 'water_compare'),
                    menuSubItem('Employment Compare', tabName = 'employment_compare'),
                    menuSubItem('CPI Compare', tabName = 'cpi_compare')
                    ),
            
            menuItem(text = 'Data', tabName = 'data_table', icon = icon('database'))
        )
    ),
    dashboardBody(
        tabItems(
            # 1. Map
            tabItem(tabName = "dem_score",
                    fluidRow(
                        box(
                            plotOutput(outputId='dem_score_output'), width = 12
                        )
                    )
            ),
            # 2. Income
            tabItem(tabName = "income",
                    fluidRow(
                        infoBoxOutput(outputId='income_minbox', width = 6) ,
                        infoBoxOutput(outputId='income_maxbox', width = 6)  
                    ),
                    fluidRow(
                        box(
                            plotOutput(outputId='income_hist_output'), width = 12
                        )
                    ),
                    fluidRow(
                        box(
                            plotOutput(outputId='income_box_output'), width = 12
                        )
                    )
            ),
            # 3. Literacy
            tabItem(tabName = "literacy",
                    fluidRow(
                        infoBoxOutput(outputId='literacy_minbox', width = 6) ,
                        infoBoxOutput(outputId='literacy_maxbox', width = 6)  
                    ),
                    fluidRow(
                        box(
                            plotOutput(outputId='literacy_hist_output'), width = 12
                        )
                    ),
                    fluidRow(
                        box(
                            plotOutput(outputId='literacy_box_output'), width = 12
                        )
                    )
            ),
            # 4. CO2 Emission
            tabItem(tabName = "emission",
                    fluidRow(
                        infoBoxOutput(outputId='emission_minbox', width = 6) ,
                        infoBoxOutput(outputId='emission_maxbox', width = 6)  
                    ),
                    fluidRow(
                        box(
                            plotOutput(outputId='emission_hist_output'), width = 12
                        )
                    ),
                    fluidRow(
                        box(
                            plotOutput(outputId='emission_box_output'), width = 12
                        )
                    )
            ),
            # 5. Life Expectancy
            tabItem(tabName = "life_expectancy",
                    fluidRow(
                        infoBoxOutput(outputId='life_expectancy_minbox', width = 6) ,
                        infoBoxOutput(outputId='life_expectancy_maxbox', width = 6)  
                    ),
                    fluidRow(
                        box(
                            plotOutput(outputId='life_expectancy_hist_output'), width = 12
                        )
                    ),
                    fluidRow(
                        box(
                            plotOutput(outputId='life_expectancy_box_output'), width = 12
                        )
                    )
            ),
            # 6. Water Access
            tabItem(tabName = "water_access",
                    fluidRow(
                        infoBoxOutput(outputId='water_access_minbox', width = 6) ,
                        infoBoxOutput(outputId='water_access_maxbox', width = 6)  
                    ),
                    fluidRow(
                        box(
                            plotOutput(outputId='water_access_hist_output'), width = 12
                        )
                    ),
                    fluidRow(
                        box(
                            plotOutput(outputId='water_access_box_output'), width = 12
                        )
                    )
            ),
            # 7. Employment
            tabItem(tabName = "employment_rate",
                    fluidRow(
                        infoBoxOutput(outputId='employment_rate_minbox', width = 6) ,
                        infoBoxOutput(outputId='employment_rate_maxbox', width = 6)  
                    ),
                    fluidRow(
                        box(
                            plotOutput(outputId='employment_rate_hist_output'), width = 12
                        )
                    ),
                    fluidRow(
                        box(
                            plotOutput(outputId='employment_rate_box_output'), width = 12
                        )
                    )
            ),
            # 8. CPI
            tabItem(tabName = "cpi_rate",
                    fluidRow(
                        infoBoxOutput(outputId='cpi_minbox', width = 6) ,
                        infoBoxOutput(outputId='cpi_maxbox', width = 6)  
                    ),
                    fluidRow(
                        box(
                            plotOutput(outputId='cpi_rate_hist_output'), width = 12
                        )
                    ),
                    fluidRow(
                        box(
                            plotOutput(outputId='cpi_rate_box_output'), width = 12
                        )
                    )
            ),
            # 9.A. Autocracy
            tabItem(tabName = "autocracy",
                    fluidRow(
                        box(
                            plotOutput(outputId='autocracy_output'), width = 12
                        )
                    ),
                    fluidRow(
                        box(
                            DT::dataTableOutput(outputId='autocracy_table_output'), width = 12
                        )
                    )
            ),
            # 9.B. Closed Anocracy
            tabItem(tabName = "closed_anocracy",
                    fluidRow(
                        box(
                            plotOutput(outputId='closed_anocracy_output'), width = 12
                        )
                    ),
                    fluidRow(
                        box(
                            DT::dataTableOutput(outputId='closed_autocracy_table_output'), width = 12
                        )
                    )
            ),
            # 9.C. Open Anocracy
            tabItem(tabName = "open_anocracy",
                    fluidRow(
                        box(
                            plotOutput(outputId='open_anocracy_output'), width = 12
                        )
                    ),
                    fluidRow(
                        box(
                            DT::dataTableOutput(outputId='open_autocracy_table_output'), width = 12
                        )
                    )
            ),
            # 9.D. Democracy
            tabItem(tabName = "democracy",
                    fluidRow(
                        box(
                            plotOutput(outputId='democracy_output'), width = 12
                        )
                    ),
                    fluidRow(
                        box(
                            DT::dataTableOutput(outputId='democracy_table_output'), width = 12
                        )
                    )
            ),
            # 9.E. Full Democracy
            tabItem(tabName = "full_democracy",
                    fluidRow(
                        box(
                            plotOutput(outputId='full_democracy_output'), width = 12
                        )
                    ),
                    fluidRow(
                        box(
                            DT::dataTableOutput(outputId='full_democracy_table_output'), width = 12
                        )
                    )
            ),
            # 10.A. Income Compare
            tabItem(tabName = "income_compare",
                    fluidRow(
                        box(
                            plotOutput(outputId='income_compare_output'), width = 12
                        )
                    )
            ),
            # 10.B. Literacy Compare
            tabItem(tabName = "literacy_compare",
                    fluidRow(
                        box(
                            plotOutput(outputId='literacy_compare_output'), width = 12
                        )
                    )
            ),
            # 10.C. CO2 Emission Compare
            tabItem(tabName = "emission_compare",
                    fluidRow(
                        box(
                            plotOutput(outputId='emission_compare_output'), width = 12
                        )
                    )
            ),
            
            # 10.D. Life Expectancy Compare
            tabItem(tabName = "life_expectancy_compare",
                    fluidRow(
                        box(
                            plotOutput(outputId='life_expectancy_compare_output'), width = 12
                        )
                    )
            ),
            # 10.E. Water Access Compare
            tabItem(tabName = "water_compare",
                    fluidRow(
                        box(
                            plotOutput(outputId='water_compare_output'), width = 12
                        )
                    )
            ),
            # 10.F. Employment Compare
            tabItem(tabName = "employment_compare",
                    fluidRow(
                        box(
                            plotOutput(outputId='employment_compare_output'), width = 12
                        )
                    )
            ),
            # 10.G. CPI Compare
            tabItem(tabName = "cpi_compare",
                    fluidRow(
                        box(
                            plotOutput(outputId='cpi_compare_output'), width = 12
                        )
                    )
            ),
            # 11. Data
            tabItem(tabName = "data_table",
                fluidRow(
                    box(
                        DT::dataTableOutput(outputId='data_table_output'), width = 12
                    )
                )
            )
            
        )
    )
)