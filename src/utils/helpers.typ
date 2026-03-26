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

#let bezier_at(p0, p1, p2, p3, t) = {
  let lerp(p, q, t) = {
    (
      (1 - t) * p.at(0) + t * q.at(0),
      (1 - t) * p.at(1) + t * q.at(1),
    )
  }

  let a = lerp(p0, p1, t)
  let b = lerp(p1, p2, t)
  let c = lerp(p2, p3, t)

  let d = lerp(a, b, t)
  let e = lerp(b, c, t)

  lerp(d, e, t)
}

#let line_at(points, t) = {
  if points.len() == 0 {
    none
  } else if points.len() == 1 {
    points.at(0)
  } else {
    // Step 1: compute segment lengths
    let seg-lengths = ()
    let total = 0.0

    for i in range(0, points.len() - 1) {
      let p0 = points.at(i)
      let p1 = points.at(i + 1)

      let dx = p1.at(0) - p0.at(0)
      let dy = p1.at(1) - p0.at(1)
      let len = calc.sqrt(dx * dx + dy * dy)

      seg-lengths.push(len)
      total += len
    }

    // Step 2: target distance
    let target = t * total

    // Step 3: walk segments
    let acc = 0.0

    for i in range(0, seg-lengths.len()) {
      let seg = seg-lengths.at(i)

      if acc + seg >= target {
        let p0 = points.at(i)
        let p1 = points.at(i + 1)

        let t = (target - acc) / seg

        let x = p0.at(0) + t * (p1.at(0) - p0.at(0))
        let y = p0.at(1) + t * (p1.at(1) - p0.at(1))

        return (x, y)
      }

      acc += seg
    }

    // Edge case: r == 1
    points.at(points.len() - 1)
  }
}
