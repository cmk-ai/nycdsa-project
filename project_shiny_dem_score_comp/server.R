library(ggplot2)
library(tidyverse)
library(shiny)
library(shinydashboard)

shinyServer(function(input, output){
  # 1. show Map of dem_score
  output$dem_score_output <- renderPlot({
    ggplot() +
      geom_polygon(data = dem_score_latest, 
                   aes(x = long, y = lat, group = group, fill = score)) +
      theme_classic() +
      theme(plot.title = element_text(hjust = 0.5),
            axis.title=element_blank(),
            axis.text=element_blank(),
            axis.ticks=element_blank(),
            axis.line = element_blank()
      ) +
      labs(title="Polity Score")
  })
  # 2. Income
  #minbox
  output$income_minbox <- renderInfoBox({
    min_value <- min(all_latest['income_5'],na.rm = TRUE)[1]
    min_country <- 
      min(all_latest$country[all_latest['income_5']==min_value], na.rm = T)[1]
    min_score <- 
      min(all_latest$score[all_latest['income_5']==min_value], na.rm = T)[1]
    info_title <- paste0(min_country," [", min_score,"]", collapse = "")
    infoBox(title=info_title,
            value= min_value, icon = icon("hand-o-down"))
    
  })
  #maxbox
  output$income_maxbox <- renderInfoBox({
    max_value <- max(all_latest['income_5'], na.rm = TRUE)[1]
    max_country <- 
      max(all_latest$country[all_latest['income_5']==max_value], na.rm = T)[1]
    max_score <- 
      max(all_latest$score[all_latest['income_5']==max_value], na.rm = T)[1]
    info_title <- paste0(max_country," [", max_score,"]", collapse = "")
    infoBox(title=info_title,
            value= max_value, icon = icon("hand-o-up"))
    
  })
  
  # Histogram
  output$income_hist_output <- renderPlot({
    ggplot( data=all_latest, aes(x=income_1) ) +
      geom_density(alpha=0.1, color='black', fill='blue') +
      theme_classic() +
      theme(plot.title = element_text(hjust = 0.5))+
      labs(title="Income per Person", 
           x="Income per Person in USD per Year", y="Density") +
      scale_x_continuous(expand = c(0, 0)) + 
      scale_y_continuous(expand = c(0, 0))
  })
  # Box Plot
  output$income_box_output <- renderPlot({
    ggplot(data=all_latest, 
           aes(x=as.factor(score), y=income_1, group=score)) +
      geom_boxplot(alpha=0.1, color='black', fill='blue') +
      theme_classic() +
      theme(plot.title = element_text(hjust = 0.5))+
      labs(title="Income per Person according to polity score", 
           x="Polity Score", y="Income per Person in USD per Year")
  })
  # 3. Literacy
  #minbox
  output$literacy_minbox <- renderInfoBox({
    min_value <- min(all_latest['literacy_5'],na.rm = TRUE)[1]
    min_country <- 
      min(all_latest$country[all_latest['literacy_5']==min_value], na.rm = T)[1]
    min_score <- 
      min(all_latest$score[all_latest['literacy_5']==min_value], na.rm = T)[1]
    info_title <- paste0(min_country," [", min_score,"]", collapse = "")
    infoBox(title=info_title,
            value= min_value, icon = icon("hand-o-down"))
    
  })
  #maxbox
  output$literacy_maxbox <- renderInfoBox({
    max_value <- max(all_latest['literacy_5'], na.rm = TRUE)[1]
    max_country <- 
      max(all_latest$country[all_latest['literacy_5']==max_value], na.rm = T)[1]
    max_score <- 
      max(all_latest$score[all_latest['literacy_5']==max_value], na.rm = T)[1]
    info_title <- paste0(max_country," [", max_score,"]", collapse = "")
    infoBox(title=info_title,
            value= max_value, icon = icon("hand-o-up"))
    
  })
  # Histogram
  output$literacy_hist_output <- renderPlot({
    ggplot( data=all_latest, aes(x=literacy_1) ) +
      geom_density(alpha=0.1, color='black', fill='blue') +
      theme_classic() +
      theme(plot.title = element_text(hjust = 0.5))+
      labs(title="Literacy rate", 
           x="Literacy rate, adult total (% of people ages 15 and above)", 
           y="Density") +
      scale_x_continuous(expand = c(0, 0)) + 
      scale_y_continuous(expand = c(0, 0))
  })
  # Box Plot
  output$literacy_box_output <- renderPlot({
    ggplot(data=all_latest, 
           aes(x=as.factor(score), y=literacy_1, group=score)) +
      geom_boxplot(alpha=0.1, color='black', fill='blue') +
      theme_classic() +
      theme(plot.title = element_text(hjust = 0.5))+
      labs(title="Literacy rate according to polity score", 
           x="Polity Score", 
           y="Literacy rate, adult total (% of people ages 15 and above)")
  })
  # 4. CO2 Emission
  #minbox
  output$emission_minbox <- renderInfoBox({
    min_value <- min(all_latest['emission_5'],na.rm = TRUE)[1]
    min_country <- 
      min(all_latest$country[all_latest['emission_5']==min_value], na.rm = T)[1]
    min_score <- 
      min(all_latest$score[all_latest['emission_5']==min_value], na.rm = T)[1]
    info_title <- paste0(min_country," [", min_score,"]", collapse = "")
    infoBox(title=info_title,
            value= min_value, icon = icon("hand-o-down"))
    
  })
  #maxbox
  output$emission_maxbox <- renderInfoBox({
    max_value <- max(all_latest['emission_5'], na.rm = TRUE)[1]
    max_country <- 
      max(all_latest$country[all_latest['emission_5']==max_value], na.rm = T)[1]
    max_score <- 
      max(all_latest$score[all_latest['emission_5']==max_value], na.rm = T)[1]
    info_title <- paste0(max_country," [", max_score,"]", collapse = "")
    infoBox(title=info_title,
            value= max_value, icon = icon("hand-o-up"))
    
  })
  # Histogram
  output$emission_hist_output <- renderPlot({
    ggplot( data=all_latest, aes(x=emission_1) ) +
      geom_density(alpha=0.1, color='black', fill='blue') +
      theme_classic() +
      theme(plot.title = element_text(hjust = 0.5))+
      labs(title="CO2 Emission", 
           x="CO2 emissions (tonnes per person)", 
           y="Density") +
      scale_x_continuous(expand = c(0, 0)) + 
      scale_y_continuous(expand = c(0, 0))
  })
  # Box Plot
  output$emission_box_output <- renderPlot({
    ggplot(data=all_latest, 
           aes(x=as.factor(score), y=emission_1, group=score)) +
      geom_boxplot(alpha=0.1, color='black', fill='blue') +
      theme_classic() +
      theme(plot.title = element_text(hjust = 0.5))+
      labs(title="CO2 emissions according to polity score", 
           x="Polity Score", 
           y="CO2 emissions (tonnes per person)")
  })
  # 5. Life Expectancy
  #minbox
  output$life_expectancy_minbox <- renderInfoBox({
    min_value <- min(all_latest['life_expectancy_5'],na.rm = TRUE)[1]
    min_country <- 
      min(all_latest$country[all_latest['life_expectancy_5']==min_value], na.rm = T)[1]
    min_score <- 
      min(all_latest$score[all_latest['life_expectancy_5']==min_value], na.rm = T)[1]
    info_title <- paste0(min_country," [", min_score,"]", collapse = "")
    infoBox(title=info_title,
            value= min_value, icon = icon("hand-o-down"))
    
  })
  #maxbox
  output$life_expectancy_maxbox <- renderInfoBox({
    max_value <- max(all_latest['life_expectancy_5'], na.rm = TRUE)[1]
    max_country <- 
      max(all_latest$country[all_latest['life_expectancy_5']==max_value], na.rm = T)[1]
    max_score <- 
      max(all_latest$score[all_latest['life_expectancy_5']==max_value], na.rm = T)[1]
    info_title <- paste0(max_country," [", max_score,"]", collapse = "")
    infoBox(title=info_title,
            value= max_value, icon = icon("hand-o-up"))
    
  })
  # Histogram
  output$life_expectancy_hist_output <- renderPlot({
    ggplot( data=all_latest, aes(x=life_expectancy_1) ) +
      geom_density(alpha=0.1, color='black', fill='blue') +
      theme_classic() +
      theme(plot.title = element_text(hjust = 0.5))+
      labs(title="Life expectancy", 
           x="Life expectancy (years)", 
           y="Density") +
      scale_x_continuous(expand = c(0, 0)) + 
      scale_y_continuous(expand = c(0, 0))
  })
  # Box Plot
  output$life_expectancy_box_output <- renderPlot({
    ggplot(data=all_latest, 
           aes(x=as.factor(score), y=life_expectancy_1, group=score)) +
      geom_boxplot(alpha=0.1, color='black', fill='blue') +
      theme_classic() +
      theme(plot.title = element_text(hjust = 0.5))+
      labs(title="Life expectancy according to polity score", 
           x="Polity Score", 
           y="Life expectancy (years)")
  })
  # 6. Water Access
  #minbox
  output$water_access_minbox <- renderInfoBox({
    min_value <- min(all_latest['water_5'],na.rm = TRUE)[1]
    min_country <- 
      min(all_latest$country[all_latest['water_5']==min_value], na.rm = T)[1]
    min_score <- 
      min(all_latest$score[all_latest['water_5']==min_value], na.rm = T)[1]
    info_title <- paste0(min_country," [", min_score,"]", collapse = "")
    infoBox(title=info_title,
            value= min_value, icon = icon("hand-o-down"))
    
  })
  #maxbox
  output$water_access_maxbox <- renderInfoBox({
    max_value <- max(all_latest['water_5'], na.rm = TRUE)[1]
    max_country <- 
      max(all_latest$country[all_latest['water_5']==max_value], na.rm = T)[1]
    max_score <- 
      max(all_latest$score[all_latest['water_5']==max_value], na.rm = T)[1]
    info_title <- paste0(max_country," [", max_score,"]", collapse = "")
    infoBox(title=info_title,
            value= max_value, icon = icon("hand-o-up"))
    
  })
  # Histogram
  output$water_access_hist_output <- renderPlot({
    ggplot( data=all_latest, aes(x=water_1) ) +
      geom_density(alpha=0.1, color='black', fill='blue') +
      theme_classic() +
      theme(plot.title = element_text(hjust = 0.5))+
      labs(title="Basic Water Services Access", 
           x="Basic water source, overall access (% of pupulation)", 
           y="Density") +
      scale_x_continuous(expand = c(0, 0)) + 
      scale_y_continuous(expand = c(0, 0))
  })
  # Box Plot
  output$water_access_box_output <- renderPlot({
    ggplot(data=all_latest, 
           aes(x=as.factor(score), y=water_1, group=score)) +
      geom_boxplot(alpha=0.1, color='black', fill='blue') +
      theme_classic() +
      theme(plot.title = element_text(hjust = 0.5))+
      labs(title="Basic Water Service according to polity score", 
           x="Polity Score", 
           y="Basic water source, overall access (% of pupulation)")
  })
  # 7. Employment
  #minbox
  output$employment_rate_minbox <- renderInfoBox({
    min_value <- min(all_latest['employment_5'],na.rm = TRUE)[1]
    min_country <- 
      min(all_latest$country[all_latest['employment_5']==min_value], na.rm = T)[1]
    min_score <- 
      min(all_latest$score[all_latest['employment_5']==min_value], na.rm = T)[1]
    info_title <- paste0(min_country," [", min_score,"]", collapse = "")
    infoBox(title=info_title,
            value= min_value, icon = icon("hand-o-down"))
    
  })
  #maxbox
  output$employment_rate_maxbox <- renderInfoBox({
    max_value <- max(all_latest['employment_5'], na.rm = TRUE)[1]
    max_country <- 
      max(all_latest$country[all_latest['employment_5']==max_value], na.rm = T)[1]
    max_score <- 
      max(all_latest$score[all_latest['employment_5']==max_value], na.rm = T)[1]
    info_title <- paste0(max_country," [", max_score,"]", collapse = "")
    infoBox(title=info_title,
            value= max_value, icon = icon("hand-o-up"))
    
  })
  # Histogram
  output$employment_rate_hist_output <- renderPlot({
    ggplot( data=all_latest, aes(x=employment_1) ) +
      geom_density(alpha=0.1, color='black', fill='blue') +
      theme_classic() +
      theme(plot.title = element_text(hjust = 0.5))+
      labs(title="Employment Rate", 
           x="Aged 15+ employment rate (%)", 
           y="Density") +
      scale_x_continuous(expand = c(0, 0)) + 
      scale_y_continuous(expand = c(0, 0))
  })
  # Box Plot
  output$employment_rate_box_output <- renderPlot({
    ggplot(data=all_latest, 
           aes(x=as.factor(score), y=employment_1, group=score)) +
      geom_boxplot(alpha=0.1, color='black', fill='blue') +
      theme_classic() +
      theme(plot.title = element_text(hjust = 0.5))+
      labs(title="Employment Rate according to polity score", 
           x="Polity Score", 
           y="Aged 15+ employment rate (%)")
  })
  # 8. CPI
  #minbox
  output$cpi_minbox <- renderInfoBox({
    min_value <- min(all_latest['cpi_5'],na.rm = TRUE)[1]
    min_country <- 
      min(all_latest$country[all_latest['cpi_5']==min_value], na.rm = T)[1]
    min_score <- 
      min(all_latest$score[all_latest['cpi_5']==min_value], na.rm = T)[1]
    info_title <- paste0(min_country," [", min_score,"]", collapse = "")
    infoBox(title=info_title,
            value= min_value, icon = icon("hand-o-down"))
    
  })
  #maxbox
  output$cpi_maxbox <- renderInfoBox({
    max_value <- max(all_latest['cpi_5'], na.rm = TRUE)[1]
    max_country <- 
      max(all_latest$country[all_latest['cpi_5']==max_value], na.rm = T)[1]
    max_score <- 
      max(all_latest$score[all_latest['cpi_5']==max_value], na.rm = T)[1]
    info_title <- paste0(max_country," [", max_score,"]", collapse = "")
    infoBox(title=info_title,
            value= max_value, icon = icon("hand-o-up"))
    
  })
  # Histogram
  output$cpi_rate_hist_output <- renderPlot({
    ggplot( data=all_latest, aes(x=cpi_1) ) +
      geom_density(alpha=0.1, color='black', fill='blue') +
      theme_classic() +
      theme(plot.title = element_text(hjust = 0.5))+
      labs(title="Corruption Perception Index", 
           x="Corruption Perception Index (CPI)", 
           y="Density") +
      scale_x_continuous(expand = c(0, 0)) + 
      scale_y_continuous(expand = c(0, 0))
  })
  # Box Plot
  output$cpi_rate_box_output <- renderPlot({
    ggplot(data=all_latest, 
           aes(x=as.factor(score), y=cpi_1, group=score)) +
      geom_boxplot(alpha=0.1, color='black', fill='blue') +
      theme_classic() +
      theme(plot.title = element_text(hjust = 0.5))+
      labs(title="CPI according to polity score", 
           x="Polity Score", 
           y="Corruption Perception Index (CPI)")
  })
  # 9.A Autocracy
  output$autocracy_output <- renderPlot({
    ggplot(data = dem_score_latest,  aes(x = long, y = lat, group = group)) +
      geom_polygon(fill="white", colour = "black") +
      geom_polygon(data = filter(dem_score_latest ,
                                 region %in% filter(dem_score_latest, 
                                                    dem_score_latest$dem_sim_score=='Autocracy')$region), 
                   fill='#3c8dbc') +
      theme_classic() +
      theme(plot.title = element_text(hjust = 0.5),
            axis.title=element_blank(),
            axis.text=element_blank(),
            axis.ticks=element_blank(),
            axis.line = element_blank()
      ) +
      labs(title="List of country that are Autocracy [-10 to -6]")
  })
  output$autocracy_table_output <- DT::renderDataTable({
    DT::datatable(data=all_latest[all_latest$dem_sim_score=='Autocracy',] , rownames = FALSE,
                  options = list(scrollX=TRUE))
    
  })
  # 9.B Closed Anocracy
  output$closed_anocracy_output <- renderPlot({
    ggplot(data = dem_score_latest,  aes(x = long, y = lat, group = group)) +
      geom_polygon(fill="white", colour = "black") +
      geom_polygon(data = filter(dem_score_latest ,
                                 region %in% filter(dem_score_latest, 
                                                    dem_score_latest$dem_sim_score=='Closed Anocracy')$region), 
                   fill='#3c8dbc') +
      theme_classic() +
      theme(plot.title = element_text(hjust = 0.5),
            axis.title=element_blank(),
            axis.text=element_blank(),
            axis.ticks=element_blank(),
            axis.line = element_blank()
      ) +
      labs(title="List of country that are Closed Anocracy [-5 to -1]")
  })
  output$closed_autocracy_table_output <- DT::renderDataTable({
    DT::datatable(data=all_latest[all_latest$dem_sim_score=='Closed Anocracy',] , rownames = FALSE,
                  options = list(scrollX=TRUE))
    
  })
  # 9.C Open Anocracy
  output$open_anocracy_output <- renderPlot({
    ggplot(data = dem_score_latest,  aes(x = long, y = lat, group = group)) +
      geom_polygon(fill="white", colour = "black") +
      geom_polygon(data = filter(dem_score_latest ,
                                 region %in% filter(dem_score_latest, 
                                                    dem_score_latest$dem_sim_score=='Open Anocracy')$region), 
                   fill='#3c8dbc') +
      theme_classic() +
      theme(plot.title = element_text(hjust = 0.5),
            axis.title=element_blank(),
            axis.text=element_blank(),
            axis.ticks=element_blank(),
            axis.line = element_blank()
      ) +
      labs(title="List of country that are Open Anocracy [1 to 5]")
  })
  output$open_autocracy_table_output <- DT::renderDataTable({
    DT::datatable(data=all_latest[all_latest$dem_sim_score=='Open Anocracy',] , rownames = FALSE,
                  options = list(scrollX=TRUE))
    
  })
  # 9.D Democracy
  output$democracy_output <- renderPlot({
    ggplot(data = dem_score_latest,  aes(x = long, y = lat, group = group)) +
      geom_polygon(fill="white", colour = "black") +
      geom_polygon(data = filter(dem_score_latest ,
                                 region %in% filter(dem_score_latest, 
                                                    dem_score_latest$dem_sim_score=='Democracy')$region), 
                   fill='#3c8dbc') +
      theme_classic() +
      theme(plot.title = element_text(hjust = 0.5),
            axis.title=element_blank(),
            axis.text=element_blank(),
            axis.ticks=element_blank(),
            axis.line = element_blank()
      ) +
      labs(title="List of country that are Democracy [6 to 9]")
  })
  output$democracy_table_output <- DT::renderDataTable({
    DT::datatable(data=all_latest[all_latest$dem_sim_score=='Democracy',] , rownames = FALSE,
                  options = list(scrollX=TRUE))
    
  })
  # 9.E Full Democracy
  output$full_democracy_output <- renderPlot({
    ggplot(data = dem_score_latest,  aes(x = long, y = lat, group = group)) +
      geom_polygon(fill="white", colour = "black") +
      geom_polygon(data = filter(dem_score_latest ,
                                 region %in% filter(dem_score_latest, 
                                                    dem_score_latest$dem_sim_score=='Full Democracy')$region), 
                   fill='#3c8dbc') +
      theme_classic() +
      theme(plot.title = element_text(hjust = 0.5),
            axis.title=element_blank(),
            axis.text=element_blank(),
            axis.ticks=element_blank(),
            axis.line = element_blank()
      ) +
      labs(title="List of country that are Full Democracy [10]")
  })
  output$full_democracy_table_output <- DT::renderDataTable({
    DT::datatable(data=all_latest[all_latest$dem_sim_score=='Full Democracy',] , rownames = FALSE,
                  options = list(scrollX=TRUE))
    
  })
  # 10.A. Income Compare Plot
  output$income_compare_output <- renderPlot({
    ggplot(data=all_latest_income, 
           aes(x = year_order, y = income, 
               color = dem_sim_score, group = dem_sim_score)) + 
      geom_point() + 
      geom_line() +
      theme_classic() +
      theme(plot.title = element_text(hjust = 0.5))+
      labs(title="Income comparison between countries Democracy levels", 
           x="Year", 
           y="Income per Person in USD per Year",
           color = "Democracy Levels")
  })
  # 10.B. Literacy Compare Plot
  output$literacy_compare_output <- renderPlot({
    ggplot(data=all_latest_literacy, 
           aes(x = year_order, y = literacy, 
               color = dem_sim_score, group = dem_sim_score)) + 
      geom_point() + 
      geom_line() +
      theme_classic() +
      theme(plot.title = element_text(hjust = 0.5))+
      labs(title="Literacy comparison between countries Democracy levels", 
           x="Year", 
           y="Literacy rate, adult total (% of people ages 15 and above)",
           color = "Democracy Levels")
  })
  # 10.C. CO2 Emission Compare Plot
  output$emission_compare_output <- renderPlot({
    ggplot(data=all_latest_emission, 
           aes(x = year_order, y = emission, 
               color = dem_sim_score, group = dem_sim_score)) + 
      geom_point() + 
      geom_line() +
      theme_classic() +
      theme(plot.title = element_text(hjust = 0.5))+
      labs(title="CO2 emission comparison between countries Democracy levels", 
           x="Year", 
           y="CO2 emissions (tonnes per person)",
           color = "Democracy Levels")
  })
  # 10.D. Life Expetancy Compare Plot
  output$life_expectancy_compare_output <- renderPlot({
    ggplot(data=all_latest_life_expectancy, 
           aes(x = year_order, y = life_expectancy, 
               color = dem_sim_score, group = dem_sim_score)) + 
      geom_point() + 
      geom_line() +
      theme_classic() +
      theme(plot.title = element_text(hjust = 0.5))+
      labs(title="Life expectancy comparison between countries Democracy levels", 
           x="Year", 
           y="Life expectancy (years)",
           color = "Democracy Levels")
  })
  # 10.E. Water Access Compare Plot
  output$water_compare_output <- renderPlot({
    ggplot(data=all_latest_water, 
           aes(x = year_order, y = water, 
               color = dem_sim_score, group = dem_sim_score)) + 
      geom_point() + 
      geom_line() +
      theme_classic() +
      theme(plot.title = element_text(hjust = 0.5))+
      labs(title="Water access comparison between countries Democracy levels", 
           x="Year", 
           y="Basic water source, overall access (% of pupulation)",
           color = "Democracy Levels")
  })
  # 10.F. Employment Compare Plot
  output$employment_compare_output <- renderPlot({
    ggplot(data=all_latest_employment, 
           aes(x = year_order, y = employment, 
               color = dem_sim_score, group = dem_sim_score)) + 
      geom_point() + 
      geom_line() +
      theme_classic() +
      theme(plot.title = element_text(hjust = 0.5))+
      labs(title="Employment comparison between countries Democracy levels", 
           x="Year", 
           y="Aged 15+ employment rate (%)",
           color = "Democracy Levels")
  })
  # 10.G. CPI Compare Plot
  output$cpi_compare_output <- renderPlot({
    ggplot(data=all_latest_cpi, 
           aes(x = year_order, y = cpi, 
               color = dem_sim_score, group = dem_sim_score)) + 
      geom_point() + 
      geom_line() +
      theme_classic() +
      theme(plot.title = element_text(hjust = 0.5))+
      labs(title="CPI comparison between countries Democracy levels", 
           x="Year", 
           y="Corruption Perception Index (CPI)",
           color = "Democracy Levels")
  })
  # 11. show data using DataTable
  output$data_table_output <- DT::renderDataTable({
    DT::datatable(data=all_latest , rownames = FALSE,
                  options = list(scrollX=TRUE))
    
  })
})