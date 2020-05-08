library(ggplot2)
library(tidyverse)
library(shiny)
library(shinydashboard)

shinyServer(function(input, output){
  
  # 1. show data using DataTable
  output$data_table_output <- DT::renderDataTable({
    DT::datatable(data=steam_action, rownames = FALSE,
                  options = list(scrollX=TRUE))
    
  })
  # 2A. Year Analysis (How many Games created Year)
  output$year_analysis_output <- renderPlot({
    ggplot(data=steam_action[ !is.na(steam_action$release_date), ] %>% mutate(., year_col = format(release_date, '%Y' ) ) %>% 
             group_by(.,year_col) %>% summarise(., total=n()), aes(x=year_col, y=total)) +
      geom_bar(stat='identity', alpha=0.1, color='black', fill='blue') +
      theme_classic() +
      theme(plot.title = element_text(hjust = 0.5),
            axis.text.x = element_text(angle = 90, hjust = 1))+
      labs(title="Game Created by Year", 
           x="Year", 
           y="Game Total")
  })
  # 2B. Month Analysis (How many Games created Month)
  output$month_analysis_output <- renderPlot({
    ggplot(data=steam_action[ !is.na(steam_action$release_date), ] %>% mutate(., month_col = format(release_date, '%B' ) ) %>% 
             group_by(.,month_col) %>% summarise(., total=n()), aes(x=factor(month_col, month.name), y=total)) +
      geom_bar(stat='identity', alpha=0.1, color='black', fill='blue') +
      theme_classic() +
      theme(plot.title = element_text(hjust = 0.5),
            axis.text.x = element_text(angle = 90, hjust = 1))+
      labs(title="Game Created by Month", 
           x="Month", 
           y="Game Total")
  })
  # 3A. Review  by Category
  output$review_category_output <- renderPlot({
    ggplot( ) + 
      geom_bar(data = within(steam_action[ !is.na(steam_action$all_review_cat), ],
                             all_review_cat<-factor(all_review_cat, levels = names( sort(table(all_review_cat), decreasing=TRUE )))) ,
               aes(x=all_review_cat, y=(..count..)/sum(..count..)),
               alpha=0.1, color='black', fill='blue', position = position_stack(reverse = TRUE)) +
      theme_classic() +
      theme(plot.title = element_text(hjust = 0.5),
            axis.text.x = element_text(angle = 90, hjust = 1))+
      labs(title="Player Review as Category", 
           x="Review Category", 
           y="Percentage")
    
  })
  # 3B. Violence in Game
  # Bar Plot
  output$violence_game_output <- renderPlot({
    ggplot() +
      geom_bar( data=steam_action[ !is.na(steam_action$has_violence), ] %>% 
                  group_by(., has_violence) %>% summarise(.,freq=n()/dim(.)[1]),
                aes(x=has_violence, y=freq), stat = 'identity', alpha=0.1, color='black', fill='blue') +
      theme_classic() +
      theme(plot.title = element_text(hjust = 0.5),
            axis.text.x = element_text(angle = 0, hjust = 0.5))+
      scale_x_discrete(labels = c('NO','YES'))+
      labs(title="Proposition of Violence", 
           x="Has Violence", 
           y="Frequencies")
  })
  # Bar Plot (category)
  output$violence_game_review_output <- renderPlot({
    ggplot() +
      geom_bar(data=within(steam_action[ !is.na(steam_action$all_review_cat), ],
                           all_review_cat<-factor(all_review_cat, levels = c("Mostly Negative", "Mixed", "Mostly Positive", 
                                                                             "Positive", "Very Positive", "Overwhelmingly Positive") )) %>% 
                 group_by(.,has_violence, all_review_cat) %>% summarise(., total=n()) %>% 
                 group_by(.,has_violence) %>% mutate(.,perc=total/sum(total)), 
               aes(x=has_violence, y=perc, fill=all_review_cat), stat="identity", position = "dodge") +
      theme_classic() +
      theme(plot.title = element_text(hjust = 0.5),
            axis.text.x = element_text(angle = 0, hjust = 0.5)) +
      scale_x_discrete(labels = c('NO', 'YES')) +
      scale_y_continuous(breaks = seq(0,1,0.1) ) +
      scale_fill_manual(name= "Review Category", values = c(c(alpha("blue", 0.1)), c(alpha("blue", 0.2)),
                                                            c(alpha("blue", 0.3)), c(alpha("blue", 0.4)), 
                                                            c(alpha("blue", 0.5)), c(alpha("blue", 0.6)))) +
      labs(title="Review Grouped with Violence", 
           x="Has Violence", 
           y="Percentage")
  })
  # 3C. Discount by Category
  output$discount_by_category_output <- renderPlot({
    ggplot() +
      geom_bar( data = 
                  steam_action[ !is.na(steam_action$all_review_cat), ] %>% 
                  mutate(., is_discount = !is.na(discount_percentage)) %>% 
                  group_by(., all_review_cat) %>% 
                  mutate(., count_cat = n()) %>% 
                  group_by(., all_review_cat, is_discount) %>% 
                  mutate(., count_disc_cat = n(), freq_count_disc_cat=count_disc_cat/count_cat) %>% 
                  select(., c('all_review_cat','is_discount','count_cat', 'count_disc_cat', 'freq_count_disc_cat')),
                aes(x=is_discount, y=freq_count_disc_cat, group=is_discount, fill=is_discount),
                stat='identity', position='dodge', width=0.5
      ) +
      facet_grid(. ~ all_review_cat) +
      theme_classic() +
      theme(plot.title = element_text(hjust = 0.5),
            axis.text.x = element_text(angle = 90, hjust = 0.5))+
      scale_x_discrete(labels = c('NO','YES')) +
      scale_y_continuous(breaks = seq(0,1,.1) ) +
      scale_fill_manual(name= "Has Discount", labels=c('NO', 'YES'),
                        values = c('#898BE4','#0508EE' )) +
      labs(title="Proportion of Discount", 
           x="Has Discount", 
           y="Frequencies")
  })
  # 3D. Free vs Paid
  output$free_paid_output <- renderPlot({
    ggplot() +
      geom_bar(data=within(steam_action[ !is.na(steam_action$all_review_cat), ],
                           all_review_cat<-factor(all_review_cat, levels = c("Mostly Negative", "Mixed", "Mostly Positive", "Positive", "Very Positive", "Overwhelmingly Positive") )) %>% 
                 mutate(., final_price = ifelse(test = is.na(price_original), yes = price_discount, no = price_original) ) %>% 
                 mutate(., is_free = ifelse(test=final_price==0, yes=TRUE,no=FALSE)) %>% 
                 filter(., !is.na(is_free)) %>% 
                 group_by(.,is_free, all_review_cat) %>% summarise(., total=n()) %>% 
                 group_by(.,is_free) %>% mutate(.,perc=total/sum(total)), 
               aes(x=is_free, y=perc, fill=all_review_cat), stat="identity", position = "dodge") +
      theme_classic() +
      theme(plot.title = element_text(hjust = 0.5),
            axis.text.x = element_text(angle = 0, hjust = 0.5)) +
      scale_x_discrete(labels = c('NO', 'YES')) +
      scale_y_continuous(breaks = seq(0,1,.05) ) +
      scale_fill_manual(name= "Review Category", values = c(c(alpha("blue", 0.1)), c(alpha("blue", 0.2)),
                                                            c(alpha("blue", 0.3)), c(alpha("blue", 0.4)), 
                                                            c(alpha("blue", 0.5)), c(alpha("blue", 0.6)))) +
      labs(title="Review Grouped with Paid/Free Games", 
           x="Is Free", 
           y="Percentage")
    
  })
  # 3D. Player Type (Review grouped with Player Type)
  output$player_type_output <- renderPlot({
    ggplot() +
      geom_bar(data=within(steam_action[ !is.na(steam_action$all_review_cat) & !is.na(steam_action$player_type), ],
                           all_review_cat<-factor(all_review_cat, levels = c("Mostly Negative", "Mixed", "Mostly Positive", 
                                                                             "Positive", "Very Positive", "Overwhelmingly Positive") )) %>% 
                 group_by(.,player_type, all_review_cat) %>% summarise(., total=n()) %>% 
                 group_by(.,player_type) %>% mutate(.,perc=total/sum(total)), 
               aes(x=player_type, y=perc, fill=all_review_cat), stat="identity", position = "dodge") +
      theme_classic() +
      theme(plot.title = element_text(hjust = 0.5),
            axis.text.x = element_text(angle = 0, hjust = 0.5)) +
      scale_x_discrete(labels = c('multi-player', 'single-palyer')) +
      scale_y_continuous(breaks = seq(0,1,0.1) ) +
      scale_fill_manual(name= "Review Category", values = c(c(alpha("blue", 0.1)), c(alpha("blue", 0.2)),
                                                            c(alpha("blue", 0.3)), c(alpha("blue", 0.4)), 
                                                            c(alpha("blue", 0.5)), c(alpha("blue", 0.6)))) +
      labs(title="Review Grouped with Player Type", 
           x="Player Type", 
           y="Percentage")
    
  })
  # 3F. Game Publisher (Review category as per game publisher)
  output$game_publisher_output <- renderPlot({
    ggplot(data=
             within(steam_action %>% filter(.,game_publisher %in% c(steam_action %>% 
                                                                      filter(.,!is.na(game_publisher), !is.na(all_review_cat)) %>% 
                                                                      group_by(., game_publisher) %>% 
                                                                      summarise(., total=n()) %>% 
                                                                      filter(., total>30) %>% 
                                                                      select(., game_publisher) )[[1]] ),
                    all_review_cat<-factor(all_review_cat, levels = c("Mostly Negative", "Mixed", "Mostly Positive", 
                                                                      "Positive", "Very Positive", "Overwhelmingly Positive") )
             ) %>% 
             filter(.,!is.na(all_review_cat)) %>% 
             group_by(.,game_publisher, all_review_cat) %>% 
             summarise(n=n()) %>% 
             group_by(game_publisher) %>% 
             mutate(perc=n/sum(n)),
           aes(x=all_review_cat, y=perc, group=all_review_cat, fill=all_review_cat), position='dodge') +
      geom_bar(stat='identity') +
      facet_wrap( ~ game_publisher,nrow=5 )+
      theme_classic() +
      theme(plot.title = element_text(hjust = 0.5),
            axis.text.x = element_text(angle = 90, hjust = 0.5)) +
      scale_fill_manual(name= "Review Category", values = c(c(alpha("blue", 0.1)), c(alpha("blue", 0.2)),
                                                            c(alpha("blue", 0.3)), c(alpha("blue", 0.4)), 
                                                            c(alpha("blue", 0.5)), c(alpha("blue", 0.6)))) +
      labs(title="Review as pre Game Publisher", 
           x="Reviews Category", 
           y="Frequency")
  })
  # 3G. Review Category by Game (Review Category Grouped by Genre)
  output$review_category_genre_output <- renderPlot({
    ggplot()+
      geom_bar(data=within(genre_review_cat[!is.na(genre_review_cat$value), c('variable','value')] %>% 
                             group_by(variable,value) %>% summarise(n=n()) %>% group_by(variable) %>% 
                             mutate(perc=n/sum(n)),
                           value<-factor(value, levels = c("Mostly Negative", "Mixed", "Mostly Positive", 
                                                           "Positive", "Very Positive", "Overwhelmingly Positive") )
      ),
      aes(x=value, y=perc, fill=value), stat='identity') +
      facet_wrap(~variable) +
      theme_classic() +
      theme(plot.title = element_text(hjust = 0.5),
            axis.text.x = element_text(angle = 90, hjust = 0.5)) +
      scale_x_discrete( expand=c(0,0)) +
      scale_y_continuous(expand = c(0,0)) +
      scale_fill_manual(name= "Review Category", values = c(c(alpha("blue", 0.1)), c(alpha("blue", 0.2)),
                                                            c(alpha("blue", 0.3)), c(alpha("blue", 0.4)), 
                                                            c(alpha("blue", 0.5)), c(alpha("blue", 0.6))))+
      labs(title="Review Category Grouped by Genre", 
           x="Genre", 
           y="Percentage")
  })
  #4A. Purchase Analysis
  #minbox
  output$steam_purchase_minbox <- renderInfoBox({
    min_value<-min(steam_action$purchase_steam[steam_action$purchase_steam!=0], na.rm = T)
    min_game<-min(steam_action$game_title[steam_action['purchase_steam']==min_value], na.rm = T)[1]
    infoBox(title=min_game,
            value= min_value, icon = icon("hand-o-down"))
    
  })
  #maxbox
  output$steam_purchase_maxbox <- renderInfoBox({
    max_value<-max(steam_action$purchase_steam[steam_action$purchase_steam!=0], na.rm = T)
    max_game<-max(steam_action$game_title[steam_action['purchase_steam']==max_value], na.rm = T)[1]
    infoBox(title=max_game,
            value= max_value, icon = icon("hand-o-up"))
    
  })
  # Histogram
  output$steam_purchase_hist_output <- renderPlot({
    ggplot() +
      geom_density(data=steam_action[!is.na(steam_action$purchase_steam),],
                   aes(x=log10(purchase_steam)), fill='blue', alpha=0.1) +
      theme_classic() +
      theme(plot.title = element_text(hjust = 0.5),
            axis.text.x = element_text(angle = 90, hjust = 0.5)) +
      scale_x_continuous( expand=c(0,0), breaks=seq(0,10000,1) ) +
      scale_y_continuous(expand = c(0,0)) +
      labs(title="Distribution of Steam Purchase of Game", 
           x="Purchase (log10)", 
           y="Density")
    
  })
  # Box Plot
  output$steam_purchase_box_output <- renderPlot({
    ggplot() +
      geom_boxplot(data=within(steam_action[!is.na(steam_action$all_review_cat) & !is.na(steam_action$purchase_steam),],
                               all_review_cat<-factor(all_review_cat, levels = c("Mostly Negative", "Mixed", "Mostly Positive", "Positive", "Very Positive", "Overwhelmingly Positive") )),
                   aes(x=all_review_cat, y=log(purchase_steam,base=2), group=all_review_cat),
                   alpha=0.1, color='black', fill='blue') +
      theme_classic() +
      theme(plot.title = element_text(hjust = 0.5),
            axis.text.x = element_text(angle = 90, hjust = 0.5)) +
      scale_y_continuous(expand = c(0,0), breaks=seq(0,log(10000000,base=2),1)) +
      #coord_cartesian(ylim = boxplot.stats(steam_action$price_original)$stats[c(1, 5)]*1000) +
      labs(title="Distribution of Steam Purchase According to Review Category", 
           x="Review Category", y="Steam Purchase(log2)")
  })
  
  #4B. All Review Analysis
  #minbox
  output$all_review_minbox <- renderInfoBox({
    min_value<-min(steam_action$review_all[steam_action$review_all!=0], na.rm = T)
    min_game<-min(steam_action$game_title[steam_action['review_all']==min_value], na.rm = T)[1]
    infoBox(title=min_game,
            value= min_value, icon = icon("hand-o-down"))
    
  })
  #maxbox
  output$all_review_maxbox <- renderInfoBox({
    max_value<-max(steam_action$review_all[steam_action$review_all!=0], na.rm = T)
    max_game<-max(steam_action$game_title[steam_action['review_all']==max_value], na.rm = T)[1]
    infoBox(title=max_game,
            value= max_value, icon = icon("hand-o-up"))
    
  })
  # Histogram
  output$all_review_hist_output <- renderPlot({
    ggplot() +
      geom_density(data=steam_action[!is.na(steam_action$review_all),],
                   aes(x=log10(review_all)), fill='blue', alpha=0.1) +
      theme_classic() +
      theme(plot.title = element_text(hjust = 0.5),
            axis.text.x = element_text(angle = 90, hjust = 0.5)) +
      scale_x_continuous( expand=c(0,0), breaks=seq(0,10000,1) ) +
      scale_y_continuous(expand = c(0,0)) +
      labs(title="Distribution of All Review of Game", 
           x="Review (log10)", 
           y="Density")
    
  })
  # Box Plot
  output$all_review_box_output <- renderPlot({
    ggplot() +
      geom_boxplot(data=within(steam_action[!is.na(steam_action$all_review_cat) & !is.na(steam_action$review_all),],
                               all_review_cat<-factor(all_review_cat, levels = c("Mostly Negative", "Mixed", "Mostly Positive", "Positive", "Very Positive", "Overwhelmingly Positive") )),
                   aes(x=all_review_cat, y=log(review_all,base=2), group=all_review_cat),
                   alpha=0.1, color='black', fill='blue') +
      theme_classic() +
      theme(plot.title = element_text(hjust = 0.5),
            axis.text.x = element_text(angle = 90, hjust = 0.5)) +
      #scale_y_continuous(expand = c(0,0), breaks = 2^(0:10)) +
      scale_y_continuous(expand = c(0,0), breaks=seq(0,log(10000000,base=2),1)) +
      #coord_cartesian(ylim = boxplot.stats(steam_action$price_original)$stats[c(1, 5)]*1000) +
      labs(title="Distribution of All Review According to Review Category", 
           x="Review Category", y="All Review(log2)")
  })
  
  #4C. Positive Review Analysis
  #minbox
  output$positive_review_minbox <- renderInfoBox({
    min_value<-min(steam_action$review_positive[steam_action$review_positive!=0], na.rm = T)
    min_game<-min(steam_action$game_title[steam_action['review_positive']==min_value], na.rm = T)[1]
    infoBox(title=min_game,
            value= min_value, icon = icon("hand-o-down"))
    
  })
  #maxbox
  output$positive_review_maxbox <- renderInfoBox({
    max_value<-max(steam_action$review_positive[steam_action$review_positive!=0], na.rm = T)
    max_game<-max(steam_action$game_title[steam_action['review_positive']==max_value], na.rm = T)[1]
    infoBox(title=max_game,
            value= max_value, icon = icon("hand-o-up"))
    
  })
  # Histogram
  output$positive_review_hist_output <- renderPlot({
    ggplot() +
      geom_density(data=steam_action[!is.na(steam_action$review_positive),],
                   aes(x=log10(review_positive)), fill='blue', alpha=0.1) +
      theme_classic() +
      theme(plot.title = element_text(hjust = 0.5),
            axis.text.x = element_text(angle = 90, hjust = 0.5)) +
      scale_x_continuous( expand=c(0,0), breaks=seq(0,10000,1) ) +
      scale_y_continuous(expand = c(0,0)) +
      labs(title="Distribution of Positive Review of Game", 
           x="Review (log10)", 
           y="Density")
    
  })
  # Box Plot
  output$positive_review_box_output <- renderPlot({
    ggplot() +
      geom_boxplot(data=within(steam_action[!is.na(steam_action$all_review_cat) & !is.na(steam_action$review_positive),],
                               all_review_cat<-factor(all_review_cat, levels = c("Mostly Negative", "Mixed", "Mostly Positive", "Positive", "Very Positive", "Overwhelmingly Positive") )),
                   aes(x=all_review_cat, y=log(review_positive,base=2), group=all_review_cat),
                   alpha=0.1, color='black', fill='blue') +
      theme_classic() +
      theme(plot.title = element_text(hjust = 0.5),
            axis.text.x = element_text(angle = 90, hjust = 0.5)) +
      #scale_y_continuous(expand = c(0,0), breaks = 2^(0:10)) +
      scale_y_continuous(expand = c(0,0), breaks=seq(0,log(10000000,base=2),1)) +
      #coord_cartesian(ylim = boxplot.stats(steam_action$price_original)$stats[c(1, 5)]*1000) +
      labs(title="Distribution of Review Positive According to Review Category", 
           x="Review Category", y="Review Positive(log2)")
  })
  
  #4C. Negative Review Analysis
  #minbox
  output$negative_review_minbox <- renderInfoBox({
    min_value<-min(steam_action$review_negative[steam_action$review_negative!=0], na.rm = T)
    min_game<-min(steam_action$game_title[steam_action['review_negative']==min_value], na.rm = T)[1]
    infoBox(title=min_game,
            value= min_value, icon = icon("hand-o-down"))
    
  })
  #maxbox
  output$negative_review_maxbox <- renderInfoBox({
    max_value<-max(steam_action$review_negative[steam_action$review_negative!=0], na.rm = T)
    max_game<-max(steam_action$game_title[steam_action['review_negative']==max_value], na.rm = T)[1]
    infoBox(title=max_game,
            value= max_value, icon = icon("hand-o-up"))
    
  })
  # Histogram
  output$negative_review_hist_output <- renderPlot({
    ggplot() +
      geom_density(data=steam_action[!is.na(steam_action$review_negative),],
                   aes(x=log10(review_negative)), fill='blue', alpha=0.1) +
      theme_classic() +
      theme(plot.title = element_text(hjust = 0.5),
            axis.text.x = element_text(angle = 90, hjust = 0.5)) +
      scale_x_continuous( expand=c(0,0), breaks=seq(0,10000,1) ) +
      scale_y_continuous(expand = c(0,0)) +
      labs(title="Distribution of Negative Review of Game", 
           x="Review (log10)", 
           y="Density")
    
  })
  # Box Plot
  output$negative_review_box_output <- renderPlot({
    ggplot() +
      geom_boxplot(data=within(steam_action[!is.na(steam_action$all_review_cat) & !is.na(steam_action$review_negative),],
                               all_review_cat<-factor(all_review_cat, levels = c("Mostly Negative", "Mixed", "Mostly Positive", "Positive", "Very Positive", "Overwhelmingly Positive") )),
                   aes(x=all_review_cat, y=log(review_negative,base=2), group=all_review_cat),
                   alpha=0.1, color='black', fill='blue') +
      theme_classic() +
      theme(plot.title = element_text(hjust = 0.5),
            axis.text.x = element_text(angle = 90, hjust = 0.5)) +
      #scale_y_continuous(expand = c(0,0), breaks = 2^(0:10)) +
      scale_y_continuous(expand = c(0,0), breaks=seq(0,log(10000000,base=2),1)) +
      #coord_cartesian(ylim = boxplot.stats(steam_action$price_original)$stats[c(1, 5)]*1000) +
      labs(title="Distribution of Review Negative According to Review Category", 
           x="Review Category", y="Review Negative(log2)")
  })
  
  # 5A.Year vs Price
  output$year_avg_price_output <- renderPlot({
    ggplot() +
      geom_line( data = 
                   steam_action %>% select(., c('release_date', 'price_original', 'price_discount')) %>% 
                   mutate(., final_price = ifelse(test = is.na(price_original), yes = price_discount, 
                                                  no = price_original) ) %>% select(., c('release_date', 'final_price')) %>% 
                   arrange(., release_date) %>% filter(., !is.na(final_price), final_price != 0, !is.na(release_date) ) %>% mutate(., release_year = format(release_date,"%Y")) %>% 
                   group_by(., release_year) %>% summarise(., avg_final_price = sum(final_price)/n()),
                 aes(x=release_year, y=avg_final_price, group=1), color = 'blue'
                 
      ) +
      theme_classic() +
      theme(plot.title = element_text(hjust = 0.5),
            axis.text.x = element_text(angle = 90, hjust = 1))+
      labs(title="Year vs Average Price", 
           x="Year", 
           y="Average Price")
    
  })
  # 5B. Original Price
  #minbox
  output$original_price_minbox <- renderInfoBox({
    min_value<-min(steam_action$price_original[steam_action$price_original!=0], na.rm = T)
    min_game<-min(steam_action$game_title[steam_action['price_original']==min_value], na.rm = T)[1]
    infoBox(title=min_game,
            value= min_value, icon = icon("hand-o-down"))
    
  })
  #maxbox
  output$original_price_maxbox <- renderInfoBox({
    max_value<-max(steam_action$price_original[steam_action$price_original!=0], na.rm = T)
    max_game<-max(steam_action$game_title[steam_action['price_original']==max_value], na.rm = T)[1]
    infoBox(title=max_game,
            value= max_value, icon = icon("hand-o-up"))
    
  })
  # Histogram
  output$original_price_hist_output <- renderPlot({
    ggplot() +
      geom_density(data=steam_action[!is.na(steam_action$price_original),],
                   aes(x=price_original), fill='blue', alpha=0.1) +
      theme_classic() +
      theme(plot.title = element_text(hjust = 0.5),
            axis.text.x = element_text(angle = 90, hjust = 0.5)) +
      scale_x_continuous( expand=c(0,0), breaks=seq(0,10000,10) ) +
      scale_y_continuous(expand = c(0,0)) +
      labs(title="Distribution of Original Price", 
           x="Original Price(USD)", 
           y="Density")
    
  })
  # Box Plot
  output$original_price_box_output <- renderPlot({
    ggplot() +
      geom_boxplot(data=within(steam_action[!is.na(steam_action$all_review_cat) & !is.na(steam_action$price_original),],
                               all_review_cat<-factor(all_review_cat, levels = c("Mostly Negative", "Mixed", "Mostly Positive", "Positive", "Very Positive", "Overwhelmingly Positive") )),
                   aes(x=all_review_cat, y=price_original, group=all_review_cat),
                   alpha=0.1, color='black', fill='blue') +
      theme_classic() +
      theme(plot.title = element_text(hjust = 0.5),
            axis.text.x = element_text(angle = 90, hjust = 0.5)) +
      coord_cartesian(ylim = boxplot.stats(steam_action$price_original)$stats[c(1, 5)]*1.5) +
      labs(title="Distribution of Original Price According to Review Category", 
           x="Review Category", y="Original Price of Game(USD)")
  })
  # 5B. Price before Original
  #minbox
  output$price_before_discount_minbox <- renderInfoBox({
    min_value<-min(steam_action$price_original_before_discount[steam_action$price_original_before_discount!=0], na.rm = T)
    min_game<-min(steam_action$game_title[steam_action['price_original_before_discount']==min_value], na.rm = T)[1]
    infoBox(title=min_game,
            value= min_value, icon = icon("hand-o-down"))
    
  })
  #maxbox
  output$price_before_discount_maxbox <- renderInfoBox({
    max_value<-max(steam_action$price_original_before_discount[steam_action$price_original_before_discount!=0], na.rm = T)
    max_game<-max(steam_action$game_title[steam_action['price_original_before_discount']==max_value], na.rm = T)[1]
    infoBox(title=max_game,
            value= max_value, icon = icon("hand-o-up"))
    
  })
  # Histogram
  output$price_before_discount_hist_output <- renderPlot({
    ggplot() +
      geom_density(data=steam_action[!is.na(steam_action$price_original_before_discount),],
                   aes(x=price_original_before_discount), fill='blue', alpha=0.1) +
      theme_classic() +
      theme(plot.title = element_text(hjust = 0.5),
            axis.text.x = element_text(angle = 90, hjust = 0.5)) +
      scale_x_continuous( expand=c(0,0), breaks=seq(0,10000,10) ) +
      scale_y_continuous(expand = c(0,0)) +
      labs(title="Distribution of Price before Discount", 
           x="Price before Discount(USD)", 
           y="Density")
    
  })
  # Box Plot
  output$price_before_discount_box_output <- renderPlot({
    ggplot() +
      geom_boxplot(data=within(steam_action[!is.na(steam_action$all_review_cat) & !is.na(steam_action$price_original_before_discount),],
                               all_review_cat<-factor(all_review_cat, levels = c("Mostly Negative", "Mixed", "Mostly Positive", "Positive", "Very Positive", "Overwhelmingly Positive") )),
                   aes(x=all_review_cat, y=price_original_before_discount, group=all_review_cat),
                   alpha=0.1, color='black', fill='blue') +
      theme_classic() +
      theme(plot.title = element_text(hjust = 0.5),
            axis.text.x = element_text(angle = 90, hjust = 0.5)) +
      coord_cartesian(ylim = boxplot.stats(steam_action$price_original_before_discount)$stats[c(1, 5)]*1.5) +
      labs(title="Distribution of Price before Discount According to Review Category", 
           x="Review Category", y="Price before Discount of Game(USD)")
  })
  # 5B. Price after Original
  #minbox
  output$price_after_discount_minbox <- renderInfoBox({
    min_value<-min(steam_action$price_discount[steam_action$price_discount!=0], na.rm = T)
    min_game<-min(steam_action$game_title[steam_action['price_discount']==min_value], na.rm = T)[1]
    infoBox(title=min_game,
            value= min_value, icon = icon("hand-o-down"))
    
  })
  #maxbox
  output$price_after_discount_maxbox <- renderInfoBox({
    max_value<-max(steam_action$price_discount[steam_action$price_discount!=0], na.rm = T)
    max_game<-max(steam_action$game_title[steam_action['price_discount']==max_value], na.rm = T)[1]
    infoBox(title=max_game,
            value= max_value, icon = icon("hand-o-up"))
    
  })
  # Histogram
  output$price_after_discount_hist_output <- renderPlot({
    ggplot() +
      geom_density(data=steam_action[!is.na(steam_action$price_discount),],
                   aes(x=price_discount), fill='blue', alpha=0.1) +
      theme_classic() +
      theme(plot.title = element_text(hjust = 0.5),
            axis.text.x = element_text(angle = 90, hjust = 0.5)) +
      scale_x_continuous( expand=c(0,0), breaks=seq(0,10000,10) ) +
      scale_y_continuous(expand = c(0,0)) +
      labs(title="Distribution of Price after Discount", 
           x="Price after Discount(USD)", 
           y="Density")
    
  })
  # Box Plot
  output$price_after_discount_box_output <- renderPlot({
    ggplot() +
      geom_boxplot(data=within(steam_action[!is.na(steam_action$all_review_cat) & !is.na(steam_action$price_discount),],
                               all_review_cat<-factor(all_review_cat, levels = c("Mostly Negative", "Mixed", "Mostly Positive", "Positive", "Very Positive", "Overwhelmingly Positive") )),
                   aes(x=all_review_cat, y=price_discount, group=all_review_cat),
                   alpha=0.1, color='black', fill='blue') +
      theme_classic() +
      theme(plot.title = element_text(hjust = 0.5),
            axis.text.x = element_text(angle = 90, hjust = 0.5)) +
      coord_cartesian(ylim = boxplot.stats(steam_action$price_discount)$stats[c(1, 5)]*1.5) +
      labs(title="Distribution of Price after Discount According to Review Category", 
           x="Review Category", y="Price after Discount of Game(USD)")
  })
  # 5E. Price distribution by Genre
  output$price_dist_by_genre_output <- renderPlot({
    ggplot( data=calc_dist_price)+
      geom_density(aes(x=log10(value)), fill='blue', alpha=0.1) +
      facet_wrap(~variable)+
      theme_classic() +
      theme(plot.title = element_text(hjust = 0.5),
            axis.text.x = element_text(angle = 90, hjust = 0.5)) +
      scale_x_discrete( expand=c(0,0)) +
      scale_y_continuous(expand = c(0,0), seq(-1,1,0.1)) +
      labs(title="Price Distribution Grouped by Genre", 
           x="Genre", 
           y="Density")
  })
  # 5F. Price distribution by Genre
  output$price_by_genre_output <- renderPlot({
    ggplot()+
      geom_bar(data=calc_avg_price, aes(x=genre, y=price_average), 
               stat='identity', fill='blue', color='black', alpha=0.1) +
      geom_hline(yintercept = mean(steam_action$price_original,na.rm = T), color="blue") +
      theme_classic() +
      theme(plot.title = element_text(hjust = 0.5),
            axis.text.x = element_text(angle = 90, hjust = 0.5)) +
      scale_x_discrete( expand=c(0,0)) +
      scale_y_continuous(expand = c(0,0), seq(0,10,1)) +
      labs(title="Average Price by Genre", 
           x="Genre", 
           y="Average Price")
  })
  # 6A. Memory vs Median Price
  output$memory_median_price_output <- renderPlot({
    ggplot() +
      geom_line( data = 
                   steam_action %>% select(., c('memory', 'price_original', 'price_discount')) %>% 
                   mutate(., final_price = ifelse(test = is.na(memory), yes = price_discount, 
                                                  no = price_original) ) %>% select(., c('memory', 'final_price')) %>% 
                   arrange(., memory) %>% filter(., !is.na(final_price), final_price != 0, !is.na(memory) ) %>%  
                   group_by(., memory) %>% 
                   summarise(., median_final_price = median(final_price)),
                 aes(x=memory, y=median_final_price, group=1), color = 'blue'
                 
      ) +
      theme_classic() +
      theme(plot.title = element_text(hjust = 0.5),
            axis.text.x = element_text(angle = 90, hjust = 1))+
      labs(title="Memory vs Median Price", 
           x="Memory", 
           y="Median Price")
  })
  # 6B. Memory Distribution
  #minbox
  output$memory_distribution_minbox <- renderInfoBox({
    min_value<-min(steam_action$memory[steam_action$memory!=0], na.rm = T)
    min_game<-min(steam_action$game_title[steam_action['memory']==min_value], na.rm = T)[1]
    infoBox(title=min_game,
            value= min_value, icon = icon("hand-o-down"))
    
  })
  #maxbox
  output$memory_distribution_maxbox <- renderInfoBox({
    max_value<-max(steam_action$memory[steam_action$memory!=0], na.rm = T)
    max_game<-max(steam_action$game_title[steam_action['memory']==max_value], na.rm = T)[1]
    infoBox(title=max_game,
            value= max_value, icon = icon("hand-o-up"))
    
  })
  # Histogram
  output$memory_distribution_hist_output <- renderPlot({
    ggplot() +
      geom_density(data=steam_action[!is.na(steam_action$memory),],
                   aes(x=memory), fill='blue', alpha=0.1) +
      theme_classic() +
      theme(plot.title = element_text(hjust = 0.5),
            axis.text.x = element_text(angle = 90, hjust = 0.5)) +
      scale_x_continuous( expand=c(0,0), breaks=seq(0,10000,10) ) +
      scale_y_continuous(expand = c(0,0)) +
      labs(title="Distribution of Memory", 
           x="Memory(GB)", 
           y="Density")
    
  })
  # Box Plot
  output$memory_distribution_box_output <- renderPlot({
    ggplot() +
      geom_boxplot(data=dplyr::bind_rows(
        steam_action %>% select(., c('game_title','memory','os_list_windows')) %>% 
          filter(., os_list_windows==1) %>% mutate(., os_list='windows') %>% 
          select(., c('game_title','memory','os_list')),
        steam_action %>% select(., c('game_title','memory','os_list_linux')) %>% 
          filter(., os_list_linux==1) %>% mutate(., os_list='linux') %>% 
          select(., c('game_title','memory','os_list')),
        steam_action %>% select(., c('game_title','memory','os_list_mac')) %>% 
          filter(., os_list_mac==1) %>% mutate(., os_list='mac') %>% 
          select(., c('game_title','memory','os_list'))
      ),
      aes(x=factor(os_list), y=memory, group=factor(os_list)),
      alpha=0.1, color='black', fill='blue') +
      stat_summary(data=mean_os,fun.y=mean, geom="point", shape=20, size=2, color="blue", fill="blue", aes(x=factor(os_list), y=memory)) +
      theme_classic() +
      theme(plot.title = element_text(hjust = 0.5),
            axis.text.x = element_text(angle = 90, hjust = 0.5)) +
      coord_cartesian(ylim = boxplot.stats(steam_action$price_discount)$stats[c(1, 5)]*1.5) +
      labs(title="Distribution of memory according to OS", 
           x="OS Platform", y="Memory Distribution(GB)")
  })
  # 6B. Storage Distribution
  #minbox
  output$storage_distribution_minbox <- renderInfoBox({
    min_value<-min(steam_action$storage[steam_action$storage!=0], na.rm = T)
    min_game<-min(steam_action$game_title[steam_action['storage']==min_value], na.rm = T)[1]
    infoBox(title=min_game,
            value= min_value, icon = icon("hand-o-down"))
    
  })
  #maxbox
  output$storage_distribution_maxbox <- renderInfoBox({
    max_value<-max(steam_action$storage[steam_action$storage!=0], na.rm = T)
    max_game<-max(steam_action$game_title[steam_action['storage']==max_value], na.rm = T)[1]
    infoBox(title=max_game,
            value= max_value, icon = icon("hand-o-up"))
    
  })
  # Histogram
  output$storage_distribution_hist_output <- renderPlot({
    ggplot() +
      geom_density(data=steam_action[!is.na(steam_action$storage) & steam_action$storage<200,],
                   aes(x=storage), fill='blue', alpha=0.1) +
      theme_classic() +
      theme(plot.title = element_text(hjust = 0.5),
            axis.text.x = element_text(angle = 90, hjust = 0.5)) +
      scale_x_continuous( expand=c(0,0), breaks=seq(0,10000,100) ) +
      scale_y_continuous(expand = c(0,0)) +
      labs(title="Distribution of Storage", 
           x="Storage(GB)", 
           y="Density")
    
  })
  # Box Plot
  output$storage_distribution_box_output <- renderPlot({
    ggplot() +
      geom_boxplot(data=dplyr::bind_rows(
        steam_action %>% select(., c('game_title','storage','os_list_windows')) %>% 
          filter(., os_list_windows==1) %>% mutate(., os_list='windows') %>% 
          select(., c('game_title','storage','os_list')),
        steam_action %>% select(., c('game_title','storage','os_list_linux')) %>% 
          filter(., os_list_linux==1) %>% mutate(., os_list='linux') %>% 
          select(., c('game_title','storage','os_list')),
        steam_action %>% select(., c('game_title','storage','os_list_mac')) %>% 
          filter(., os_list_mac==1) %>% mutate(., os_list='mac') %>% 
          select(., c('game_title','storage','os_list'))
      ),
      aes(x=factor(os_list), y=storage, group=factor(os_list)),
      alpha=0.1, color='black', fill='blue') +
      stat_summary(data=mean_os,fun.y=mean, geom="point", shape=20, size=2, color="blue", fill="blue", aes(x=factor(os_list), y=memory)) +
      theme_classic() +
      theme(plot.title = element_text(hjust = 0.5),
            axis.text.x = element_text(angle = 90, hjust = 0.5)) +
      coord_cartesian(ylim = boxplot.stats(steam_action$price_discount)$stats[c(1, 5)]*1.5) +
      labs(title="Distribution of storage according to OS", 
           x="OS Platform", y="Storage Distribution(GB)")
  })
  # 6D. Memory by Genre
  output$memory_by_genre_output <- renderPlot({
    ggplot()+
      geom_bar(data=calc_avg_memory, aes(x=genre, y=mem_average), 
               stat='identity', fill='blue', color='black', alpha=0.1) +
      geom_hline(yintercept = mean(steam_action$memory,na.rm = T), color="blue") +
      theme_classic() +
      theme(plot.title = element_text(hjust = 0.5),
            axis.text.x = element_text(angle = 90, hjust = 0.5)) +
      scale_x_discrete( expand=c(0,0)) +
      scale_y_continuous(expand = c(0,0)) +
      labs(title="Average Memory by Genre", 
           x="Genre", 
           y="Average Memory")
  })
})