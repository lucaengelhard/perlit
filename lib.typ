#let draw-obsidian-graph(path, ..args) = {
  import "@preview/cetz:0.4.2": canvas, draw
  let data = json(path)

  let normalize-coords(items) = {
    // Extract all x and y values
    let min-x = calc.min(..items.map(it => it.x))
    let max-x = calc.max(..items.map(it => it.x + it.width))
    let min-y = calc.min(..items.map(it => it.y))
    let max-y = calc.max(..items.map(it => it.y + it.height))

    let span-x = max-x - min-x
    let span-y = max-y - min-y
    let scale = calc.max(span-x, span-y)


    // Safe normalization
    let norm(val, min) = {
      if scale == 0 { 0 } else { (val - min) / scale }
    }

    // Apply normalization
    items.map(it => (
      it
        + (
          x: norm(it.x, min-x),
          y: -norm(it.y, min-y),
          width: it.width / scale,
          height: it.height / scale,
          scale: scale,
        )
    ))
  }


  let draw-nodes() = {
    import draw: *

    let nodes = normalize-coords(data.nodes)

    let label(pos, text) = {
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

    for n in nodes {
      rect(
        (n.x, n.y),
        (n.x + n.width, n.y - n.height),
        stroke: black,
        name: n.id,
      )

      if n.type == "text" {
        content(
          (n.x + n.width / 2, n.y - n.height / 2),
          n.text,
          anchor: "center",
        )
      }

      if n.type == "group" {
        label(
          (n.x, n.y - n.height),
          n.label,
        )
      }
    }

    for e in data.edges {
      if "fromEnd" in e {
        if e.fromEnd == "arrow" {
          set-style(mark: (symbol: ">", end: ">"))
        }
      } else if "toEnd" in e {
        if e.toEnd == "none" {
          set-style(mark: (symbol: none, end: none))
        }
      } else {
        set-style(mark: (symbol: none, end: ">"))
      }

      let side_map = (
        "top": ".north",
        "bottom": ".south",
        "left": ".west",
        "right": ".east",
      )


      line(e.fromNode + side_map.at(e.fromSide), e.toNode + side_map.at(e.toSide), name: e.id)
      if "label" in e { label((e.id + ".start", 50%, e.id + ".end"), e.label) }
    }
  }


  figure(layout(ly => canvas(length: ly.width, draw-nodes(), padding: 1em)), ..args)
}
