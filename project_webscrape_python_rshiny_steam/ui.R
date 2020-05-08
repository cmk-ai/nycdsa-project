library(ggplot2)
library(tidyverse)
library(shiny)
library(shinydashboard)
library(DT)
dashboardPage(
    dashboardHeader(title = "Steam Analysis", titleWidth = 300),
    dashboardSidebar( width = 300,
        sidebarMenu(
            menuItem(text = 'Data', tabName = 'data_table', icon = icon('database')),
            menuItem(text = "Year/Month", tabName = 'year_month_analysis', icon = icon('calendar')),
            menuItem(text = "Review",  icon = icon('users'),
                     menuSubItem('Review Category', tabName = 'review_category'),
                     menuSubItem('Violence in Game', tabName = 'violence_game'),
                     menuSubItem('Discount by Category', tabName = 'discount_by_category'),
                     menuSubItem('Free vs Paid', tabName = 'free_paid'),
                     menuSubItem('Player Type', tabName = 'player_type'),
                     menuSubItem('Game Publisher', tabName = 'game_publisher'),
                     menuSubItem('Review Category by Genre', tabName = 'review_category_genre')
            ),
            menuItem(text = "User Purchase/Review",  icon = icon('credit-card'),
                     menuSubItem('Steam Purchase', tabName = 'steam_purchase'),
                     menuSubItem('All Review', tabName = 'all_review'),
                     menuSubItem('Positive Review', tabName = 'positive_review'),
                     menuSubItem('Negative Review', tabName = 'negative_review')
            ),
            menuItem(text = "Price",  icon = icon('tags'),
                     menuSubItem('Year vs Avg.Price', tabName = 'year_avg_price'),
                     menuSubItem('Original Price', tabName = 'original_price'),
                     menuSubItem('Price before Discount', tabName = 'price_before_discount'),
                     menuSubItem('Price after Discount', tabName = 'price_after_discount'),
                     menuSubItem('Price Dist. by Genre', tabName = 'price_dist_by_genre'),
                     menuSubItem('Price by Genre', tabName = 'price_by_genre')
                     
            ),
            menuItem(text = "Memory/Storage",  icon = icon('memory'),
                     menuSubItem('Memory vs Median Price', tabName = 'memory_median_price'),
                     menuSubItem('Memory Distribution', tabName = 'memory_distribution'),
                     menuSubItem('Storage Distribution', tabName = 'storage_distribution'),
                     menuSubItem('Memory by Genre', tabName = 'memory_by_genre')
            )
            
        )
    ),
    dashboardBody(
        tabItems(
            # 1. Data
            tabItem(tabName = "data_table",
                    fluidRow(
                        box(
                            DT::dataTableOutput(outputId='data_table_output'), width = 12
                        )
                    )
            ),
            # 2. Year/Month
            tabItem(tabName = "year_month_analysis",
                    fluidRow(
                        box(
                            plotOutput(outputId='year_analysis_output'), width = 12
                        )
                    ),
                    fluidRow(
                        box(
                            plotOutput(outputId='month_analysis_output'), width = 12
                        )
                    )
            ),
            # 3A. Review by Category
            tabItem(tabName = "review_category",
                    fluidRow(
                        box(
                            plotOutput(outputId='review_category_output'), width = 12
                        )
                    )
            ),
            # 3B. Violence in Game
            tabItem(tabName = "violence_game",
                    fluidRow(
                        box(
                            plotOutput(outputId='violence_game_output'), width = 12
                        )
                    ),
                    fluidRow(
                        box(
                            plotOutput(outputId='violence_game_review_output'), width = 12
                        )
                    )
            ),
            # 3C. Discount by Category
            tabItem(tabName = "discount_by_category",
                    fluidRow(
                        box(
                            plotOutput(outputId='discount_by_category_output'), width = 12
                        )
                    )
            ),
            # 3D. Free vs Paid
            tabItem(tabName = "free_paid",
                    fluidRow(
                        box(
                            plotOutput(outputId='free_paid_output'), width = 12
                        )
                    )
            ),
            # 3E. Player Type
            tabItem(tabName = "player_type",
                    fluidRow(
                        box(
                            plotOutput(outputId='player_type_output'), width = 12
                        )
                    )
            ),
            # 3F. Game Publisher
            tabItem(tabName = "game_publisher",
                    fluidRow(
                        box(
                            plotOutput(outputId='game_publisher_output'), width = 12
                        )
                    )
            ),
            # 3G. Review Category by Game
            tabItem(tabName = "review_category_genre",
                    fluidRow(
                        box(
                            plotOutput(outputId='review_category_genre_output'), width = 12
                        )
                    )
            ),
            # 4A. Steam Purchase
            tabItem(tabName = "steam_purchase",
                    fluidRow(
                        infoBoxOutput(outputId='steam_purchase_minbox', width = 6) ,
                        infoBoxOutput(outputId='steam_purchase_maxbox', width = 6)  
                    ),
                    fluidRow(
                        box(
                            plotOutput(outputId='steam_purchase_hist_output'), width = 12
                        )
                    ),
                    fluidRow(
                        box(
                            plotOutput(outputId='steam_purchase_box_output'), width = 12
                        )
                    )
            ),
            # 4B. All Review
            tabItem(tabName = "all_review",
                    fluidRow(
                        infoBoxOutput(outputId='all_review_minbox', width = 6) ,
                        infoBoxOutput(outputId='all_review_maxbox', width = 6)  
                    ),
                    fluidRow(
                        box(
                            plotOutput(outputId='all_review_hist_output'), width = 12
                        )
                    ),
                    fluidRow(
                        box(
                            plotOutput(outputId='all_review_box_output'), width = 12
                        )
                    )
            ),
            # 4C. Positive Review
            tabItem(tabName = "positive_review",
                    fluidRow(
                        infoBoxOutput(outputId='positive_review_minbox', width = 6) ,
                        infoBoxOutput(outputId='positive_review_maxbox', width = 6)  
                    ),
                    fluidRow(
                        box(
                            plotOutput(outputId='positive_review_hist_output'), width = 12
                        )
                    ),
                    fluidRow(
                        box(
                            plotOutput(outputId='positive_review_box_output'), width = 12
                        )
                    )
            ),
            # 4C. Negative Review
            tabItem(tabName = "negative_review",
                    fluidRow(
                        infoBoxOutput(outputId='negative_review_minbox', width = 6) ,
                        infoBoxOutput(outputId='negative_review_maxbox', width = 6)  
                    ),
                    fluidRow(
                        box(
                            plotOutput(outputId='negative_review_hist_output'), width = 12
                        )
                    ),
                    fluidRow(
                        box(
                            plotOutput(outputId='negative_review_box_output'), width = 12
                        )
                    )
            ),
            # 5A.Year vs Price
            tabItem(tabName = "year_avg_price",
                    fluidRow(
                        box(
                            plotOutput(outputId='year_avg_price_output'), width = 12
                        )
                    )
            ),
            # 5B. Original Price
            tabItem(tabName = "original_price",
                    fluidRow(
                        infoBoxOutput(outputId='original_price_minbox', width = 6) ,
                        infoBoxOutput(outputId='original_price_maxbox', width = 6)  
                    ),
                    fluidRow(
                        box(
                            plotOutput(outputId='original_price_hist_output'), width = 12
                        )
                    ),
                    fluidRow(
                        box(
                            plotOutput(outputId='original_price_box_output'), width = 12
                        )
                    )
            ),
            # 5C. Price before Discount
            tabItem(tabName = "price_before_discount",
                    fluidRow(
                        infoBoxOutput(outputId='price_before_discount_minbox', width = 6) ,
                        infoBoxOutput(outputId='price_before_discount_maxbox', width = 6)  
                    ),
                    fluidRow(
                        box(
                            plotOutput(outputId='price_before_discount_hist_output'), width = 12
                        )
                    ),
                    fluidRow(
                        box(
                            plotOutput(outputId='price_before_discount_box_output'), width = 12
                        )
                    )
            ),
            # 5D. Price after Discount
            tabItem(tabName = "price_after_discount",
                    fluidRow(
                        infoBoxOutput(outputId='price_after_discount_minbox', width = 6) ,
                        infoBoxOutput(outputId='price_after_discount_maxbox', width = 6)  
                    ),
                    fluidRow(
                        box(
                            plotOutput(outputId='price_after_discount_hist_output'), width = 12
                        )
                    ),
                    fluidRow(
                        box(
                            plotOutput(outputId='price_after_discount_box_output'), width = 12
                        )
                    )
            ),
            # 5E. Price distribution by Genre
            tabItem(tabName = "price_dist_by_genre",
                    fluidRow(
                        box(
                            plotOutput(outputId='price_dist_by_genre_output'), width = 12
                        )
                    )
            ),
            # 5F. Price distribution by Genre
            tabItem(tabName = "price_by_genre",
                    fluidRow(
                        box(
                            plotOutput(outputId='price_by_genre_output'), width = 12
                        )
                    )
            ),
            # 6A. Memory vs Median Price
            tabItem(tabName = "memory_median_price",
                    fluidRow(
                        box(
                            plotOutput(outputId='memory_median_price_output'), width = 12
                        )
                    )
            ),
            # 6B. Memory Distribution
            tabItem(tabName = "memory_distribution",
                    fluidRow(
                        infoBoxOutput(outputId='memory_distribution_minbox', width = 6) ,
                        infoBoxOutput(outputId='memory_distribution_maxbox', width = 6)  
                    ),
                    fluidRow(
                        box(
                            plotOutput(outputId='memory_distribution_hist_output'), width = 12
                        )
                    ),
                    fluidRow(
                        box(
                            plotOutput(outputId='memory_distribution_box_output'), width = 12
                        )
                    )
            ),
            # 6C. Storage Distribution
            tabItem(tabName = "storage_distribution",
                    fluidRow(
                        infoBoxOutput(outputId='storage_distribution_minbox', width = 6) ,
                        infoBoxOutput(outputId='storage_distribution_maxbox', width = 6)  
                    ),
                    fluidRow(
                        box(
                            plotOutput(outputId='storage_distribution_hist_output'), width = 12
                        )
                    ),
                    fluidRow(
                        box(
                            plotOutput(outputId='storage_distribution_box_output'), width = 12
                        )
                    )
            ),
            # 6D. Memory by Genre
            tabItem(tabName = "memory_by_genre",
                    fluidRow(
                        box(
                            plotOutput(outputId='memory_by_genre_output'), width = 12
                        )
                    )
            )
        )
    )
)