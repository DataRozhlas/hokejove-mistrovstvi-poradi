ig.getData = ->
  d3.tsv.parse ig.data.vitezove, (row) ->
    currentContiguousYear = []
    contiguousYears = []
    years = for field, value of row
      continue if field == 'země'
      rank = (parseInt value, 10) || null
      year = parseInt field, 10
      d = {year, rank, code: row['země'].toLowerCase!}
      if rank
        currentContiguousYear.push d
      else
        if currentContiguousYear.length > 1
          contiguousYears.push currentContiguousYear
        currentContiguousYear = []
      d
    if currentContiguousYear.length > 1
      contiguousYears.push currentContiguousYear
    validYears = years.filter (.rank)
    {code: row['země'], years, validYears, contiguousYears}
