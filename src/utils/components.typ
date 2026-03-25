#import "@preview/cetz:0.4.2": draw
#let label(pos, text) = {
  import draw: *
  content(
    pos,
    box(
      fill: white,
      inset: 2pt,
      stroke: none,
      text,
    ),
    anchor: "center",
  )
}
