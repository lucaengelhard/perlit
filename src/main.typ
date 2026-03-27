#import "@preview/cetz:0.4.2": canvas, draw

#import "draw/node.typ": draw_nodes
#import "draw/edge.typ": draw_edges

#import "utils/helpers.typ": array_to_dict, get_color, get_needed_file_path, parse_nodes
#import "utils/components.typ": label
#import "utils/paths.typ": beautify_paths, bezier_at, line_at
#import "utils/files.typ": handle_file

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

