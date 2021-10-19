#' @export
fancy_dep <- function() {
  htmlwidgets::getDependency(name="fancyR", package="fancyR")
}

#' @description 单个htmlwidget
#' @param  widget 小部件
fancy_htmlewidget <- function(widget) {
  widget_deps <- findDependencies(widget)
  #高度默认500px,宽度默认100%
  widget_html <- as.character(as.tags(widget)) |> HTML()
  tag <- tags$div(class = "carousel__slide",widget_html)

  tag <- attachDependencies(tag,c(widget_deps,fancy_dep()))
  tag
}

#' @param  widgets 小部件列表
#' @export
fancy_htmlewidgets <- function(widgets,id = NULL,...) {
  stopifnot(is_tag_list(widgets))
  taglist <- tagList(purrr::map(widgets,fancyapp_htmlewidget))

  if(is.null(id))id <- paste("fancyR",htmlwidgets:::createWidgetId(),sep = "-")
  tags$div(id = id,...,class = "carousel fancyR",taglist)
}

is_tag_list <- function(taglist) {
  inherits(taglist,'shiny.tag.list')
}
