st_read_rename <- function(name, first = T, col_prefix = NULL) {
  result <- st_read(name, optional = T) %>%
    {
      if(first) {
        rename_at(., vars(-c('geom', 'hex_id')), ~ paste(col_prefix, .))
      } else {
        st_drop_geometry(x = .) %>% rename_at(., vars(-'hex_id'), ~ paste(col_prefix, .))
      }
    }
  return(result)
}
