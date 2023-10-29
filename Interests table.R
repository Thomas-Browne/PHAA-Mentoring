# Create interests table

library(readxl)
library(tidyverse)

File_path <- paste0('C:/Users/', Sys.getenv('USERNAME'), '/Desktop/')
dir.create(paste0(File_path,"Mentor registrations"))


if(winDialog(type = "okcancel", message = "Move an export of the mentor registrations to the folder 'Mentor registrations' on your desktop. Click Ok to continue") == "OK") {
Registrations <- list.files(paste0(File_path, 'Mentor registrations'), pattern = '.xlsx', full.names = TRUE)
 
} else {
  stop('User cancelled the operation')
}

Registration_extract <- read_excel(Registrations[1]) %>% 
  select(Name = 'Full Name',
         Topics = 'What specific topic area do you have expertise in? Please select as many as applicable. The topic areas listed are based on the Special Interest Groups of the PHAA.  https://www.phaa.net.au/about-us/SIGs',
  ) 

Registrations <- Registration_extract %>%
  filter(!is.na(Name)) %>%
  mutate(Topics = str_split_fixed(Topics, ",", n = Inf)) %>% 
  mutate_all(~ifelse(. == "Alcohol", "Alcohol,  Tobacco and Other Drugs", .),
             ~ifelse(. == "Tobacco and Other Drugs", NA, .)
             ~ifelse(. == "", is.na(), .))
             ) %>% 
  transpose()
             # ) %>% 
  pivot_wider(id_cols = 'Name',
              )


Mentors <- Registration_extract$Name
Topics <- c('Aboriginal and Torres Strait Islander Health', 'Alcohol, Tobacco and Other Drugs', 'Child and Youth Health', 'Complementary Medicine - Evidence', 'Diversity, Equity and Inclusion', 'Ecology and Environment', 'Food and Nutrition', 'Health Promotion', 'Immunisation', 'Injury Prevention', 'International Health', 'Justice Health', 'Mental Health', 'One Health', 'Oral Health', 'Political Economy of Health', 'Primary Health Care', 'Research and Policy', 'Women’s Health')

t<- data.frame(Mentors = Mentors,
               Aboriginal, 
               Alcohol_Tobacco_and_Other_Drugs, 
               Child_and_Youth_Health, 
               Complementary_Medicine_Evidence, Diversity, Equity_and_Inclusion, Ecology_and_Environment, Food_and_Nutrition, Health_Promotion, Immunisation, Injury_Prevention, International_Health, Justice_Health, Mental_Health, One_Health, Oral_Health, Political_Economy_of_Health, Primary_Health_Care, Research_and_Policy, Womens_Health)
  mutate(Topics = str_split_fixed(Topics, ",", n = Inf)) %>% 
  mutate_all(~ifelse(. == "Alcohol", "Alcohol,  Tobacco and Other Drugs", .),
             ~ifelse(. == " Tobacco and Other Drugs", NA, .))




names(Registration_extract)
