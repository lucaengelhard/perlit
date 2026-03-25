#import "@preview/cetz:0.4.2": canvas, draw
#import "utils/data.typ": array_to_dict, parse_nodes
#import "utils/components.typ": label

#let draw_nodes(nodes, ..args) = {
  import draw: *
  for (id, node) in nodes {
    rect((node.x, node.y), (node.bx, node.by), stroke: black)

    if node.type == "text" {
      content(node.anchors.center, node.text)
    } else if node.type == "group" {
      label(node.anchors.southwest, node.label)
    }
  }
}

#let draw_edges(edges, nodes, curve: bool, ..args) = {
  import draw: *

  let side_map = (
    "top": "north",
    "bottom": "south",
    "left": "west",
    "right": "east",
  )

  let get_start(edge, nodes) = {
    nodes.at(edge.fromNode).anchors.at(side_map.at(edge.fromSide))
  }

  let get_target(edge, nodes) = {
    nodes.at(edge.toNode).anchors.at(side_map.at(edge.toSide))
  }

  let set_arrow(edge) = {
    if "fromEnd" in edge and edge.fromEnd == "arrow" {
      set-style(mark: (symbol: ">", end: ">"))
    } else if "toEnd" in edge and edge.toEnd == "none" {
      set-style(mark: (symbol: none, end: none))
    } else {
      set-style(mark: (symbol: none, end: ">"))
    }
  }

  let create_bezier_points(edge, nodes) = {
    let start = get_start(edge, nodes)
    let target = get_target(edge, nodes)

    let midX = (start.at(0) + target.at(0)) / 2
    let midY = (start.at(1) + target.at(1)) / 2

    let bezier_start = if edge.fromSide == "top" or edge.fromSide == "bottom" {
      (start.at(0), midY)
    } else {
      (midX, start.at(1))
    }

    let bezier_target = if edge.toSide == "top" or edge.toSide == "bottom" {
      (target.at(0), midY)
    } else {
      (midX, target.at(1))
    }

    (start: bezier_start, target: bezier_target)
  }

  for (id, edge) in edges {
    set_arrow(edge)

    let start = get_start(edge, nodes)
    let target = get_target(edge, nodes)
    let ctrl_points = create_bezier_points(edge, nodes)

    if curve {
      bezier(start, target, ctrl_points.start, ctrl_points.target, name: edge.id)
    } else {
      line(start, ctrl_points.start, ctrl_points.target, target, name: edge.id)
    }


    if "label" in edge { label((edge.id + ".start", 50%, edge.id + ".end"), edge.label) }
  }
}

#let render(nodes, edges, ..args) = {
  draw_nodes(nodes, ..args)
  draw_edges(edges, nodes, ..args)
}

#let draw_graph(path, curve: false, ..figargs) = {
  let data = json(path)
  let nodes = array_to_dict(parse_nodes(data.nodes), "id")
  let edges = array_to_dict(data.edges, "id")

  let args = (curve: curve)

  figure(
    layout(ly => canvas(
      length: ly.width,
      debug: false,
      render(
        nodes,
        edges,
        ..args,
      ),
    )),
    ..figargs,
  )
}

