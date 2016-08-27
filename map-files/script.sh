We’ll first filter the shapefile so that it includes only the UK features we need.
Then we’ll convert the shapefiles to intermediate GeoJSON before finally generating TopoJSON.

:: Filtering

    ne_10m_admin_0_map_subunits >>> subunits.json

        ogr2ogr \
          -f GeoJSON \                         # ouput type: GeoJSON
          -where "ADM0_A3 IN ('GBR', 'IRL')" \ # filter: only features whose ADM0_A3 property equals "GBR" or "IRL"
          subunits.json \                      # output filename
          ne_10m_admin_0_map_subunits.shp      # input filename


    ne_10m_populated_places.shp >>>> place.json

        ogr2ogr \
          -f GeoJSON \
          -where "ISO_A2 = 'GB' AND SCALERANK < 8" \
          places.json \
          ne_10m_populated_places.shp


    [HINT]
    If you’re unsure which properties to filter on, try dropping
    the where clause and viewing the GeoJSON output in a text editor.



:: Combining geoJSON file as a topoJSON file

    combine subunits.json and places.json into a single uk.json.

    topojson \
      -o uk.json \                # output topoJSON file name
      --id-property SU_A3 \       # promoting the SU_A3 property to the object id
      --properties name=NAME \    # renaming the NAME property to name
      -- \
      subunits.json \             # file to combine
      places.json                 # file to combine

