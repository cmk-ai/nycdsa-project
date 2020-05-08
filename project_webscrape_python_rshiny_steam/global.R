library(ggplot2)
library(tidyverse)
library(splitstackshape)
library(reshape2)

steam_action <- read_csv("www/2_r5_steam.csv")

# converting title to lower
colnames( steam_action ) <- tolower( colnames(steam_action) )

# Select unique Rows based on Game_Title
steam_action <- steam_action %>% distinct(.,game_title, .keep_all = TRUE)

# Convert None to R's NA
steam_action[ steam_action == 'None' ] <- NA

# Converting has_violent to boolean value
steam_action$has_violence <- if_else(
  tolower(steam_action$has_violence) %in% 
    tolower(c('violence/bad_language', 'Animated Blood', 'Blood', 
              'Has_Violence', 'Horror', 'Multiple motiveless killings',
              'Multiple, motiveless killing', 'Sex', 'Strong Language'
    )), 
  true = TRUE, false = FALSE, missing = FALSE)

# converting discount_percentage by remove special character
steam_action$discount_percentage <- gsub("[[:punct:]]", "", steam_action$discount_percentage)

# converting price_orignal 'free to play' to 0
steam_action$price_original[str_detect(tolower(steam_action$price_original),'free')] <- 0

# converting price_subscription to TRUE/FALSE
steam_action$price_subscription <- if_else(
  condition = str_detect( tolower(steam_action$price_subscription), 'subscription' ),
  true = TRUE, false = FALSE, missing = FALSE
)

# converting vr_support to TRUE/FALSE
steam_action$vr_support <- if_else(
  condition = str_detect( tolower(steam_action$price_subscription), 'vr' ),
  true = TRUE, false = FALSE, missing = FALSE
)


#################### DATA CLEANING ####################

# Delete all Game_title Rows
steam_action <- steam_action[ !steam_action$game_title=='Game_Title', ]

# converting player type to two players
player_type_manu <- function(row) { 
  if(is.na(row)){
    return (row)
  }else if( str_detect(tolower(row), 'multi') ){
    return ('multi-player')
  }else if (str_detect(tolower(row), 'mmo')){
    return ('multi-player')
  }else if (str_detect(tolower(row), 'co-op')){
    return ('multi-player')
  }else if (str_detect(tolower(row), 'pvp')){
    return ('multi-player')
  }else{
    return ('single-player')
  }
}
steam_action['player_type'] <- apply(X = steam_action['player_type'], MARGIN = 1, 
                                     FUN = player_type_manu)


# Converting empty list to NA
steam_action[ steam_action == '[]' ] <- NA

# Converting all_revew_cat
steam_action$all_review_cat <-
  ifelse(
    test = tolower(steam_action$all_review_cat) %in% 
      tolower(c('Mostly Negative', 'Mixed', 'Mostly Positive', 'Positive', 
                'Very Positive', 'Overwhelmingly Positive')),
    yes = steam_action$all_review_cat,
    no = NA)


# Join Storage and Hard_Drive column
steam_action$storage <-
  ifelse(
    test = is.na(steam_action$storage),
    yes = steam_action$hard_drive,
    no = steam_action$storage
  )

# Drop Hard_Drive column
steam_action <- select( steam_action, -hard_drive )

# Taking averages of memory and storage
average_mem <- function(row_lst){
  if (is.na(row_lst)){
    return (row_lst)
  }
  row_lst = as.list(str_split(string = row_lst, pattern = ',')[[1]])
  avg_byte = 0
  for (byte in row_lst){
    byte_orig = byte
    tryCatch({
      if(str_detect(byte,"[0-9]+\\s*[G|M|K|g|m|k][B|b]")){  
        byte = str_extract(byte,"[0-9]+\\s*[G|M|K|g|m|k][B|b]")
        if(str_detect(tolower(byte), 'gb') & parse_number(byte) > 128){
          byte = str_replace(byte, "[G|g][B|b]", "mb")
        }
        
        if (str_detect(tolower(byte), 'gb')){
          avg_byte = avg_byte + (as.numeric(
            ifelse(test=!is.na(parse_number(byte)), yes=parse_number(byte), no=0 )
          ) * 1000000)
        }else if(str_detect(tolower(byte), 'mb')){
          avg_byte = avg_byte + (as.numeric(
            ifelse(test=!is.na(parse_number(byte)), yes=parse_number(byte), no=0 )
          ) * 1000)
        }else if(str_detect(tolower(byte), 'kb')){
          avg_byte = avg_byte + (as.numeric(
            ifelse(test=!is.na(parse_number(byte)), yes=parse_number(byte), no=0 )
          ) * 1)
        }
      }#if
      else{return(NA)}
    },
    error=function(cond) {
      print("Error")
      print(byte_orig)
      print(cond)
      # Choose a return value in case of error
      return(NA)
    },
    warning=function(cond) {
      print("Warning")
      print(byte_orig)
      print(cond)
      # Choose a return value in case of warning
      return(NA)
    }
    
    )
  }
  if(round((round(avg_byte/length(row_lst), digit=0))/1000000, digit=0) == 0){
    return(round((round(avg_byte/length(row_lst), digit=0))/1000000, digit=4))
  }else{
    return (round((round(avg_byte/length(row_lst), digit=0))/1000000, digit=0))
  }
}

steam_action$memory <- apply( X=steam_action['memory'], MARGIN = 1,
                              FUN = average_mem)

# Taking averages of storage
average_sto <- function(row_lst){
  if (is.na(row_lst)){
    return (row_lst)
  }
  row_lst = as.list(str_split(string = row_lst, pattern = ',')[[1]])
  avg_byte = 0
  for (byte in row_lst){
    byte_orig = byte
    tryCatch({
      if(str_detect(byte,"[0-9]+\\s*[G|M|K|g|m|k][B|b]")){  
        byte = str_extract(byte,"[0-9]+\\s*[G|M|K|g|m|k][B|b]")
        
        
        if (str_detect(tolower(byte), 'gb')){
          avg_byte = avg_byte + (as.numeric(
            ifelse(test=!is.na(parse_number(byte)), yes=parse_number(byte), no=0 )
          ) * 1000000)
        }else if(str_detect(tolower(byte), 'mb')){
          avg_byte = avg_byte + (as.numeric(
            ifelse(test=!is.na(parse_number(byte)), yes=parse_number(byte), no=0 )
          ) * 1000)
        }else if(str_detect(tolower(byte), 'kb')){
          avg_byte = avg_byte + (as.numeric(
            ifelse(test=!is.na(parse_number(byte)), yes=parse_number(byte), no=0 )
          ) * 1)
        }
      }#if
      else{return(NA)}
    },
    error=function(cond) {
      print("Error")
      print(byte_orig)
      print(cond)
      # Choose a return value in case of error
      return(NA)
    },
    warning=function(cond) {
      print("Warning")
      print(byte_orig)
      print(cond)
      # Choose a return value in case of warning
      return(NA)
    }
    
    )
  }
  if(round((round(avg_byte/length(row_lst), digit=0))/1000000, digit=0) == 0){
    return(round((round(avg_byte/length(row_lst), digit=0))/1000000, digit=4))
  }else{
    return (round((round(avg_byte/length(row_lst), digit=0))/1000000, digit=0))
  }
}

steam_action$storage <- apply( X=steam_action['storage'], MARGIN = 1,
                               FUN = average_sto)


steam_action$genre_list <- str_replace_all( steam_action$genre_list, "\\[", "" )
steam_action$genre_list <- str_replace_all( steam_action$genre_list, "\\]", "" )
steam_action$genre_list <- gsub("[[:space:]]", "", steam_action$genre_list)
steam_action$genre_list <- str_replace_all( steam_action$genre_list, "'", "" )
steam_action$genre_list <- tolower( steam_action$genre_list )
# Split rows to columns of genre_list
steam_action <- splitstackshape::cSplit_e(steam_action, "genre_list", ",", type = "character", fill = 0, drop = T)

steam_action$os_list <- str_replace_all( steam_action$os_list, "\\[", "" )
steam_action$os_list <- str_replace_all( steam_action$os_list, "\\]", "" )
# Split rows to columns of os_lists
steam_action <- splitstackshape::cSplit_e(steam_action, "os_list", ",", type = "character", fill = 0, drop = T)

colnames( steam_action ) <- str_replace_all(colnames(steam_action), "__", "_")
colnames( steam_action ) <- str_replace_all(colnames(steam_action), "'", "")

# Converting Price_Original Strings to NA's
steam_action$price_original <- ifelse(test= grepl("^[0-9]*$", steam_action$price_original, perl = TRUE) , yes=steam_action$price_original, no=NA)



# Converting data types
change_df_type <- function(df){
  df$game_title=as.character(df$game_title)
  df$all_review_cat=as.factor(df$all_review_cat)
  df$release_date=as.Date(x=df$release_date, format = "%d %B, %Y")
  df$game_developer=as.character(df$game_developer)
  df$game_publisher=as.character(df$game_publisher)
  df$player_type=as.factor(df$player_type)
  df$has_violence=as.logical(df$has_violence)
  df$price_original_before_discount=as.numeric(df$price_original_before_discount)
  df$discount_percentage=as.numeric(df$discount_percentage)
  df$price_discount=as.numeric(df$price_discount)
  df$price_original=as.numeric(df$price_original)
  df$price_subscription=as.logical(df$price_subscription)
  df$memory=as.numeric(df$memory)
  df$storage=as.numeric(df$storage)
  df$vr_support=as.logical(df$vr_support)
  df$purchase_all=as.numeric(df$purchase_all)
  df$purchase_steam=as.numeric(df$purchase_steam)
  df$purchase_other=as.numeric(df$purchase_other)
  df$review_all=as.numeric(df$review_all)
  df$review_positive=as.numeric(df$review_positive)
  df$review_negative=as.numeric(df$review_negative)
  return(df)
}

steam_action <- change_df_type( steam_action )

# Converting Price from Indian Rupee to US Dollar
steam_action$price_original_before_discount <- round(steam_action$price_original_before_discount/70, digits = 2)
steam_action$price_discount <- round(steam_action$price_discount/70, digits = 2)
steam_action$price_original <- round(steam_action$price_original/70, digits = 2)

# Distribution between different Memory according to os systems
mean_os <- aggregate(memory~os_list,dplyr::bind_rows(
  steam_action %>% select(., c('game_title','memory','os_list_windows')) %>% 
    filter(., os_list_windows==1) %>% mutate(., os_list='windows') %>% 
    select(., c('game_title','memory','os_list')),
  steam_action %>% select(., c('game_title','memory','os_list_linux')) %>% 
    filter(., os_list_linux==1) %>% mutate(., os_list='linux') %>% 
    select(., c('game_title','memory','os_list')),
  steam_action %>% select(., c('game_title','memory','os_list_mac')) %>% 
    filter(., os_list_mac==1) %>% mutate(., os_list='mac') %>% 
    select(., c('game_title','memory','os_list'))
) , mean)

# Distribution between different Storage according to os system
mean_storage <- aggregate(storage~os_list,dplyr::bind_rows(
  steam_action %>% select(., c('game_title','storage','os_list_windows')) %>% 
    filter(., os_list_windows==1) %>% mutate(., os_list='windows') %>% 
    select(., c('game_title','storage','os_list')),
  steam_action %>% select(., c('game_title','storage','os_list_linux')) %>% 
    filter(., os_list_linux==1) %>% mutate(., os_list='linux') %>% 
    select(., c('game_title','storage','os_list')),
  steam_action %>% select(., c('game_title','storage','os_list_mac')) %>% 
    filter(., os_list_mac==1) %>% mutate(., os_list='mac') %>% 
    select(., c('game_title','storage','os_list'))
) , mean)

# which genre takes more memory
calc_avg_memory <- data.frame(ifelse(test=steam_action[ !is.na(steam_action$memory), ] %>% 
                                       select(., starts_with('genre_list_')) ==1,yes =  steam_action$memory, no=0)) %>% 
  select(.,starts_with('genre_list_')) %>% summarise_all(.,funs(mean(.,na.rm=T)))

colnames(calc_avg_memory) <- str_replace(string=colnames(calc_avg_memory), pattern = 'genre_list_', replacement = '')

calc_avg_memory <- data.frame("genre"=colnames(calc_avg_memory), mem_average=as.numeric(as.vector(calc_avg_memory[1,])))

# which genre on average cost more

calc_avg_price <- data.frame(ifelse(test=steam_action[ !is.na(steam_action$price_original), ] %>% 
                                      select(., starts_with('genre_list_')) ==1,yes =  steam_action$price_original, no=0)) %>% 
  select(.,starts_with('genre_list_')) %>% summarise_all(.,funs(mean(.,na.rm=T)))

colnames(calc_avg_price) <- str_replace(string=colnames(calc_avg_price), pattern = 'genre_list_', replacement = '')

calc_avg_price <- data.frame("genre"=colnames(calc_avg_price), price_average=as.numeric(as.vector(calc_avg_price[1,])))

# calculate distribution of Price according to genre
calc_dist_price <- data.frame(ifelse(test=steam_action[ !is.na(steam_action$price_original), ] %>% 
                                       select(., starts_with('genre_list_'),'game_title') ==1,yes =  steam_action$price_original, no=0)) %>% 
  select(.,starts_with('genre_list_'),'game_title')

calc_dist_price <- melt( calc_dist_price, id.vars = "game_title")

calc_dist_price$variable <- str_replace(string=calc_dist_price$variable, pattern = 'genre_list_', replacement = '')

# Review based on Genre
genre_review_cat <- data.frame(ifelse(test=steam_action[ !is.na(steam_action$all_review_cat), ] %>% 
                                        select(., starts_with('genre_list_'),'game_title') ==1, yes = as.character(steam_action$all_review_cat), no=NA)) %>% 
  select(.,starts_with('genre_list_'),'game_title')

genre_review_cat <- melt( genre_review_cat, id.vars = "game_title")

genre_review_cat$variable <- str_replace(string=genre_review_cat$variable, pattern = 'genre_list_', replacement = '')

