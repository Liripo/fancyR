#' [fancyapp.js](https://github.com/fancyapps/ui)构建的htmlwidgets小部件
#'
#'
#' @import htmlwidgets
#' @param html fancyapp 自定义的html布局
#' @param file 文件名，支持mp4,html,pdf以及其他如png等
#' @param caption caption
#' @param footnote 脚注
#' @param data_caption 每个fancybox的caption
#' @param thumbnail 缩略图
#' @export
fancyR <- function(file,
                   caption = NULL,
                   footnote = NULL,
                   data_caption = TRUE,
                   thumbnail = FALSE,
                   width = NULL,
                   height = NULL,
                   elementId = NULL,
                   dots = TRUE,
                   panzoom = FALSE,
                   html = NULL) {
  if(is.null(html)) {
      taglist <- list()
      for (i in seq_along(file)) {
        if(!is.logical(thumbnail)) thumbnail <- thumbnail[i]
        if(!is.logical(data_caption)) data_caption <- data_caption[i]
        taglist[[i]] <- get_fancy_html(file[i],data_caption,thumbnail,panzoom = panzoom)
      }
      html <- tagList(taglist)
  }

  # forward options using x
  x = list(
    html = as.character(html),
    dots = dots,
    panzoom = panzoom
  )

  # create widget
  widget <- htmlwidgets::createWidget(
    name = 'fancyR',
    x,
    width = width,
    height = height,
    package = 'fancyR',
    elementId = elementId
  )
  if(!is.null(caption)) widget %<>% prependContent(tags$caption(caption,class = "htmlwidget-caption"))

  if(!is.null(footnote)) widget %<>% appendContent(tags$p(footnote),class = "htmlwidget-footnote")

  widget
}

# 自定义模板
widget_html.fancyR <- function(name, package, id, style, class,...) {
  htmltools::tags$div(id = id, style = style, class = paste(class,"carousel"))
}

#' @title Shiny bindings for fancyR
#'
#' Output and render functions for using fancyR within Shiny
#' applications and interactive Rmd documents.
#'
#' @param outputId output variable to read from
#' @param width,height Must be a valid CSS unit (like \code{'100\%'},
#'   \code{'400px'}, \code{'auto'}) or a number, which will be coerced to a
#'   string and have \code{'px'} appended.
#' @param expr An expression that generates a fancyR
#' @param env The environment in which to evaluate \code{expr}.
#' @param quoted Is \code{expr} a quoted expression (with \code{quote()})? This
#'   is useful if you want to save an expression in a variable.
#'
#' @name fancyR-shiny
#'
#' @export
fancyROutput <- function(outputId, width = '100%', height = '400px'){
  htmlwidgets::shinyWidgetOutput(outputId, 'fancyR', width, height, package = 'fancyR')
}

#' @rdname fancyR-shiny
#' @export
renderFancyR <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) { expr <- substitute(expr) } # force quoted
  htmlwidgets::shinyRenderWidget(expr, fancyROutput, env, quoted = TRUE)
}
