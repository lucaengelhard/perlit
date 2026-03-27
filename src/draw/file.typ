#import "../utils/helpers.typ": get_file_name, get_needed_file_path

#let handle_file(node, recursive_caller: function, ..args) = {
  let internal_path = get_file_name(node.file)

  let img_filetypes = ("png", "jpg", "gif", "svg", "pdf", "webp")
  let img_match = img_filetypes.find(ext => internal_path.ends-with("." + ext))

  if img_match != none {
    //image(internal_path, width: (node.bx - node.x) * 41em)
  }
}
