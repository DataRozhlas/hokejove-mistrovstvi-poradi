class ig.Scroller
  (@container, @width) ->
    width = width + 40
    document.body.scrollLeft = width - document.body.clientWidth
    windowWidth = document.body.clientWidth
    @linkBack = container.append \a
      ..attr \class "navbutton backbutton"
      ..attr \href \#
      ..html "Historie"
      ..on \click ~>
        targetX = currentPosition! - document.body.clientWidth
        d3.transition!
          .duration 800
          .tween "scroll" @scrollTween targetX
        @linkBack.classed \disabled targetX <= 0
        @linkNext.classed \disabled no
    @linkNext = container.append \a
      ..attr \class "navbutton nextbutton disabled"
      ..attr \href \#
      ..html "Současnost"
      ..on \click ~>
        targetX = currentPosition! + document.body.clientWidth
        d3.transition!
          .duration 800
          .tween "scroll" @scrollTween targetX
        @linkBack.classed \disabled no
        @linkNext.classed \disabled targetX + document.body.clientWidth >= @width


  scrollTween: (targetX) ->
    ~>
      if targetX < 0 then targetX := 0
      if targetX > @width then targetX := @width
      x = currentPosition!
      interpolate = d3.interpolateNumber x, targetX
      (progress) -> window.scrollTo (interpolate progress), 0

currentPosition = ->
  window.pageXOffset || document.documentElement.scrollLeft


