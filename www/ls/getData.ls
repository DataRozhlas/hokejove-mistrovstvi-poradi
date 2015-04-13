ig.getData = ->
  d3.tsv.parse ig.data.vitezove, (row) ->
    years = for field, value of row
      continue if field == 'země'
      rank = (parseInt value, 10) || null
      year = parseInt field, 10
      {year, rank, code: row['země']}
    validYears = years.filter (.year)
    {code: row['země'], years, validYears}
