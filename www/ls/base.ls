data = ig.getData!
container = d3.select ig.containers.base
cols = data.0.years.length
rows = 17
cellWidth = 43_px
cellHeight = 38_px
width = cols * cellWidth
height = rows * cellHeight
startYear = 1920
endYear = 2014

y = d3.scale.linear!
  ..domain [1 rows]
  ..range [0 height]
x = d3.scale.linear!
  ..domain [startYear, endYear]
  ..range [0 width]

container.append \div .attr \class \years
  ..selectAll \span .data [startYear to endYear] .enter!append \span
    ..html -> it
    ..style \left -> "#{x it}px"

container.append \div .attr \class \medal-bands
  ..selectAll \div .data [1 to 3] .enter!append \div

svg = container.append \svg
  ..attr {width: width + 25, height}
path = d3.svg.line!
  ..x -> "#{13 + x it.year}"
  ..y -> "#{13 + y it.rank}"

nationPaths = svg.selectAll \g .data data .enter!append \g
  ..attr \class \nation
  ..selectAll \path .data (.contiguousYears) .enter!append \path
    ..attr \d (contiguousYear) ->
      o = []
      indices = contiguousYear.length - 1
      o.push contiguousYear[0]
      for {year, rank}, index in contiguousYear
        if index != 0
          o.push {year: year - 0.38, rank}
        if index != indices
          o.push {year: year + 0.38, rank}
      o.push contiguousYear[*-1]
      path o

flags = container.append \div
  ..attr \class \flags

nationFlags = flags.selectAll \.nation .data data .enter!append \div
  ..attr \class \nation
  ..selectAll \div.rank .data (.validYears) .enter!append \div
    ..attr \class \rank
    ..style \top -> "#{y it.rank}px"
    ..style \left -> "#{x it.year}px"
    ..append \div
      ..attr \class -> "img #{it.country.code}"
      ..style \background-image -> "url('../data/flags-png/Image-#{it.country.code}.png')"

graphTipContainer = container.append \div
  ..attr \graph-tip-container

container.append \div
  ..attr \class \interaction-pane
  ..selectAll \div.nation .data data .enter!append \div
    ..attr \class \nation
    ..selectAll \div.point .data (.validYears) .enter!append \div
      ..attr \class \year
      ..style \top -> "#{y it.rank}px"
      ..style \left -> "#{x it.year}px"
      ..on \mouseover -> highlightCountry it.country, it
      ..on \touchstart -> highlightCountry it.country, it
      ..on \mouseout -> downlightNation!
graphTip = new ig.GraphTip graphTipContainer

highlightCountry = (country, {rank, year}) ->
  [xCoord, yCoord] = [(x year) + 13, (y rank)+72]
  graphTip.display xCoord, yCoord, "<b>#{ig.nations[country.code]}</b>
    <span class='medals'><span>#{country.first}</span><span>#{country.second}</span><span>#{country.third}</span></span>"
  [svg, flags].forEach -> it.classed \active yes
  [nationPaths, nationFlags].forEach ->
    it.classed \active (.country == country)

downlightNation = ->
  graphTip.hide!
  [svg, flags].forEach -> it.classed \active no
  [nationPaths, nationFlags].forEach ->
    it.classed \active no


new ig.Scroller container, width + 40
