#let array_to_dict(arr, key) = {
  assert(arr.all(el => key in el))

  let res = (:)

  for el in arr {
    res.insert(el.at(key), el)
  }

  res
}

#let parse_nodes(nodes) = {
  // Extract all x and y values
  let min-x = calc.min(..nodes.map(n => n.x))
  let max-x = calc.max(..nodes.map(n => n.x + n.width))
  let min-y = calc.min(..nodes.map(n => n.y))
  let max-y = calc.max(..nodes.map(n => n.y + n.height))

  let span-x = max-x - min-x
  let span-y = max-y - min-y
  let scale = calc.max(span-x, span-y)


  // Safe normalization
  let norm(val, min) = {
    if scale == 0 { 0 } else { (val - min) / scale }
  }

  let get_x(node) = norm(node.x, min-x)
  let get_y(node) = -norm(node.y, min-y)
  let get_width(node) = node.width / scale
  let get_height(node) = node.height / scale

  let create_anchors(node) = {
    (
      node
        + (
          anchors: (
            north: ((node.x + node.bx) / 2, node.y),
            northeast: (node.bx, node.y),
            east: (node.bx, (node.y + node.by) / 2),
            southeast: (node.bx, node.by),
            south: ((node.x + node.bx) / 2, node.by),
            southwest: (node.x, node.by),
            west: (node.x, (node.y + node.by) / 2),
            northwest: (node.x, node.y),
            center: ((node.x + node.bx) / 2, (node.y + node.by) / 2),
          ),
        )
    )
  }

  // Apply normalization
  nodes
    .map(node => (
      node
        + (
          x: get_x(node),
          y: get_y(node),
          width: get_width(node),
          height: get_height(node),
          bx: get_x(node) + get_width(node),
          by: get_y(node) - get_height(node),
        )
    ))
    .map(create_anchors)
}

#let get_color(element) = {
  if "color" not in element {
    black
  } else if element.color.first() != "#" {
    let color_map = (
      "0": black,
      "1": red,
      "2": orange,
      "3": yellow,
      "4": green,
      "5": teal,
      "6": purple,
    )

    if element.color in color_map {
      color_map.at(element.color)
    } else {
      black
    }
  } else {
    rgb(element.color)
  }
}

#let get_file_name(path) = {
  path.split("/").last()
}

#let get_needed_file_path(path) = {
  "/obsgraph/files/" + get_file_name(path)
}
