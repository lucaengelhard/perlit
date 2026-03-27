#import "@preview/cetz:0.4.2": canvas, draw
#import "utils/helpers.typ": array_to_dict, get_color, get_needed_file_path, parse_nodes
#import "utils/components.typ": label
#import "utils/paths.typ": beautify_paths, bezier_at, line_at
#import "utils/files.typ": handle_file

#let draw_nodes(nodes, ..args) = {
  import draw: *
  for (id, node) in nodes {
    rect(
      (node.x, node.y),
      (node.bx, node.by),
      stroke: get_color(node),
      fill: get_color(node).transparentize(if node.type == "group" { 95% } else { 85% }),
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

  let create_bezier_points(edge, nodes, velocity: float) = {
    let start = get_start(edge, nodes)
    let target = get_target(edge, nodes)

    let get_velocity(point, side) = {
      let velocity_map = (
        "top": (point.at(0), point.at(1) + velocity),
        "bottom": (point.at(0), point.at(1) - velocity),
        "left": (point.at(0) - velocity, point.at(1)),
        "right": (point.at(0) + velocity, point.at(1)),
      )

      velocity_map.at(side)
    }

    let start_ctrl = get_velocity(start, edge.fromSide)
    let target_ctrl = get_velocity(target, edge.toSide)


    (
      start: start_ctrl,
      target: target_ctrl,
    )
  }

  for (id, edge) in edges {
    set_arrow(edge)


    let (start, target, ctrl_points) = beautify_paths(
      get_start(edge, nodes),
      get_target(edge, nodes),
      create_bezier_points(edge, nodes, ..args),
      edge,
    )

    if curve {
      bezier(
        start,
        target,
        ctrl_points.start,
        ctrl_points.target,
        name: edge.id,
        stroke: get_color(edge),
      )

      if "label" in edge {
        label(
          bezier_at(
            start,
            ctrl_points.start,
            ctrl_points.target,
            target,
            0.5,
          ),
          edge.label,
          get_color(edge),
        )
      }
    } else {
      line(
        start,
        ..ctrl_points.values(),
        target,
        name: edge.id,
        stroke: get_color(edge),
      )

      if "label" in edge {
        label(
          line_at((start, ..ctrl_points.values()), 0.5),
          edge.label,
          get_color(edge),
        )
      }
    }
  }
}

#let render(nodes, edges, ..args) = {
  draw_edges(edges, nodes, ..args)
  draw_nodes(nodes, ..args)
}

#let draw_graph(data, curve: true, velocity: 0.1, ..figargs) = {
  let nodes = array_to_dict(parse_nodes(data.nodes), "id")
  let edges = array_to_dict(data.edges, "id")

  let args = (curve: curve, velocity: if velocity == 0 { 0.00000001 } else { velocity })

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

