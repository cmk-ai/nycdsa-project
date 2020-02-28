library(ggplot2)
library(tidyverse)

dem_score <- read_csv("www/d0_democracy_score.csv")
income <- read_csv("www/d1_income_per_person.csv")
literacy <- read_csv("www/d2_literacy_rate.csv")
emission <- read_csv("www/d3_co2_emissions.csv")
life_expectancy <- read_csv("www/d4_life_expectancy.csv")
water <- read_csv("www/d5_basic_water_source.csv")
employment <- read_csv("www/d6_employment_rate.csv")
cpi <- read_csv("www/d7_corruption_perception.csv")

fill_values <- function(row){
  filt_cond <- !is.na(row)
  filt_values <- row[c(filt_cond)]
  return(rev(filt_values)[1][[1]])
}

# Preparing demcoracy score
dem_score_latest = dem_score['country']
dem_score_latest['score'] <- apply(X = dem_score, MARGIN = 1, 
                                   FUN = fill_values)
dem_score_latest$score <- as.numeric(dem_score_latest$score)

# function for grouping polity score
simp_polity_score <- function(row){
  if(row>=-10 & row<=-6){
    return ("Autocracy")
  }else if(row>=-5 & row<=-1){
    return ("Closed Anocracy")
  }else if(row>=1 & row<=5){
    return ("Open Anocracy")
  }else if(row>=6 & row<=9){
    return ("Democracy")
  }else{
    return ("Full Democracy")
  }
}
dem_score_latest['dem_sim_score'] <- apply(X = dem_score_latest['score'], MARGIN = 1, 
                                           FUN = simp_polity_score)
#head(dem_score_latest)

# pick five values
pick_five_values <- function(row){
  filt_cond <- !is.na(row)
  filt_values <- row[c(filt_cond)]
  return((rev(filt_values)[1:5]))
}

income_latest <- income['country']
literacy_latest <- literacy['country']
emission_latest <- emission['country']
life_expectancy_latest <- life_expectancy['country']
water_latest <- water['country']
employment_latest <- employment['country']
cpi_latest <- cpi['country']

# 1. Preparing income data frame with last 5 values
inc_5 <- apply(X = income[,-1], MARGIN = 1, 
               FUN = pick_five_values)
income_latest['income_1'] <- t(inc_5)[,1]
income_latest['income_2'] <- t(inc_5)[,2]
income_latest['income_3'] <- t(inc_5)[,3]
income_latest['income_4'] <- t(inc_5)[,4]
income_latest['income_5'] <- t(inc_5)[,5]

# 2. Preparing litracy data frame with last 5 values
lit_5 <- apply(X = literacy[,-1], MARGIN = 1, 
               FUN = pick_five_values)
literacy_latest['literacy_1'] <- t(lit_5)[,1]
literacy_latest['literacy_2'] <- t(lit_5)[,2]
literacy_latest['literacy_3'] <- t(lit_5)[,3]
literacy_latest['literacy_4'] <- t(lit_5)[,4]
literacy_latest['literacy_5'] <- t(lit_5)[,5]

# 3. Preparing emission data frame with last 5 values
emi_5 <- apply(X = emission[,-1], MARGIN = 1, 
               FUN = pick_five_values)
emission_latest['emission_1'] <- t(emi_5)[,1]
emission_latest['emission_2'] <- t(emi_5)[,2]
emission_latest['emission_3'] <- t(emi_5)[,3]
emission_latest['emission_4'] <- t(emi_5)[,4]
emission_latest['emission_5'] <- t(emi_5)[,5]

# 4. Preparing life_expectancy data frame with last 5 values
lif_5 <- apply(X = life_expectancy[,-1], MARGIN = 1, 
               FUN = pick_five_values)
life_expectancy_latest['life_expectancy_1'] <- t(lif_5)[,1]
life_expectancy_latest['life_expectancy_2'] <- t(lif_5)[,2]
life_expectancy_latest['life_expectancy_3'] <- t(lif_5)[,3]
life_expectancy_latest['life_expectancy_4'] <- t(lif_5)[,4]
life_expectancy_latest['life_expectancy_5'] <- t(lif_5)[,5]

# 5. Preparing water data frame with last 5 values
wat_5 <- apply(X = water[,-1], MARGIN = 1, 
               FUN = pick_five_values)
water_latest['water_1'] <- t(wat_5)[,1]
water_latest['water_2'] <- t(wat_5)[,2]
water_latest['water_3'] <- t(wat_5)[,3]
water_latest['water_4'] <- t(wat_5)[,4]
water_latest['water_5'] <- t(wat_5)[,5]

# 6. Preparing employment data frame with last 5 values
emp_5 <- apply(X = employment[,-1], MARGIN = 1, 
               FUN = pick_five_values)
employment_latest['employment_1'] <- t(emp_5)[,1]
employment_latest['employment_2'] <- t(emp_5)[,2]
employment_latest['employment_3'] <- t(emp_5)[,3]
employment_latest['employment_4'] <- t(emp_5)[,4]
employment_latest['employment_5'] <- t(emp_5)[,5]

# 7. Preparing cpi data frame with last 5 values
cpi_5 <- apply(X = cpi[,-1], MARGIN = 1, 
               FUN = pick_five_values)
cpi_latest['cpi_1'] <- t(cpi_5)[,1]
cpi_latest['cpi_2'] <- t(cpi_5)[,2]
cpi_latest['cpi_3'] <- t(cpi_5)[,3]
cpi_latest['cpi_4'] <- t(cpi_5)[,4]
cpi_latest['cpi_5'] <- t(cpi_5)[,5]

# head(income_latest)
# head(literacy_latest)
# head(emission_latest)
# head(life_expectancy_latest)
# head(water_latest)
# head(employment_latest)
# head(cpi_latest)

# Join all data frames
all_latest <- list(dem_score_latest, income_latest, literacy_latest, emission_latest,
                   life_expectancy_latest, water_latest, employment_latest,
                   cpi_latest) %>% reduce(left_join, by='country')

# Joing with World map data frame
map.world <- map_data("world")
dem_score_latest$country <- recode(dem_score_latest$country,
                                   'United States' = 'USA',
                                   'United Kingdom' = 'UK',
                                   'Kyrgyz Republic' = 'Kyrgyzstan',
                                   'Lao' = 'Laos',
                                   'Congo, Dem. Rep.' = 'Democratic Republic of the Congo',
                                   'Cote d\'Ivoire' = 'Ivory Coast',
                                   'Slovak Republic' = 'Slovakia'
                                   
)
dem_score_latest <- left_join(map.world, dem_score_latest, 
                              by = c('region' = 'country'))

# 1. INCOME COMPARE
all_latest_income <- all_latest %>% group_by(.,dem_sim_score) %>% 
  summarise('year_1' = mean(income_1, na.rm = TRUE),
            'year_2' = mean(income_2, na.rm = TRUE),
            'year_3' = mean(income_3, na.rm = TRUE),
            'year_4' = mean(income_4, na.rm = TRUE),
            'year_5' = mean(income_5, na.rm = TRUE))

all_latest_income <- gather(all_latest_income, 
                            key='year', value='income', 'year_1':'year_5')

all_latest_income$year_order <- factor(
  all_latest_income$year, 
  levels = c("year_5","year_4","year_3","year_2","year_1"))

# 2. LITERACY COMPARE
all_latest_literacy <- all_latest %>% group_by(.,dem_sim_score) %>% 
  summarise('year_1' = mean(literacy_1, na.rm = TRUE),
            'year_2' = mean(literacy_2, na.rm = TRUE),
            'year_3' = mean(literacy_3, na.rm = TRUE),
            'year_4' = mean(literacy_4, na.rm = TRUE),
            'year_5' = mean(literacy_5, na.rm = TRUE))

all_latest_literacy <- gather(all_latest_literacy, 
                              key='year', value='literacy', 'year_1':'year_5')

all_latest_literacy$year_order <- factor(
  all_latest_literacy$year, 
  levels = c("year_5","year_4","year_3","year_2","year_1"))

# 3. CO2 EMISSION COMPARE
all_latest_emission <- all_latest %>% group_by(.,dem_sim_score) %>% 
  summarise('year_1' = mean(emission_1, na.rm = TRUE),
            'year_2' = mean(emission_2, na.rm = TRUE),
            'year_3' = mean(emission_3, na.rm = TRUE),
            'year_4' = mean(emission_4, na.rm = TRUE),
            'year_5' = mean(emission_5, na.rm = TRUE))

all_latest_emission <- gather(all_latest_emission, 
                              key='year', value='emission', 'year_1':'year_5')

all_latest_emission$year_order <- factor(
  all_latest_emission$year, 
  levels = c("year_5","year_4","year_3","year_2","year_1"))

# 4. LIFE EXPECTANCY COMPARE
all_latest_life_expectancy <- all_latest %>% group_by(.,dem_sim_score) %>% 
  summarise('year_1' = mean(life_expectancy_1, na.rm = TRUE),
            'year_2' = mean(life_expectancy_2, na.rm = TRUE),
            'year_3' = mean(life_expectancy_3, na.rm = TRUE),
            'year_4' = mean(life_expectancy_4, na.rm = TRUE),
            'year_5' = mean(life_expectancy_5, na.rm = TRUE))

all_latest_life_expectancy <- gather(all_latest_life_expectancy, 
                                     key='year', value='life_expectancy', 'year_1':'year_5')

all_latest_life_expectancy$year_order <- factor(
  all_latest_life_expectancy$year, 
  levels = c("year_5","year_4","year_3","year_2","year_1"))

# 5. WATER ACCESS COMPARE
all_latest_water <- all_latest %>% group_by(.,dem_sim_score) %>% 
  summarise('year_1' = mean(water_1, na.rm = TRUE),
            'year_2' = mean(water_2, na.rm = TRUE),
            'year_3' = mean(water_3, na.rm = TRUE),
            'year_4' = mean(water_4, na.rm = TRUE),
            'year_5' = mean(water_5, na.rm = TRUE))

all_latest_water <- gather(all_latest_water, 
                           key='year', value='water', 'year_1':'year_5')

all_latest_water$year_order <- factor(
  all_latest_water$year, 
  levels = c("year_5","year_4","year_3","year_2","year_1"))

# 6. EMPLOYMENT RATE COMPARE
all_latest_employment <- all_latest %>% group_by(.,dem_sim_score) %>% 
  summarise('year_1' = mean(employment_1, na.rm = TRUE),
            'year_2' = mean(employment_2, na.rm = TRUE),
            'year_3' = mean(employment_3, na.rm = TRUE),
            'year_4' = mean(employment_4, na.rm = TRUE),
            'year_5' = mean(employment_5, na.rm = TRUE))

all_latest_employment <- gather(all_latest_employment, 
                                key='year', value='employment', 'year_1':'year_5')

all_latest_employment$year_order <- factor(
  all_latest_employment$year, 
  levels = c("year_5","year_4","year_3","year_2","year_1"))

# 7. CORRUPTION PERCEPTION INDEX (CPI) COMPARE
all_latest_cpi <- all_latest %>% group_by(.,dem_sim_score) %>% 
  summarise('year_1' = mean(cpi_1, na.rm = TRUE),
            'year_2' = mean(cpi_2, na.rm = TRUE),
            'year_3' = mean(cpi_3, na.rm = TRUE),
            'year_4' = mean(cpi_4, na.rm = TRUE),
            'year_5' = mean(cpi_5, na.rm = TRUE))

all_latest_cpi <- gather(all_latest_cpi, 
                         key='year', value='cpi', 'year_1':'year_5')

all_latest_cpi$year_order <- factor(
  all_latest_cpi$year, 
  levels = c("year_5","year_4","year_3","year_2","year_1"))
