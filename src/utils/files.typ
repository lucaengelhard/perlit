#import "helpers.typ": get_needed_file_path

#let handle_file(node) = {
  let internal_path = get_needed_file_path(node.file)

  let img_filetypes = ("png", "jpg", "gif", "svg", "pdf", "webp")
  let img_match = img_filetypes.find(ext => internal_path.ends-with("." + ext))

  if img_match != none {
    image(get_needed_file_path(node.file), width: (node.bx - node.x) * 41em)
  }
}
