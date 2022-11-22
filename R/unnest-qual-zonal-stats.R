unnest_dict <- function(sf_object = NULL, dict_col = 'histogram', pct = T, na_to_0 = T) {
  library(dplyr)
  library(tidyr)
  l <- lapply(
    X = sf_object[[dict_col]], 
    function(x) {
      if(pct)
        as_tibble(jsonlite::parse_json(x)) %>%
        {if(nrow(.)==0) tibble(base = 0) else mutate(., base = sum(.))} %>%
        {if(.[['base']]==0) . else mutate_at(.tbl = ., vars(-base), ~ ./base*100)}
      else
        as_tibble(jsonlite::parse_json(x))
    }
  )
  df <- bind_rows(l)
  sf_object_unnested <- bind_cols(sf_object %>% select(-all_of(dict_col)), df) %>% 
    relocate(all_of(sort(grep('hex_id|geom', colnames(.), value = T, invert = T))), .after = last_col()) %>% 
    { if(na_to_0) replace(., is.na(.), 0) else . }
  sf_return <- sf_object_unnested
  return(sf_return)
}

create_unnested_gpkg <- function(
    nested_gpkg_path = NULL, dict_col = 'histogram',
    eqv_tab_path = NULL,  eqv_value_col = 'Value',
    eqv_desc_col = 'Description') {
  # Packages
  library(sf)
  library(dplyr)
  library(tidyr)
  library(readr)
  
  # Read GEE results from a GeoPackage file
  nested_sf <- invisible(st_read(nested_gpkg_path, quiet = T))
  
  # Unnest with function unnest_dict
  unnested_sf <- unnest_dict(sf_object = nested_sf, dict_col = dict_col)
  
  # Mapping sf with common key and description from equivalency table.
  # To create the equivalency table, copy from HTML and paste as data.frame (using datapasta).
  # This is the source of the equivalency table in this example:
  # https://developers.google.com/earth-engine/datasets/catalog/COPERNICUS_Landcover_100m_Proba-V-C3_Global#bands
  eqv_tab_src <- read_csv(eqv_tab_path)
  # eqv_tab_src
  # Prepare for joinning
  eqv_tab <- eqv_tab_src %>%
    select(name = all_of(eqv_value_col), description = all_of(eqv_desc_col)) %>% 
    mutate(name = as.character(name), description = gsub('\\..*$', '', description))
  # eqv_tab
  values_available <- eqv_tab[['name']][eqv_tab[['name']] %in% colnames(unnested_sf)]
  values <- range(values_available)
  
  # Joinning via value to have description
  unnested_sf_out <- unnested_sf %>%
    pivot_longer(cols = all_of(values[1]):all_of(values[2])) %>%
    inner_join(eqv_tab) %>% 
    select(-name) %>% 
    pivot_wider(names_from = 'description', values_from = 'value')
  # unnested_sf_out
  
  # Test if rowwise totals add up to 100 percent (if applicable) and if nrows input == nrows output
  for_testing_0_100 <- round(rowSums(unnested_sf_out %>% st_drop_geometry %>% select(-hex_id, -base), na.rm = T), 2)
  if(all(for_testing_0_100 %in% c(0, 100)))
    cat('\nSuccess: All rowwise totals add up to 100 percent\n')
  else
    cat("\nPlease check: at least, one rowwise totals doesn't add up to 100 percent\n")
  if(nrow(nested_sf) == nrow(unnested_sf_out))
     cat("\nSuccess: number of rows from input and output file does match\n")
  else
    cat("\nPlease check: the number of rows from input and output file doesn't match\n")
  return(unnested_sf_out)
}

batch_unnest <- function(
    res_available = 4:7, # Input resolutions are available (e.g. H3 cells from resolution 4 to 7)
    base_name = NULL, # Character string of the root that forms the base of the name of input files
    results_path = NULL, # Character string of the relative or full path for the output files
    eqv_tab_filename = NULL # Character string of the relative or full path of the table of equivalencies values <=> names
    ) {
  lapply(
    res_available,
    function(x) {
      filename <- paste0(base_name, x, '.gpkg')
      unnested <- create_unnested_gpkg(
        nested_gpkg_path = paste0(results_path, filename),
        eqv_tab_path = paste0(
          results_path,
          eqv_tab_filename))
      st_write(
        obj = unnested,
        dsn = paste0(
          results_path,
          gsub('.gpkg', '_unnested.gpkg', filename)),
        delete_dsn = T)
    }
  )
}
