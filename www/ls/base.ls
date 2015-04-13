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
paths = svg.selectAll \g .data data .enter!append \g
  ..attr \class \nation
  ..selectAll \path .data (.contiguousYears) .enter!append \path
    ..attr \d -> path it

flags = container.append \div
  ..attr \class \flags

flags.selectAll \.nation .data data .enter!append \div
  ..attr \class \nation
  ..selectAll \g.rank .data (.validYears) .enter!append \div
    ..attr \class \rank
    ..style \top -> "#{y it.rank}px"
    ..style \left -> "#{x it.year}px"
    ..append \div
      ..attr \class -> "img #{it.code}"
      ..style \background-image -> "url('../data/flags/#{it.code}.svg')"

container.append \div
  ..attr \class \interaction-pane
