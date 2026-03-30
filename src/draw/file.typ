#let get_file_name(path) = {
  path.split("/").last()
}

#let get_file_ext(path) = {
  path.split(".").last()
}

#let get_clean_path(path) = {
  get_file_name(path)
}

#let handle_canvas(path, recursive_caller: (..args) => {}, ..args) = {
  recursive_caller(path, ..args)
}

#let handle_file(node, file_handlers: (:), ..args) = {
  let ext = get_file_ext(node.file)

  if ext in file_handlers {
    file_handlers.at(ext)(node, path: get_clean_path(node.file), ..args)
  } else {
    panic(
      "No file handler defined for [" + ext + "] (" + get_clean_path(node.file) + ")",
    )
  }
}
