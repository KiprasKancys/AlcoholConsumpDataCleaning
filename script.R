library(dplyr)
library(reshape2)
library(RMySQL)

geo <- read.csv('Geography.csv', stringsAsFactors = FALSE)

fls <- list.files(pattern = "^[S]")

df1398 <- read.csv(fls[1], stringsAsFactors = FALSE)
names(df1398) <- c('Country', 'Year', 'BeerConsumption', 'WineConsumption', 'SpiritsConsumption', 'OtherConsumption')

df1398 <- df1398 %>%
        slice(2:nrow(df1398)) %>%
        melt(id.vars = c("Country", "Year"), variable.name = "Variable", value.name = "DataValue")


df1401 <- read.csv(fls[2], stringsAsFactors = FALSE)
names(df1401) <- c('Country', '2010', '2005')
df1401 <- df1401 %>%
    slice(2:nrow(df1401)) %>%
    melt(id.vars = "Country", variable.name = "Year", value.name = "DataValue") %>%
    mutate(Variable = "AlcoholConsumptionRecorded")

df1405 <- read.csv(fls[3], stringsAsFactors = FALSE)
names(df1405) <- c('Country', 'DataValue')
df1405 <- df1405 %>%
    slice(2:nrow(df1405)) %>%
    mutate(Year = 2010) %>%
    mutate(Variable = "AlcoholConsumptionByTurist")

df1406 <- read.csv(fls[4], stringsAsFactors = FALSE)
names(df1406) <- c('Country', '2010', '2005')
df1406 <- df1406 %>%
    slice(2:nrow(df1406)) %>%
    melt(id.vars = "Country", variable.name = "Year", value.name = "DataValue") %>%
    mutate(Variable = "AlcoholConsumptionUnrecorded")

df <- rbind(df1398, df1401, df1405, df1406)

df <- df %>%
    mutate(Country = ifelse(Country == 'Antigua and Barbuda', 'Antigua', Country)) %>%
    mutate(Country = ifelse(Country == 'Bolivia (Plurinational State of)', 'Bolivia', Country)) %>%
    mutate(Country = ifelse(Country == 'Bosnia and Herzegovina', 'Bosnia-Herzegovina', Country)) %>%
    mutate(Country = ifelse(Country == 'Brunei Darussalam', 'Brunei', Country)) %>%
    mutate(Country = ifelse(Country == "CĆ´te d'Ivoire", "Cōte d'Ivoire", Country)) %>%
    mutate(Country = ifelse(Country == 'Cabo Verde', 'Cape Verde', Country)) %>%
    mutate(Country = ifelse(Country == 'Congo', 'Congo-Brazzaville', Country)) %>%
    mutate(Country = ifelse(Country == 'Democratic Republic of the Congo', 'Congo, Democratic Republic', Country)) %>%
    mutate(Country = ifelse(Country == "Democratic People's Republic of Korea", 'North Korea', Country)) %>%
    mutate(Country = ifelse(Country == 'Iran (Islamic Republic of)', 'Iran', Country)) %>%
    mutate(Country = ifelse(Country == 'Republic of Korea', 'South Korea', Country)) %>%
    mutate(Country = ifelse(Country == 'Republic of Moldova', 'Moldova', Country)) %>%
    mutate(Country = ifelse(Country == 'Russian Federation', 'Russia', Country)) %>%
    mutate(Country = ifelse(Country == 'Saint Lucia', 'St Lucia', Country)) %>%
    mutate(Country = ifelse(Country == 'Saint Vincent and the Grenadines', 'St Vincent and the Grenadines', Country)) %>%
    mutate(Country = ifelse(Country == 'Sao Tome and Principe', 'Sao Tomé e Prķncipe', Country)) %>%
    mutate(Country = ifelse(Country == 'Syrian Arab Republic', 'Syria', Country)) %>%
    mutate(Country = ifelse(Country == 'The former Yugoslav republic of Macedonia', 'Macedonia', Country)) %>%
    mutate(Country = ifelse(Country == 'United Kingdom of Great Britain and Northern Ireland', 'United Kingdom', Country)) %>%
    mutate(Country = ifelse(Country == 'United Republic of Tanzania', 'Tanzania', Country)) %>%
    mutate(Country = ifelse(Country == 'United States of America', 'USA', Country)) %>%
    mutate(Country = ifelse(Country == 'Venezuela (Bolivarian Republic of)', 'Venezuela', Country)) %>%
    mutate(Country = ifelse(Country == 'Viet Nam', 'Vietnam', Country)) %>%
    mutate(Country = ifelse(Country == 'Saint Kitts and Nevis', 'St Kitts', Country)) %>%
    mutate(Country = ifelse(Country == "Lao People's Democratic Republic", 'Laos', Country)) %>%
    mutate(DataValue = ifelse(DataValue == '', NA, DataValue)) %>%
    mutate(DataValue = ifelse(DataValue == 'No data', NA, DataValue))



df <- left_join(df, geo, by = c('Country' = 'GeographyName'))

write.csv(df, 'AlcoholConsumption.csv', row.names = FALSE)
