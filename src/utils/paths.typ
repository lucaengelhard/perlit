#let beautify_paths(start, target, ctrl_points, edge) = {
  let ctrl = {
    if edge.fromSide == "top" and edge.toSide == "top" {
      if start.at(1) > target.at(1) {
        (
          start: ctrl_points.start,
          target: (ctrl_points.target.at(0), ctrl_points.start.at(1)),
        )
      } else {
        (
          start: (ctrl_points.start.at(0), ctrl_points.target.at(1)),
          target: ctrl_points.target,
        )
      }
    }

    if edge.fromSide == "bottom" and edge.toSide == "bottom" {
      if start.at(1) < target.at(1) {
        (
          start: ctrl_points.start,
          target: (ctrl_points.target.at(0), ctrl_points.start.at(1)),
        )
      } else {
        (
          start: (ctrl_points.start.at(0), ctrl_points.target.at(1)),
          target: ctrl_points.target,
        )
      }
    }

    if edge.fromSide == "right" and edge.toSide == "right" {
      if start.at(0) > target.at(0) {
        (
          start: ctrl_points.start,
          target: (ctrl_points.start.at(0), ctrl_points.target.at(1)),
        )
      } else {
        (
          start: (ctrl_points.target.at(0), ctrl_points.start.at(1)),
          target: ctrl_points.target,
        )
      }
    }

    if edge.fromSide == "left" and edge.toSide == "left" {
      if start.at(0) < target.at(0) {
        (
          start: ctrl_points.start,
          target: (ctrl_points.start.at(0), ctrl_points.target.at(1)),
        )
      } else {
        (
          start: (ctrl_points.target.at(0), ctrl_points.start.at(1)),
          target: ctrl_points.target,
        )
      }
    }

    if edge.fromSide == "right" and edge.toSide == "left" {
      if start.at(0) == target.at(0) {
        (
          start: (start.at(0) - 0.000001, start.at(1)),
          target: target,
        )
      } else if start.at(0) > target.at(0) {
        let midY = (ctrl_points.start.at(1) + ctrl_points.target.at(1)) / 2
        (
          start: ctrl_points.start,
          mid0: (ctrl_points.start.at(0), midY),
          mid1: (ctrl_points.target.at(0), midY),
          target: ctrl_points.target,
        )
      } else {
        let mid = (ctrl_points.start.at(0) + ctrl_points.target.at(0)) / 2
        (
          start: (mid, ctrl_points.start.at(1)),
          target: (mid, ctrl_points.target.at(1)),
        )
      }
    }

    if edge.fromSide == "left" and edge.toSide == "right" {
      if start.at(0) == target.at(0) {
        (
          start: (start.at(0) - 0.000001, start.at(1)),
          target: target,
        )
      } else if start.at(0) < target.at(0) {
        let midY = (ctrl_points.start.at(1) + ctrl_points.target.at(1)) / 2
        (
          start: ctrl_points.start,
          mid0: (ctrl_points.start.at(0), midY),
          mid1: (ctrl_points.target.at(0), midY),
          target: ctrl_points.target,
        )
      } else {
        let midX = (ctrl_points.start.at(0) + ctrl_points.target.at(0)) / 2
        (
          start: (midX, ctrl_points.start.at(1)),
          target: (midX, ctrl_points.target.at(1)),
        )
      }
    }

    if edge.fromSide == "top" and edge.toSide == "bottom" {
      if start.at(1) == target.at(1) {
        (
          start: (start.at(0), start.at(1) - 0.000001),
          target: target,
        )
      } else if start.at(1) > target.at(1) {
        let midX = (ctrl_points.start.at(0) + ctrl_points.target.at(0)) / 2
        (
          start: ctrl_points.start,
          mid0: (midX, ctrl_points.start.at(1)),
          mid1: (midX, ctrl_points.target.at(1)),
          target: ctrl_points.target,
        )
      } else {
        let midY = (ctrl_points.start.at(1) + ctrl_points.target.at(1)) / 2
        (
          start: (ctrl_points.start.at(0), midY),
          target: (ctrl_points.target.at(0), midY),
        )
      }
    }

    if edge.fromSide == "bottom" and edge.toSide == "top" {
      if start.at(1) == target.at(1) {
        (
          start: (start.at(0), start.at(1) - 0.000001),
          target: target,
        )
      } else if start.at(1) < target.at(1) {
        let midX = (ctrl_points.start.at(0) + ctrl_points.target.at(0)) / 2
        (
          start: ctrl_points.start,
          mid0: (midX, ctrl_points.start.at(1)),
          mid1: (midX, ctrl_points.target.at(1)),
          target: ctrl_points.target,
        )
      } else {
        let midY = (ctrl_points.start.at(1) + ctrl_points.target.at(1)) / 2
        (
          start: (ctrl_points.start.at(0), midY),
          target: (ctrl_points.target.at(0), midY),
        )
      }
    }
  }

  (
    start: start,
    target: target,
    ctrl_points: if ctrl == none { ctrl_points } else { ctrl },
  )
}

