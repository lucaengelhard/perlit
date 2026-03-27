#import "@preview/cetz:0.4.2": canvas, draw

#import "draw/node.typ": draw_nodes, parse_nodes
#import "draw/edge.typ": draw_edges, parse_edges
#import "draw/label.typ": draw_labels

#import "utils/helpers.typ": array_to_dict

#let render(nodes, edges, ..args) = {
  draw_edges(edges, nodes, ..args)
  draw_nodes(nodes, ..args)
  draw_labels(edges, ..args)
}

#let draw_graph(data, curve: true, velocity: 0.1, ..figargs) = {
  let args = (
    curve: curve,
    velocity: if velocity == 0 { 0.00000001 } else { velocity },
  )

  let nodes = array_to_dict(parse_nodes(data.nodes), "id")
  let edges = array_to_dict(
    parse_edges(
      data.edges,
      nodes,
      velocity: args.velocity,
    ),
    "id",
  )


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

