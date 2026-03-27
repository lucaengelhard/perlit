#import "@preview/cetz:0.4.2": canvas, draw

#import "../utils/helpers.typ": get_color
#import "../utils/components.typ": label

#let draw_nodes(nodes, ..args) = {
  import draw: *
  for (id, node) in nodes {
    rect(
      (node.x, node.y),
      (node.bx, node.by),
      stroke: get_color(node),
      fill: if node.type == "group" { get_color(node).transparentize(95%) } else { get_color(node).lighten(85%) },
    )

    if node.type == "text" {
      content(node.anchors.center, node.text)
    } else if node.type == "group" {
      label(node.anchors.northwest, node.label, get_color(node), justify: "west")
    } else if node.type == "file" {
      content(node.anchors.center, handle_file(node))
    }
  }
}
