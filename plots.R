library(checkpoint)
checkpoint::setSnapshot("2015-05-15")

library(dplyr)
library(magrittr)
library(readr)
library(ggplot2)
library(tidyr)

readings <- read_csv(
  "DATALOG.CSV",
  col_names = FALSE,
  col_type = list(
    col_skip(),
    col_double(),
    col_double(),
    col_double(),
    col_double(),
    col_double(),
    col_integer(),
    col_integer(),
    col_integer()
  )
) %>% 
  set_colnames(
    c(
      "temp0","temp1","temp2",
      "temp3","temp4","smc1",
      "smc2","smc3"
    )
  ) %>%
  mutate(
    hours = row_number()/2
  ) %>%
  gather(
    key,value,temp0:smc3
  ) %>%
  mutate(
    type = ifelse(grepl("temp",key,perl=TRUE),"temp","smc")
  )



readings %>%
  ggplot +
  aes(
    x = hours,
    y = value,
    colour = key
  ) +
  facet_wrap(
    ~type,
    ncol = 1,
    scales = "free"
  ) + 
  geom_line()
