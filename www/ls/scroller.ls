class ig.Scroller
  (@container, @width) ->
    width = width + 40
    window.scrollTo width - document.body.clientWidth, 0

    windowWidth = document.body.clientWidth
    @linkBack = container.append \a
      ..attr \class "navbutton backbutton"
      ..attr \href \#
      ..html "Historie"
      ..on \click ~>
        d3.event.preventDefault!
        targetX = currentPosition! - document.body.clientWidth
        d3.transition!
          .duration 800
          .tween "scroll" @scrollTween targetX
    @linkNext = container.append \a
      ..attr \class "navbutton nextbutton disabled"
      ..attr \href \#
      ..html "Současnost"
      ..on \click ~>
        d3.event.preventDefault!
        targetX = currentPosition! + document.body.clientWidth
        d3.transition!
          .duration 800
          .tween "scroll" @scrollTween targetX
    window.addEventListener "scroll" ~>
      x = currentPosition!
      @linkNext.classed \disabled x + document.body.clientWidth >= @width
      @linkBack.classed \disabled x == 0


  scrollTween: (targetX) ->
    ~>
      if targetX < 0 then targetX := 0
      if targetX > @width then targetX := @width
      x = currentPosition!
      interpolate = d3.interpolateNumber x, targetX
      (progress) -> window.scrollTo (interpolate progress), 0

currentPosition = ->
  window.pageXOffset || document.documentElement.scrollLeft


