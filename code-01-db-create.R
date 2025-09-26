library(tidyverse)
# install.packages("RSQLite")
library(DBI)
library(RSQLite)
library(dbplyr)

## --- The commented codes are for the creation of the database ...  --- ##
## --- ... for the Enggano-German Dictionary Shiny app

# con <- DBI::dbConnect(RSQLite::SQLite(), "kahler.sqlite")

## Retrieve data from the retro-digitised Enggano-German Dictionary (Rajeg et al. 2024)
### https://github.com/engganolang/kahler-1987/tree/0.0.2
# kahler_stem <- read_rds("../kahler1987-2023-06-10/data-main/stem_main_tb.rds")
# kahler_examples <- read_rds("../kahler1987-2023-06-10/data-main/examples_main_tb.rds")
# kahler_full <- read_rds("../kahler1987-2023-06-10/data-main/kahler_dict.rds")
# dbWriteTable(con, "stem", kahler_stem, overwrite = TRUE)
# dbWriteTable(con, "example", kahler_examples, overwrite = TRUE)
# dbWriteTable(con, "full", kahler_full, overwrite = TRUE)
## --- The commented codes are for the creation of the database  --- ##

kahler <- DBI::dbConnect(RSQLite::SQLite(), "kahler.sqlite")

dbListTables(kahler)

dbGetQuery(kahler, "SELECT * FROM stem WHERE (stem_form LIKE '%head%') OR (stem_EN LIKE '%head%') OR (stem_IDN LIKE '%head%') OR (stem_DE LIKE '%head%')")

tbl(kahler, "stem")

kstem <- tbl(kahler, "stem")

# lazy execution
filter_tb <- kstem |>
	filter(kms_Alphabet == "ə") |>
	select(stem_form, stem_DE, stem_EN, stem_IDN)

## see the query
filter_tb |> show_query()

## collect the data into R environment
collect(filter_tb)

dbDisconnect(kahler)
