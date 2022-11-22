#' Calculate zonal statistics
#'
#' Given a vector layer of zones and a raster (e.g. value layer)
#' the function calculates the zonal statisitics of choice
#'
#' @param zones name of an object of class \code{sf}
#' containing the zones
#' @param value name of an object of class \code{stars}
#' @param extent (optional) name of an object of class \code{sf} 
#' spanning the desired area to create the hex bins
#' @param buffer (optional) buffer distance in kilometeres)
#' relative to the extent object to span the hex bins
#' @param ... other arguments passed to \code{sf::aggregate}
#' @details
#'
#' @return
#'
#' @examples
#'
#' @import sf
#' @import stars
#' @importFrom h3jsr polygon_to_cells cell_to_polygon
#' @importFrom units set_units
#' @export

zonal_stats <- function(zones = NULL, value = NULL, fun = NULL, ...,
                        h3 = ifelse(is.null(zones), T, F), resolution = NULL, extent = NULL, buffer = 0L) {
  library(sf)
  library(stars)
  library(units)
  library(h3jsr)
  if(is.null(zones) && !h3)
    stop("Argument zones is empty, no default value. Please, choose h3 or a zone layer")
  if(is.null(value))
    stop("Argument value is empty, no default value")
  if(is.null(fun))
    stop("Argument fun is empty, no default value")
  if(h3) {
    if(is.null(extent))
      stop("Argument extent is empty, no default value")
      if(buffer > 0L) {
        e1 <- st_buffer(extent, dist = set_units(buffer, km))
        extent <- e1
      }
    if(is.null(resolution))
      stop("Argument resolution is empty, no default value")
    z1 <- polygon_to_cells(extent, res = resolution, simple = FALSE)
    z2 <- cell_to_polygon(unlist(z1$h3_addresses), simple = FALSE)
    zones <- z2
  }
  value_crop <- value[zones]
  zs <- aggregate(value_crop, zones, fun, ...) |> st_as_sf() |> st_join(zones, join = st_within)
  return(zs)
}