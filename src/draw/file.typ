#let get_file_name(path) = {
  path.split("/").last()
}

#let get_file_ext(path) = {
  path.split(".").last()
}

#let handle_file(node, file_handlers: (:), length: length, ..args) = {
  let ext = get_file_ext(node.file)

  if ext in file_handlers {
    file_handlers.at(ext)(
      node: node,
      path: get_file_name(node.file),
      length: node.width * length,
      nested: true,
      ..args,
    )
  } else {
    panic(
      "No file handler defined for [" + ext + "] (" + get_file_name(node.file) + ")",
    )
  }
}
