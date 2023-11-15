library(tidyverse)
library(DBI)         # low-level database interface, comparable to what we saw in Python
library(RSQLite)     # database driver for SQLite
library(dbplyr)

# This says: I want to use SQLite, here's the filename.
# If using remote database, would use appropriate driver (likely MySQL or PostgreSQL driver)
# and would supple "connection string" that gives hostname, user account,
# database name, etc.
conn <- DBI::dbConnect(RSQLite::SQLite(), "database.db")

# All the magic is right here.  A dataframe view of a database table.
species <- tbl(conn, "Species")

# At this point, can use like any dataframe.
species %>%
  filter(Relevance=="Study species") %>%
  select(Scientific_name) %>%
  arrange(Scientific_name) %>%
  head(3)

# Add show_query() to the end to see what SQL it is sending!
species %>%
  filter(Relevance=="Study species") %>%
  select(Scientific_name) %>%
  arrange(Scientific_name) %>%
  head(3) %>% show_query()

# These "tables" are not true dataframes
str(species)  # weirdo structure, gibberish to me
dim(species)  # unknown row dimension

# What dbplyr is doing behind the scenes is translating
# all those dplyr operations into SQL, sending the
# SQL to the database, retrieving results, etc.

# Want a local copy that is a true dataframe?  Add collect():
local_copy <- species %>% collect()
str(local_copy)
dim(local_copy)

# Can do pretty much anything with these quasi-tables,
# including grouping, summarization, joins, etc.

species %>%
  group_by(Relevance) %>%
  summarize(num_species = n()) %>% show_query()

# Even mutating columns gets translated into SQL operations, wild!
species %>%
  mutate(Code = paste("X", Code)) %>% show_query()

# Limitation: no way to add or update data.  dbplyr is view only.
# If you want to add or update data, you'll need to use
# DBI functions.