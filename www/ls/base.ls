data = ig.getData!
container = d3.select ig.containers.base
cols = data.0.years.length
rows = 17
cellSize = 50_px
width = cols * cellSize
height = rows * cellSize

y = d3.scale.linear!
  ..domain [1 rows]
  ..range [0 height]
x = d3.scale.linear!
  ..domain [1993 2014]
  ..range [0 width]

getScaleFactor = (code) ->
  switch code
  | "cze" => 1.5
  | otherwise => 1


svg = container.append \svg
  ..attr {width: width + 25, height}
path = d3.svg.line!
  ..x -> "#{16 + x it.year}"
  ..y -> "#{16 + y it.rank}"

nationPaths = svg.selectAll \g .data data .enter!append \g
  ..attr \class \nation
  ..selectAll \path .data (.contiguousYears) .enter!append \path
    ..attr \d -> path it

flags = container.append \div
  ..attr \class \flags

nationFlags = flags.selectAll \.nation .data data .enter!append \div
  ..attr \class \nation
  ..selectAll \div.rank .data (.validYears) .enter!append \div
    ..attr \class \rank
    ..style \top -> "#{y it.rank}px"
    ..style \left -> "#{x it.year}px"
    ..append \div
      ..attr \class -> "img #{it.code}"
      ..style \background-image -> "url('../data/flags-png/Image-#{it.code}.png')"

container.append \div
  ..attr \class \interaction-pane
  ..selectAll \div.nation .data data .enter!append \div
    ..attr \class \nation
    ..selectAll \div.point .data (.validYears) .enter!append \div
      ..attr \class \year
      ..style \top -> "#{y it.rank}px"
      ..style \left -> "#{x it.year}px"
      ..on \mouseover -> highlightNation it.code
      ..on \touchstart -> highlightNation it.code
      ..on \mouseout -> downlightNation!

highlightNation = (code) ->
  [svg, flags].forEach -> it.classed \active yes
  [nationPaths, nationFlags].forEach ->
    it.classed \active (.code == code)

downlightNation = ->
  [svg, flags].forEach -> it.classed \active no
  [nationPaths, nationFlags].forEach ->
    it.classed \active no
