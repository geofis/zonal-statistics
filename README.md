Estadística zonal de información geoespacial de República Dominicana,
usando Google Earth Engine, Python y R
================
10-11-2022

José Ramón Martínez Batlle, Universidad Autónoma de Santo Domingo (UASD)
<br> Email: jmartinez19@uasd.edu.do <br> GitHUb: @geofis

<!-- [![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.6991441.svg)](https://doi.org/10.5281/zenodo.6991441) -->
<!-- Citar este repo usando el siguiente formato (entrada BibTeX [aquí](#entrada-bibtex)): "José Ramón Martínez Batlle. (2022). geofis/forest-loss-fire-reproducible: Preparing for publication (v0.0.2). Zenodo. https://doi.org/10.5281/zenodo.6991441" -->

# Introducción

> Si necesitas descargar los archivos reusltantes, visita [esta
> ruta](out/) o descarga el comprimido del repo [aquí]()
> <!-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! -->

> Si quieres consultar el código con el que generé los archivos
> resultantes del *spatial binning*, ve [aquí](#archivos-resultantes)

Las variables ambientales o de hábitat, son esenciales **en estudios de
ecología numérica y en geomorfología**. Este tipo de variables abarcan
distintos atributos del ambiente, entre los que destacan la topografía,
geomorfología, geología, climatología, la población humana o la densidad
de carreteras. Asimismo, en décadas recientes, se han incorporado a los
análisis ecológicos, atributos de hábitat colectados por medio de
sensores a bordo de satélites de observación de la Tierra
(e.g. reflectancia de la superficie del planeta por sensores pasivos, o
retrodispersión por sensores activos).

Varias plataformas en la nube han creado catálogos de información
ambiental de escala planetaria, la cual es a su vez producida,
comúnmente, por grupos de investigación y académicos de diversos países.
Asimismo, las plataformas en la nube más populares, ofrecen planes
gratuitos de acceso a los datos y a sus recursos de hardware, lo cual
supone una mejora significativa en cuanto a disponibilidad de datos y
medios. Esta revolución ha impulsado el acceso a un nutrido catálogo de
datos ambientales, ha favorecido el desarrollo de nuevas líneas de
estudio en ecología (y geografía física en general), y ha permitido
resolver problemas de investigación que en el pasado jamás se habría
pensado que podrían resolverse.

Plataformas como el Earth Engine de Google (Google Earth Engine o
simplemente “GEE”), la Planetary Computer de Microsoft, los recursos de
Maxar y de Planet (Google, 2022; Maxar Technologies, 2022; Microsoft,
2022; Planet Labs PBC, 2022), ofrecen datos en forma de superficies
continuas (e.g., imágenes ráster) o colecciones de capas apiladas, las
cuales deben procesarse previamente para consolidarlas en una base de
referencia común antes de realizar cualquier estudio.

En República Dominicana, una parte de la información de ámbito nacional,
ha permanecido poco accesible al público, y su aprovechamiento en el
ámbito de la investigación ha sido limitado. Por otra parte, la
generación de datos nacionales, se ha caracterizado en muchos por
emplear metodologías no reproducibles y, en algunos casos, no
declaradas. A esto se suma el hecho que, buena parte de la información
que sí es accesible, fue generada con referencia a unidades
administrativas “al uso”, abarcando en muchos casos territorios
heterogéneos. Otra dificultad asociada es el hecho de que diversos
estudios han producido mapas sin tener en cuenta potenciales usos
posteriores, por lo que su reaprovechamiento requiere de un esfuerzo
previo de depuración y normalización.

El presente estudio tiene por objetivo producir información ambiental
sobre República Dominicana, usando un índice espacial regular, a partir
de datos abiertos y accesibles, y empleando *scripts* reproducibles.
Concretamente, agrupé espacialmente (*spatial binning*) variables
procedentes de superficies continúas, que representan atributos
topográficos, geomorfológicos, de uso y cobertura del suelo,
climátológicos, de hetereogeneidad de hábitat, de carreteras y de
población. Para garantizar el reaprovechamiento de la información,
calculé estadística zonal respecto de celdas hexagonales regulares que
fungen como índice espacial. El conjunto de mapas generados constituye
una fuente de información con gran potencial para su uso en distintos
ámbitos de la ecología numérica y espacial. Asimismo, la metodología
empleada tiene potencial de aplicación en estudios posteriores que
requieran de datos sistemáticamente generados y accesibles.

# Metodología

Produje información territorial usando estadística zonal (agrupamiento
espacial o *spatial binning*) referido a celdas hexagonales de la
biblioteca H3 (e.g. índice espacial) de República Dominicana, a
[resoluciones](https://h3geo.org/docs/core-library/restable/) 4, 5, 6,
7. Para esta labor, desarrollé *scripts* y funciones de Python y de R,
que aprovecharon tanto el catálogo de información como los recursos de
computación en la nube (*cloud computing*) del Google Earth Engine
(GEE). Este tipo herramientas, basadas en computación en la nube (GEE),
tiene como ventaja principal el mayor rendimiento y menor tiempo de
ejecución requerido si se compara con recursos de hardware de
escritorio. Su desventaja su principal desventaja es que, al tratarse de
un recurso en línea, el usuario aumenta su dependencia de servicios
externos, algo que para producir información de territorios pequeños,
quizá no es lo más recomendable.

Adicionalmente, además del flujo anterior, creé un conjunto de *scripts*
y funciones de R para generar resultados similares a los obtenidos por
medio de GEE, empleando recursos de hardware propios, software libre y
paquetes de R para gestión de información geoespacial. Incluí algunas
aplicaciones fácilmente realizables en una PC de escritorio de
prestaciones moderadas. Incluí esta modalidad de procesamiento pensando
en potenciales usuarios que no disponen de las habilidades de
programación en el GEE, o que simplemente necesitan realizar sencillas
operaciones de procesamiento geoespacial en PC local sin necesidad de
depender de la nube.

## Procesamiento usando GEE, Python y R

Esta modalidad consistió en procesar grandes volumenes de datos
espaciales en la nube, y procesarlos posteriormente en una PC de
escritorio de prestaciones medias. En concreto, se realizaron múltiples
procesamientos de *spatial binning* sobre celdas hexagonales H3, usando
como capas de “valor” múltiples variables disponibles como *assets* en
GEE. Estas capas de valores reunían variables tanto cualitativas como
cuantitativas, alojadas previamente como *assets* del catálogo del GEE,
o subidas exprofeso como *assets* de usuario a dicha plataforma. Las
variables disponibles en GEE abarcan atributos muy diversos, tales como
topográficos, morfológicos, de uso y cobertura del suelo, climáticos, de
hetereogeneidad de hábitat, de carreteras y de población.

Las instrucciones para el procesamiento en la nube fueron enviadas a la
API del GEE por medio de un *script* de Python (especialmente de la
librería `ee`), el cual se encuentra disponible en este [Jupyter
Notebook](gee_python/zonal_statistics_using_ee.ipynb). Una vez
descargados los resultados del *spatial binning* a la PC local, se
aplicó posproceso con scripts y funciones de R para unir capas y
desagrupar atributos anidados.

Para las variables cuantitativas se obtuvo la **media en su escala de
medición original para cada celda H3**, y de las cualitativas se obtuvo
**la frecuencia relativa de representación de cada clase respecto del
total de píxeles con datos en cada celda H3** (más detalles, en la
sección [The Python code](#the-python-code)). En este último caso, fue
necesario realizar posproceso en R para “desagrupar” (*unnest*) los
resultados anidados descargados desde GEE (e.g. diccionarios de Python).
Finalmente, como parte del posproceso en R, se realizaron uniones de
resultados y exportación

Las fuentes empleadas fueron las siguientes:

-   CHELSA (Karger et al., 2017)

> Nota: el repo está “vivo”, por lo que nuevas variables y métodos de
> agrupamiento se añadirán en el futuro.

## Procesamiento usando *scripts* y funciones de R, pensados para cómputos pequeños, y PC de prestaciones modestas

La segunda modalidad consistió en realizar *spatial binning* en PC local
usando *scripts* y funciones de R.

Dado el alto volumen de datos procesados, esta alternativa se abandonó
en beneficio de la primera (procesamiento en la nube). Aunque no produjo
resultados específicos, el código empleado en las pruebas originales se
incluye en esta sección.

# Resultados

![Vaiables disponibles / Available variables](img/all_vars_res_5.jpg)

<!-- <ENG> -->

This repo consolidates my (@geofis) latest zonal statistics workflows
using Google Earth Engine results, as well as my own R functions which
generates zonal statistics from rasters and vectors.

# Archivos resultantes de estadística zonal (*spatial binning*) según celdas

Visitar este directorio

<!-- </ENG> -->

# Cloud processing (GEE) and post-processing in R

## The Python code

See Jupyter Notebook [here](gee_python/zonal_statistics_using_ee.ipynb).

In this section, I include examples on how to properly extract the zonal
statistics results generated by the Google Earth Engine. The sources for
this examples are mean values of quantitative layers, as well as
percentages of cover of qualitative variables for each H3 hexagon at
different resolutions (4 through 7). In EE, I generate GeoDataFrames
which I process with R code.

This is the EE code that generates mean values of quantitative variables
for each H3 hexagon:

``` python
import geopandas as gpd
zone_stats = image.reduceRegions(collection=features, reducer=ee.Reducer.mean(), scale=image.projection().nominalScale(), tileScale=1).getInfo()
zone_stats = gpd.GeoDataFrame.from_features(zone_stats, crs='epsg:4326')
zone_stats.fillna(0, inplace=True)
```

This is the EE code that generates percentages of cover of qualitative
variables for each H3 hexagon:

``` python
import geopandas as gpd
zone_stats = image.reduceRegions(collection=features, reducer=ee.Reducer.frequencyHistogram(), scale=image.projection().nominalScale(), tileScale=1).getInfo()
zone_stats = gpd.GeoDataFrame.from_features(zone_stats, crs='epsg:4326')
zone_stats
```

Then, I exported every zonal stats generated with this sample code:

``` python
zone_stats.to_file(filename='output_geopackage.gpkg', driver='GPKG', layer='layer name')
```

## Unnesting dictionary columns from qualitative source

In this section, I include the code used to convert the key +
frequencies dictionary column generated in EE, to named unnested
columns. I also merge, at the end of this section, all the variables
obtained for each resolution level, including the quantitative ones.

### Load tools and define paths

``` r
library(tmap)
library(tidyverse)
source('R/unnest-qual-zonal-stats.R')
source('R/merge-sf.R')
source('R/st-read-rename-cols-based-on-prefix.R')
results_path <- 'gee_python/out/result_layers/'
final_results <- 'out/'
```

### Global SRTM Landforms

``` r
# Base name
base_name <- 'global_srtm_landforms_res_'

# Merge res_7 gpkg
build_name <- function(x) gsub('#', x, 'global_srtm_landforms#_res_7.gpkg')
gsl_res7 <- merge_sf(paste0(results_path, c(build_name('1'), build_name('2'), build_name('3'))))
# st_write(gsl_res7, paste0(results_path, base_name, '7.gpkg'), delete_dsn = T)

# Batch unnesting
batch_unnest(
  res_available = 4:7,
  base_name = base_name,
  results_path = results_path,
  eqv_tab_filename = 'global_SRTM_landforms_value_description_equivalencies.csv')
```

### ESA WorldCover 10m v200

``` r
# Base name
base_name <- 'esa_worldcover_10m_v200_res_'

# Merge res_7 gpkg
build_name <- function(x) gsub('#', x, 'esa_worldcover_10m_v200_#_res_7.gpkg')
ewc_res7 <- merge_sf(paste0(results_path, c(build_name('1'), build_name('2'), build_name('3'))))
# st_write(ewc_res7, paste0(results_path, base_name, '7.gpkg'), delete_dsn = T)

# Batch unnesting
batch_unnest(
  res_available = 4:7,
  base_name = base_name,
  results_path = results_path,
  eqv_tab_filename = 'esa_worldcover_10m_v200_res_4_value_description_equivalencies.csv')
```

### Copernicus Global Land Cover Layers: CGLS-LC100 Collection 3

``` r
# Base name
base_name <- 'copernicus_global_landcover_100m_res_'

# Merge res_7 gpkg
build_name <- function(x) gsub('#', x, 'copernicus_global_landcover_100m_#_res_7.gpkg')
cgl_res7 <- merge_sf(paste0(results_path, c(build_name('1'), build_name('2'), build_name('3'))))
# st_write(cgl_res7, paste0(results_path, base_name, '7.gpkg'), delete_dsn = T)

# Batch unnesting
batch_unnest(
  res_available = 4:7,
  base_name = base_name,
  results_path = results_path,
  eqv_tab_filename = 'copernicus_global_landcover_value_description_equivalencies.csv')
```

### Global Habitat Heterogeneity

``` r
# Base name
base_name <- 'global_habitat_heterogeneity_res_'

# Merge res_7 gpkg
build_name <- function(x) gsub('#', x, 'global_habitat_heterogeneity#_res_7.gpkg')
ghh_res7 <- merge_sf(paste0(results_path, c(build_name('1'), build_name('2'), build_name('3'))))
# st_write(ghh_res7, paste0(results_path, base_name, '7.gpkg'), delete_dsn = T)
```

### WorldClim V1 BIO variables

``` r
# Base name
base_name <- 'worldclim_v1_bio_variables_res_'

# Merge res_7 gpkg
build_name <- function(x) gsub('#', x, 'worldclim_v1_bio_variables_#_res_7.gpkg')
wcv1bio_res7 <- merge_sf(
  paste0(results_path, c(build_name('1'), build_name('2'), build_name('3'))))
# st_write(wcv1bio_res7, paste0(results_path, base_name, '7.gpkg'), delete_dsn = T)
```

### Geomorpho90m (quantitative variables)

``` r
# Base name
base_name <- 'geomorpho90m_res_'

# Merge res_7 gpkg
build_name <- function(x) gsub('#', x, 'geomorpho90m_#_res_7.gpkg')
geom90m_res7 <- merge_sf(
  paste0(results_path, c(build_name('1'), build_name('2'), build_name('3'))))
# st_write(geom90m_res7, paste0(results_path, base_name, '7.gpkg'), delete_dsn = T)
```

### Geomorpho90m, geomorphons (qualitative variables)

``` r
# Base name
base_name <- 'geomorpho90m_geomorphons_res_'

# Merge res_7 gpkg
build_name <- function(x) gsub('#', x, 'geomorpho90m_geomorphons_#_res_7.gpkg')
geom90mgeo_res7 <- merge_sf(paste0(results_path, c(build_name('1'), build_name('2'), build_name('3'))))
# st_write(geom90mgeo_res7, paste0(results_path, base_name, '7.gpkg'), delete_dsn = T)

# Batch unnesting
batch_unnest(
  res_available = 4:7,
  base_name = base_name,
  results_path = results_path,
  eqv_tab_filename = 'geomorpho90m_geomorphons.csv')
```

### CGIAR Elevation SRTM90 V4

``` r
# Base name
base_name <- 'cgiar_elevation_srtm90v4_res_'

# Merge res_7 gpkg
build_name <- function(x) gsub('#', x, 'cgiar_elevation_srtm90v4_#_res_7.gpkg')
srtm90v4_res7 <- merge_sf(
  paste0(results_path, c(build_name('1'), build_name('2'), build_name('3'))))
# st_write(srtm90v4_res7, paste0(results_path, base_name, '7.gpkg'), delete_dsn = T)
```

### CHELSA v21 BIO variables

-   Prepare layers for uploading. Export TIF files to reduce their size
    and to conform EE standard.

``` bash
for i in *tif; do i=${i/.tif/}; gdal_translate -a_nodata 65535 \
  -co COMPRESS=DEFLATE -projwin -75.0 20.5 -68.0 17.4 -of GTiff \
  ${i}.tif ${i}_nd_crop.tif; done
```

-   Uploaded the files generated to EE.

-   Processed with the Jupyter Notebook
    `zonal_statistics_using_ee.ipynb`, and then post-processed the
    results as follows:

``` r
# Base name
base_name <- 'chelsa_v21_bio_variables_res_'

# Merge res_7 gpkg
build_name <- function(x) gsub('#', x, 'chelsa_v21_bio_variables_#_res_7.gpkg')
chelsav21bio_res7 <- merge_sf(
  paste0(results_path, c(build_name('1'), build_name('2'), build_name('3'))))
# st_write(chelsav21bio_res7, paste0(results_path, base_name, '7.gpkg'), delete_dsn = T)
```

### Hansen et al. (2013)

#### Year-2000 percent tree cover (quantitative)

``` r
# Base name
base_name <- 'hansen_gfc_v19_ptc_y2000_res_'

# Merge res_7 gpkg
build_name <- function(x) gsub('#', x, 'hansen_gfc_v19_ptc_y2000_#_res_7.gpkg')
hansengfcv19ptc_res7 <- merge_sf(
  paste0(results_path, c(build_name('1'), build_name('2'), build_name('3'))))
# st_write(hansengfcv19ptc_res7, paste0(results_path, base_name, '7.gpkg'), delete_dsn = T)
```

#### Year of forest loss (qualitative)

``` r
# Base name
base_name <- 'hansen_gfc_v19_ly_res_'

# Merge res_7 gpkg
build_name <- function(x) gsub('#', x, 'hansen_gfc_v19_ly_#_res_7.gpkg')
hansengfcv19ly_res7 <- merge_sf(paste0(results_path, c(build_name('1'), build_name('2'), build_name('3'))))
# st_write(hansengfcv19ly_res7, paste0(results_path, base_name, '7.gpkg'), delete_dsn = T)

# Batch unnesting
batch_unnest(
  res_available = 4:7,
  base_name = base_name,
  results_path = results_path,
  eqv_tab_filename = 'hansen_gfc_v19_loss_year_value_description_equivalencies.csv')
map(
  .x = 4:7,
  .f = function(x) {
    foo <- st_read(paste0(results_path, 'hansen_gfc_v19_ly_res_', x, '_unnested.gpkg'), optional=T) %>% 
      relocate(all_of(sort(grep('hex_id|geom', colnames(.), value = T, invert = T))), .after = last_col())
    st_write(foo, paste0(results_path, 'hansen_gfc_v19_ly_res_', x, '_unnested2.gpkg'))}
)
```

### Distance to OSM roads and trails

-   Downloaded OSM database of DR and Haiti. For this, pressed the
    Export button from OSM web GUI while logged in.

-   Selected “Downloads from Geofabrik”.

-   Then clicked over “Central America \> Haiti and Dominican Republic”

-   Clicked
    [haiti-and-domrep-latest-free.shp.zip](https://download.geofabrik.de/central-america/haiti-and-domrep-latest-free.shp.zip).

-   Reprojected `gis_osm_roads_free_1.shp` file to UTM:

``` python
"{ 'INPUT' : 'gis_osm_roads_free_1.shp', 'OPERATION' : '+proj=pipeline +step +proj=unitconvert +xy_in=deg +xy_out=rad +step +proj=utm +zone=19 +ellps=WGS84', 'OUTPUT' : 'gis_osm_roads_free_1_utm.shp', 'TARGET_CRS' : QgsCoordinateReferenceSystem('EPSG:32619') }"
```

-   Generated a raster file of 1 arc-second from
    `gis_osm_roads_free_1_utm.shp`, with:

``` bash

gdal_rasterize -l gis_osm_roads_free_1_utm -burn 1.0 \
  -tr 10.0 10.0 -a_nodata 0.0 \
  -te 161500 1897000 593020 2250010 -ot Float32 -of GTiff \
  gis_osm_roads_free_1_utm.shp \
  osm_roads_1_arc_sec_utm.tif
```

-   Generated a distance raster with:

``` bash
gdal_proximity.py -srcband 1 -distunits GEO \
  -ot Float32 -of GTiff \
  osm_roads_1_arc_sec_utm.tif \
  osm_roads_1_arc_sec_utm_dist.tif
```

-   Warped to 4326 and masked:

``` bash
gdalwarp -overwrite -s_srs EPSG:32619 -t_srs EPSG:4326 -of GTiff -co COMPRESS=DEFLATE \
  -dstnodata -3.402823466e+38 -cutline dr.gpkg -cl pais -crop_to_cutline \
  osm_roads_1_arc_sec_utm_dist.tif \
  osm_roads_1_arc_sec_ll_dist_clipped.tif
```

-   Finally, the processing of the 3 chunks of resolution-7 hexagons
    (merging)

``` r
# Base name
base_name <- 'distance_to_osm_roads_res_'

# Merge res_7 gpkg
build_name <- function(x) gsub('#', x, 'distance_to_osm_roads_#_res_7.gpkg')
distosmroads_res7 <- merge_sf(
  paste0(results_path, c(build_name('1'), build_name('2'), build_name('3'))))
# st_write(distosmroads_res7, paste0(results_path, base_name, '7.gpkg'), delete_dsn = T)
```

### WorldPop Global Project Population Data: Constrained Estimated Age and Sex Structures of Residential Population per 100x100m Grid Square (UN adjusted)

``` r
# Base name
base_name <- 'worldpop_gp_constrained_unadj_2020_res_'

# Merge res_7 gpkg
build_name <- function(x) gsub('#', x, 'worldpop_gp_constrained_unadj_2020_#_res_7.gpkg')
worldpopconsunadj2020_res7 <- merge_sf(
  paste0(results_path, c(build_name('1'), build_name('2'), build_name('3'))))
# st_write(worldpopconsunadj2020_res7, paste0(results_path, base_name, '7.gpkg'), delete_dsn = T)
```

## Merge all the GeoPackages in one

``` r
res <- 4:7
merge_quant_qual_l <- map(4:7, function(res) {
  first_sf <- list(
    st_read_rename(
      paste0(results_path, 'esa_worldcover_10m_v200_res_', res, '_unnested.gpkg'),
      col_prefix = 'ESA'))
  remainder_sf <- purrr::map2(
    paste0(
      results_path,
      c(paste0('copernicus_global_landcover_100m_res_', res, '_unnested.gpkg'),
        paste0('global_srtm_landforms_res_', res, '_unnested.gpkg'),
        paste0('global_habitat_heterogeneity_res_', res, '.gpkg'),
        paste0('worldclim_v1_bio_variables_res_', res, '.gpkg'),
        paste0('chelsa_v21_bio_variables_res_', res, '.gpkg'),
        paste0('geomorpho90m_res_', res, '.gpkg'),
        paste0('geomorpho90m_geomorphons_res_', res, '_unnested.gpkg'),
        paste0('cgiar_elevation_srtm90v4_res_', res, '.gpkg'),
        paste0('hansen_gfc_v19_ptc_y2000_res_', res, '.gpkg'),
        paste0('hansen_gfc_v19_ly_res_', res, '_unnested.gpkg'),
        paste0('distance_to_osm_roads_res_', res, '.gpkg'),
        paste0('worldpop_gp_constrained_unadj_2020_res_', res, '.gpkg'))),
    c('CGL', 'GSL', 'GHH', 'WCL', 'CH-BIO', 'G90', 'G90-GEOM',
      'CGIAR-ELE', 'GFC-PTC YEAR 2000', 'GFC-LOSS', 'OSM-DIST', 'GP-CONSUNadj YEAR 2020'),
    st_read_rename, first = F)
  merge_quant_qual <- Reduce(
    function(...) merge(..., by='hex_id', all.x=TRUE),
    c(first_sf, remainder_sf))
  return(merge_quant_qual)
})
names(merge_quant_qual_l) <- paste('H3 resolution:', 4:7)
merge_quant_qual_l
saveRDS(merge_quant_qual_l, paste0(final_results, 'list_with_all_sources_all_resolution.RDS'))
map(1:4, function(x)
  st_write(
    obj = merge_quant_qual_l[[x]],
    dsn = paste0(final_results, 'all_sources_all_variables_res_', 3 + x, '.gpkg'),
    delete_dsn = T))

# All variables!!
# jpeg('img/all_vars_res_5.jpg', width = 3840, height = 2032, res = 250)
all_vars_res_5 <- merge_quant_qual_l$`H3 resolution: 5` %>%
  select(-matches(c('hex_id| base|^WCL bio19'))) %>%
  pivot_longer(names_to = 'variable', values_to = 'value', -geometry) %>%
  tm_shape() +
  tm_fill(col='value', palette = "BrBG", size = 0.1, style = 'fisher', legend.is.portrait = T) +
  tm_borders(col = 'grey15', lwd = 0.3) +
  tm_facets(by = "variable", ncol = 15, nrow = 9, free.coords = FALSE, free.scales = TRUE) +
  tm_layout(panel.label.size = 1.5, legend.title.size = 1,
            legend.text.size = 1, legend.position = c('right', 'bottom'))
all_vars_res_5
# dev.off()

merge_quant_qual_l$`H3 resolution: 7` %>% select(matches('^WCL')) %>%
  pivot_longer(names_to = 'variable', values_to = 'value', -geometry) %>%
  tm_shape() +
    tm_fill(col='value', palette = "BrBG", size = 0.1, style = 'fisher', legend.is.portrait = T) +
    tm_borders(col = 'grey15', lwd = 0.3) +
    tm_facets(by = "variable", ncol = 5, nrow = 4, free.coords = FALSE, free.scales = TRUE) +
    tm_layout(panel.label.size = 1.5, legend.title.size = 1, legend.text.size = 1, legend.position = c('right', 'bottom'))

merge_quant_qual_l$`H3 resolution: 6` %>% select(matches('^CH-BIO')) %>%
  pivot_longer(names_to = 'variable', values_to = 'value', -geometry) %>%
  tm_shape() +
    tm_fill(col='value', palette = "BrBG", size = 0.1, style = 'fisher', legend.is.portrait = T) +
    tm_borders(col = 'grey15', lwd = 0.3) +
    tm_facets(by = "variable", ncol = 5, nrow = 4, free.coords = FALSE, free.scales = TRUE) +
    tm_layout(panel.label.size = 1.5, legend.title.size = 1, legend.text.size = 1, legend.position = c('right', 'bottom'))

merge_quant_qual_l$`H3 resolution: 7` %>% select(matches('^ESA'), -matches('base')) %>%
  pivot_longer(names_to = 'variable', values_to = 'value', -geometry) %>%
  tm_shape() +
    tm_fill(col='value', palette = "BrBG", size = 0.1, style = 'fisher', legend.is.portrait = T) +
    tm_borders(col = 'grey15', lwd = 0.3) +
    tm_facets(by = "variable", ncol = 3, nrow = 3, free.coords = FALSE, free.scales = TRUE) +
    tm_layout(panel.label.size = 1.5, legend.title.size = 1, legend.text.size = 1, legend.position = c('right', 'bottom'))

merge_quant_qual_l$`H3 resolution: 6` %>% select(matches('^G90-GEOM'), -matches('base')) %>%
  pivot_longer(names_to = 'variable', values_to = 'value', -geometry) %>%
  tm_shape() +
    tm_fill(col='value', palette = "-BrBG", size = 0.1, style = 'fisher', legend.is.portrait = T) +
    tm_borders(col = 'grey15', lwd = 0.3) +
    tm_facets(by = "variable", ncol = 4, nrow = 3, free.coords = FALSE, free.scales = TRUE) +
    tm_layout(panel.label.size = 1.5, legend.title.size = 1, legend.text.size = 1, legend.position = c('right', 'bottom')) + 
  tm_shape(st_read('inst/extdata/dr.gpkg')) + 
  tm_borders(col = 'grey15', lwd = 1)

merge_quant_qual_l$`H3 resolution: 6` %>% select(matches('^GSL'), -matches('base')) %>%
  pivot_longer(names_to = 'variable', values_to = 'value', -geometry) %>%
  tm_shape() +
    tm_fill(col='value', palette = "-BrBG", size = 0.1, style = 'fisher', legend.is.portrait = T) +
    tm_borders(col = 'grey15', lwd = 0.3) +
    tm_facets(by = "variable", ncol = 4, nrow = 4, free.coords = FALSE, free.scales = TRUE) +
    tm_layout(panel.label.size = 1.5, legend.title.size = 1, legend.text.size = 1, legend.position = c('right', 'bottom')) + 
  tm_shape(st_read('inst/extdata/dr.gpkg')) + 
  tm_borders(col = 'grey15', lwd = 1)
```

# WITHOUT GOOGLE EARTH ENGINE (value layers dowloaded from original sources)

## Use cases of mean zonal statistics (only for quantitative value layers)

### Load packages and functions

``` r
library(sf)
library(stars)
library(ggplot2)
source('R/zonal-stats.R')
```

### Using only one single value source

#### Hex grid already available (from file)

``` r
data_path <- 'inst/extdata/'
dr <- st_read(paste0(data_path, 'dr.gpkg'), layer = 'pais') # From ONE
shannon <- read_stars(paste0(data_path,'shannon_01_05_1km_uint16.tif')) # From Global Habitat Heterogeneity
zones <- readRDS(paste0(data_path, 'sp_index.RDS')) # From h3jsr package, res=5, rd_extra as extent
zs_sp_index_from_file <- zonal_stats(zone = zones, value = shannon, fun = mean, na.rm=T)
zs_sp_index_from_file
ggplot_template <- list(
  geom_sf(lwd=0),
  geom_sf(aes(), fill = NA, data = dr),
  theme_bw(),
  scale_fill_distiller(type = 'seq', palette = 'YlOrBr'))
zs_sp_index_from_file %>%
  dplyr::rename(`Shannon diversity\n(MODIS-EVI)` = shannon_01_05_1km_uint16.tif) %>% 
  ggplot + aes(fill = `Shannon diversity\n(MODIS-EVI)`) + 
  ggplot_template
```

#### Hex grid purpose-built from `zonal_stats` function using a extent polygon from file, WITHOUT buffer zone around the extent polygon

``` r
dr_extra <- st_read(paste0(data_path, 'dr_extra.gpkg')) # From DR (ONE) GeoPackage > st_buffer, 2km
zs_sp_index_created_no_buf <- zonal_stats(value = shannon, fun = mean, na.rm=T,
                                   resolution = 5, extent = dr_extra)
zs_sp_index_created_no_buf
zs_sp_index_created_no_buf %>%
  dplyr::rename(`Shannon diversity\n(MODIS-EVI)` = shannon_01_05_1km_uint16.tif) %>% 
  ggplot + aes(fill = `Shannon diversity\n(MODIS-EVI)`) + 
  ggplot_template
```

#### Hex grid purpose-built from `zonal_stats` function using a extent polygon from file, WITH buffer zone (2 km) around the extent polygon

``` r
zs_sp_index_created_buf <- zonal_stats(value = shannon, fun = mean, na.rm=T,
                                   resolution = 5, extent = dr, buffer = 2)
zs_sp_index_created_buf
zs_sp_index_created_buf %>%
  dplyr::rename(`Shannon diversity\n(MODIS-EVI)` = shannon_01_05_1km_uint16.tif) %>% 
  ggplot + aes(fill = `Shannon diversity\n(MODIS-EVI)`) + 
  ggplot_template
```

### Using multiple value sources

#### Same dimensions

``` r
simpson <- read_stars(paste0(data_path, 'simpson_01_05_1km_uint16.tif'))
all.equal(st_dimensions(shannon), st_dimensions(simpson))
zs_sp_mult_values_same_dim <- zonal_stats(zone = zones, value = c(shannon, simpson), fun = mean, na.rm=T)
zs_sp_mult_values_same_dim
zs_sp_mult_values_same_dim <- zs_sp_mult_values_same_dim %>% 
  dplyr::rename(
    `Shannon diversity (MODIS-EVI)` = shannon_01_05_1km_uint16.tif,
    `Simpson (MODIS-EVI)` = simpson_01_05_1km_uint16.tif)
plot(zs_sp_mult_values_same_dim[c('Shannon diversity (MODIS-EVI)', 'Simpson (MODIS-EVI)')])
```

#### Different dimensions

``` r
gtopo <- read_stars(paste0(data_path, 'gt30w100n40.tif')) # + GTOPO 30
shannon_redim <- st_warp(shannon, gtopo)
all.equal(st_dimensions(shannon_redim), st_dimensions(gtopo))
zs_sp_mult_values_dif_dim <- zonal_stats(zone = zones, value = c(shannon_redim, gtopo), fun = mean, na.rm=T)
zs_sp_mult_values_dif_dim <- zs_sp_mult_values_dif_dim %>% 
  dplyr::rename(
    `Shannon diversity (MODIS-EVI)` = shannon_01_05_1km_uint16.tif,
    `GTOPO30` = gt30w100n40.tif)
plot(zs_sp_mult_values_dif_dim[c('Shannon diversity (MODIS-EVI)', 'GTOPO30')])
```

## More use cases of loading multiple star sources (not actually for computing zonal stats, only to show ways of building image stacks with `stars`)

### Geomorpho90m

``` r
geomorpho_file_paths <- list.files(
  path = '/media/jose/datos/geomorpho90m/',
  pattern = '_mosaico.tif$', recursive = T, full.names = T)
geomorpho_cube <- read_stars(geomorpho_file_paths)
```

### CHELSA, bio variables (gets locked, even with resolution 4 hexagons). The alternative was GEE.

``` r
chelsa_bio_file_paths <- list.files(
  path = '/media/jose/datos/CHELSA/envicloud/chelsa/chelsa_V2/GLOBAL/climatologies/1981-2010/bio/',
  pattern = '.tif$', recursive = T, full.names = T)
chelsa_bio_cube <- read_stars(chelsa_bio_file_paths)
```

### Entrada Bibtex del repo

<div id="refs" class="references csl-bib-body hanging-indent"
line-spacing="2">

<div id="ref-google2022" class="csl-entry">

Google. (2022). *Google earth engine*. Retrieved from
<https://earthengine.google.com>

</div>

<div id="ref-karger2017" class="csl-entry">

Karger, D. N., Conrad, O., Böhner, J., Kawohl, T., Kreft, H.,
Soria-Auza, R. W., … Kessler, M. (2017). Climatologies at high
resolution for the earth’s land surface areas. *Scientific Data*,
*4*(1), 170122. <https://doi.org/10.1038/sdata.2017.122>

</div>

<div id="ref-maxartechnologies2022" class="csl-entry">

Maxar Technologies. (2022). *Earth intelligence & space infrastructure*.
Retrieved from <https://www.maxar.com/>

</div>

<div id="ref-microsoft2022" class="csl-entry">

Microsoft. (2022). *Microsoft Planetary Computer*. Retrieved from
<https://planetarycomputer.microsoft.com/>

</div>

<div id="ref-planetlabspbc2022" class="csl-entry">

Planet Labs PBC. (2022). *Planet \| Homepage*. Retrieved from
<https://www.planet.com/>

</div>

</div>
