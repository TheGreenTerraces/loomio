Loomio.Views.Utils ||= {}

class Loomio.Views.Utils.GraphView extends Backbone.View

  initialize: (options)->
    if @options.type == 'pie'
      @buildPie()

  buildPie: ()->
    data = @options.data
    pie = jQuery.jqplot(@options.id_string, [data],
      {
        seriesDefaults: {
          renderer: jQuery.jqplot.PieRenderer,
          rendererOptions: {
            sliceMargin:8
            padding: 10
          }
        },
        legend: { show: @options.legend, location: 'e' }
        grid: { background:'rgba(0,0,0,0)', shadow: false, borderWidth: 0 }

        seriesColors: [ "#90D490", "#F0BB67", "#D49090", "#dd0000", '#ccc']

      }
     )
