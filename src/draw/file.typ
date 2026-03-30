#let get_file_name(path) = {
  path.split("/").last()
}

#let get_file_ext(path) = {
  path.split(".").last()
}

#let handle_canvas(path, recursive_caller: (..args) => {}, ..args) = {
  recursive_caller(path, ..args)
}

#let handle_file(node, file-handlers: (:), ..args) = {
  let ext = get_file_ext(node.file)

  if ext in file_handlers {
    file-handlers.at(ext)(node, path: get_file_name(node.file), ..args)
  } else {
    panic(
      "No file handler defined for [" + ext + "] (" + get_file_name(node.file) + ")",
    )
  }
}
