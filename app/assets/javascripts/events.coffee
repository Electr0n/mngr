jQuery ->
  $(".js-example-tokenizer").select2(tags: true)

class RichMarkerBuilder extends Gmaps.Google.Builders.Marker

@buildMap = (markers) ->
  handler = Gmaps.build 'Google', { builders: { Marker: RichMarkerBuilder} }

  handler.buildMap { provider: {}, internal: {id: 'map'} }, ->
    markers = handler.addMarkers(markers)
    handler.bounds.extendWith(markers)
    handler.fitMapToBounds()