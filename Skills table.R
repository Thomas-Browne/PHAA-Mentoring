

# Packages ----------------------------------------------------------------

if (!require("tidyverse")) install.packages("tidyverse")
if (!require("openxlsx")) install.packages("openxlsx")
if (!require("openxlsx")) install.packages("openxlsx")

# Data manipulation -------------------------------------------------------

# survey_raw <- list.files(
#   path = Sys.getenv("HOME"),
#   pattern = '.xlsx', 
#   full.names = TRUE, 
#   ignore.case = FALSE, 
#   all.files = FALSE
# )

svDialogs::dlg_message('Select the .xlsx file with the survey responses')
survey_raw <- tcltk::tk_choose.files(caption = 'Choose file', multi = FALSE)
file_path <- dirname(survey_raw) %>% as.character()

survey <- readxl::read_excel(survey_raw) %>%
  dplyr::select(
    name = 2, 
    interests = 4, 
    skills = 5,
    type_of_mentee = 6
  ) %>% 
  dplyr::filter(!is.na(name)) %>% 
  dplyr::mutate(
    interests = gsub(x = interests, 
                     ';', 
                     replacement = '\n'),
    skills = gsub(x = skills, 
                  ';', 
                  replacement = '\n'),
    type_of_mentee = gsub(x = type_of_mentee, 
                          ';', 
                          replacement = '\n')
  ) %>% 
  dplyr::arrange(name)

interests_list <- list(
  'Aboriginal and Torres Strait Islander Health', 
  'Alcohol, Tobacco and Other Drugs', 
  'Child and Youth Health', 
  'Complementary Medicine – Evidence, Research & Policy', 
  'Diversity, Equity and Inclusion', 
  'Ecology and Environment', 
  'Food and Nutrition', 
  'Health Promotion', 
  'Immunisation', 
  'Injury Prevention', 
  'International Health', 
  'Justice Health', 
  'Mental Health', 
  'One Health', 
  'Oral Health', 
  'Political Economy of Health', 
  'Primary Health Care', 
  'Women’s Health'
)

interests <- survey %>% 
  dplyr::select(1:2,4) %>% 
  dplyr::filter(!is.na(interests)) %>% 
  dplyr::mutate(
    Aboriginal_and_Torres_Strait_Islander_Health = grepl(interests_list[1], interests),
    Alcohol_Tobacco_and_Other_Drugs = grepl(interests_list[2], interests),
    Child_and_Youth_Health = grepl(interests_list[3], interests),
    Complementary_Medicine_Evidence_Research_and_Policy = grepl(interests_list[4], interests),
    Diversity_Equity_and_Inclusion = grepl(interests_list[5], interests),
    Ecology_and_Environment = grepl(interests_list[6], interests),
    Food_and_Nutrition = grepl(interests_list[7], interests),
    Health_Promotion = grepl(interests_list[8], interests),
    Immunisation = grepl(interests_list[9], interests),
    Injury_Prevention = grepl(interests_list[10], interests),
    International_Health = grepl(interests_list[11], interests),
    Justice_Health = grepl(interests_list[12], interests),
    Mental_Health = grepl(interests_list[13], interests),
    One_Health = grepl(interests_list[14], interests),
    Oral_Health = grepl(interests_list[15], interests),
    Political_Economy_of_Health = grepl(interests_list[16], interests),
    Primary_Health_Care = grepl(interests_list[17], interests),
    Womens_Health = grepl(interests_list[18], interests),
  )

skills_list <- list(
  'Advocacy', 
  'Policy', 
  'Research', 
  'Fellowship application', 
  'Grant writing', 
  'Job application', 
  'Leadership', 
  'Teaching', 
  'Recently graduated', 
  'Career transition', 
  'Work life balance', 
  'International experience and networks', 
  'Non-governmental organisation', 
  'Working as a healthcare practitioner', 
  'Working with or within government' 
)

skills <- survey %>% 
  dplyr::select(1, 3:4) %>% 
  dplyr::filter(!is.na(skills)) %>% 
  dplyr::mutate(
    Advocacy = grepl(skills_list[1], skills),
    Policy = grepl(skills_list[2], skills),
    Research = grepl(skills_list[3], skills),
    Fellowship_application = grepl(skills_list[4], skills),
    Grant_writing = grepl(skills_list[5], skills),
    Job_application = grepl(skills_list[6], skills),
    Leadership = grepl(skills_list[7], skills),
    Teaching = grepl(skills_list[8], skills),
    Recently_graduated = grepl(skills_list[9], skills),
    Career_transition = grepl(skills_list[10], skills),
    Work_life_balance = grepl(skills_list[11], skills),
    International_experience_and_networks = grepl(skills_list[12], skills),
    NGOs = grepl(skills_list[13], skills),
    Working_as_a_healthcare_practitioner = grepl(skills_list[14], skills),
    Working_with_or_within_government = grepl(skills_list[15], skills),
  )


#check


# # Split the text by line breaks
# split_text <- strsplit(survey$skills, "\n")
# 
# # Unlist and extract unique phrases
# unique_phrases <- unique(unlist(split_text)) %>% print()



# Create and format tables ------------------------------------------------

## Define table style ------------------------------------------------------

# colours
phaa_blue <- "#4f81bd"
phaa_yellow <- "#fec834"

# styles
true_style <- openxlsx::createStyle(
  fontColour = phaa_blue,
  fontName = "Nunito",
  bgFill = phaa_blue)
false_style <- openxlsx::createStyle(
  fontColour = "white",
  fontName = "Nunito",
  bgFill = "white")
header_style <- openxlsx::createStyle(
  fontColour = "white",
  textDecoration = "BOLD", 
  fontName = "Nunito",
  bgFill = phaa_yellow
)



## Interests ---------------------------------------------------------------
int_path <- paste0(file_path, '/interests table.xlsx')

openxlsx::write.xlsx(x = interests, 
                     file = int_path, 
                     asTable = FALSE, 
                     overwrite = TRUE)

int_wb <- openxlsx::loadWorkbook(int_path)

openxlsx::writeData(int_wb, sheet = 'Sheet 1', 
                    startCol = 1, 
                    startRow = 1, 
                    x = c('Mentor name', 'Skills', 'Type of mentee', interests_list))

openxlsx::conditionalFormatting(
  wb = int_wb,
  sheet = 'Sheet 1',
  cols = 4:21,
  rows = 1:100,
  rule = "D1 == TRUE",
  type = "expression",
  style = true_style
)
openxlsx::conditionalFormatting(
  wb = int_wb,
  sheet = 'Sheet 1',
  cols = 4:21,
  rows = 1:100,
  rule = "D1 == FALSE",
  type = "expression",
  style = false_style
)
openxlsx::conditionalFormatting(
  wb = int_wb,
  sheet = 'Sheet 1',
  cols = 1:21,
  rows = 1:1,
  rule = 'A1<>""',
  type = "expression",
  style = header_style
)
openxlsx::saveWorkbook(int_wb, int_path, overwrite = TRUE)



## Skills ------------------------------------------------------------------
skill_path <- paste0(file_path, '/skills table.xlsx')
openxlsx::write.xlsx(x = skills, 
                     file = skill_path,
                     asTable = FALSE, 
                     overwrite = TRUE)

skills_wb <- openxlsx::loadWorkbook(skill_path)

openxlsx::writeData(skills_wb, sheet = 'Sheet 1', 
                    startCol = 1, 
                    startRow = 1, 
                    x = c('Mentor name', 'Skills', 'Type of mentee', skills_list))

openxlsx::conditionalFormatting(
  wb = skills_wb,
  sheet = 'Sheet 1',
  cols = 4:18,
  rows = 1:100,
  rule = "D1 == TRUE",
  type = "expression",
  style = true_style
)
openxlsx::conditionalFormatting(
  wb = skills_wb,
  sheet = 'Sheet 1',
  cols = 4:18,
  rows = 1:100,
  rule = "D1 == FALSE",
  type = "expression",
  style = false_style
)
openxlsx::conditionalFormatting(
  wb = skills_wb,
  sheet = 'Sheet 1',
  cols = 1:18,
  rows = 1:1,
  rule = 'A1<>""',
  type = "expression",
  style = header_style
)
openxlsx::saveWorkbook(skills_wb, skill_path, overwrite = TRUE)
shell.exec(file_path)
