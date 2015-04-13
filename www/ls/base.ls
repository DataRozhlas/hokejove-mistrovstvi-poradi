data = ig.getData!
container = d3.select ig.containers.base
cols = data.0.years.length
console.log data
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

svg = container.append \svg
  ..attr {width, height}

svg.selectAll \g.nation .data data .enter!append \g
  ..attr \class \nation
  ..selectAll \g.rank .data (.validYears) .enter!append \g
    ..attr \transform -> "translate(#{x it.year}, #{y it.rank})"
    ..append \image
      ..attr \xlink:href -> "../data/flags/#{it.code.toLowerCase!}.svg"
      ..attr \width cellSize
      ..attr \height cellSize
