#import "../utils/helpers.typ": get_file_name

#let handle_canvas(path, recursive_caller: (..args) => {}, ..args) = {
  recursive_caller(path, ..args)
}

#let handle_file(node, length: length, ..args) = {
  let internal_path = get_file_name(node.file)

  if internal_path.ends-with(".canvas") {
    handle_canvas(internal_path, length: node.width * length * 0.8, ..args)
  }

  let img_filetypes = ("png", "jpg", "gif", "svg", "pdf", "webp")
  let img_match = img_filetypes.find(ext => internal_path.ends-with("." + ext))
  if img_match != none {
    image(internal_path, width: (node.bx - node.x) * 41em)
  }
}
