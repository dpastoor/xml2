#' Retrieve an attribute.
#'
#' Use \code{xml_attrs} to retrieve all attributes values as a character vector.
#' Use \code{xml_attr} to retrieve the value of single attribute. If the
#' attribute doesn't exist, it will be returned as an \code{NA}.
#' Use \code{xml_has_attr} to test if an attribute is present.
#'
#' @inheritParams xml_name
#' @param attr Name of attribute to extract.
#' @return For \code{xml_attr}, a character vector. If an attribute is not
#'  presented, its value will be missing. For \code{xml_has_attr},
#'  a logical vector. For \code{xml_attr} a list of named character vectors.
#'  If any attrbutes have an associated namespace, the vector will have
#'  a \code{ns} attribute.
#' @export
#' @examples
#' x <- xml("<root id='1'><child id ='a' /><child id='b' d='b'/></root>")
#' xml_attr(x, "id")
#' xml_attrs(x)
#'
#' xml_attr(xml_children(x), "id")
#' xml_has_attr(xml_children(x), "id")
#' xml_attrs(xml_children(x))
#'
#' # Missing attributes give missing values
#' xml_attr(xml_children(x), "d")
#' xml_has_attr(xml_children(x), "d")
#'
#' # If the document has a namespace, use the ns argument and
#' # qualified attribute names
#' x <- xml('
#'  <root xmlns:b="http://bar.com" xmlns:f="http://foo.com">
#'    <doc b:id="b" f:id="f" id="" />
#'  </root>
#' ')
#' doc <- xml_children(x)[[1]]
#' ns <- xml_ns(x)
#'
#' xml_attrs(doc)
#' xml_attrs(doc, ns)
#'
#' # If you don't supply a ns spec, you get the first matching attribute
#' xml_attr(doc, "id")
#' xml_attr(doc, "b:id", ns)
#' xml_attr(doc, "id", ns)
xml_attr <- function(x, attr, ns = character()) {
  UseMethod("xml_attr")
}

#' @export
xml_attr.xml_nodeset <- function(x, attr, ns = character()) {
  vapply(x$nodes, node_attr, name = attr, ns = ns,
    FUN.VALUE = character(1))
}


#' @export
#' @rdname xml_attr
xml_has_attr <- function(x, attr, ns = character()) {
  !is.na(xml_attr(x, attr, ns = ns))
}

#' @export
#' @rdname xml_attr
xml_attrs <- function(x, ns = character()) {
  lapply(x$nodes, node_attrs, ns = ns)
}
