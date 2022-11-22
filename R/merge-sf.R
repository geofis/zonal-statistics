merge_sf <- function(...) {
  l <- as.list(...)
  l_sf <- lapply(l, st_read, quiet = T, optional = T)
  output_sf <- do.call(rbind, l_sf)
  return(output_sf)
}
