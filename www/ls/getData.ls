ig.getData = ->
  d3.tsv.parse ig.data.vitezove, (row) ->
    currentContiguousYear = []
    contiguousYears = []
    country = {
      code: row['země'].toLowerCase!
      first: 0
      second: 0
      third: 0
    }
    years = for field, value of row
      continue if field == 'země'
      rank = (parseInt value, 10) || null
      year = parseInt field, 10
      poradatel = ig.poradatelstvi[year] == country.code
      d = {year, rank, country, poradatel}
      if rank == 1 => country.first++
      if rank == 2 => country.second++
      if rank == 3 => country.third++
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
    {country, years, validYears, contiguousYears}
