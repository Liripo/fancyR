#' @description 获取fancy需要的html
#' @importFrom tools file_ext
get_fancy_html <- function(file,data_caption = TRUE,thumbnail = FALSE,panzoom = FALSE) {
  #每个图片的caption
  if(isTRUE(data_caption)) {
    data_caption <- file
  }else if (isFALSE(data_caption)) {
    data_caption <- NULL
  }
  mime <- tools::file_ext(file)
  tag_res <- switch(mime,
    "html" = app_html(file),
    "pdf" = app_pdf(file,thumbnail = thumbnail),
    "mp4" = app_video(file,thumbnail = thumbnail),
    app_img(file,data_caption)
  )

  if(panzoom) {
    tag_res$attribs <- c(tag_res$attribs,class = "panzoom__content")
    tag_res <- tagAppendChildren(tags$div(class = "panzoom"),tag_res)
  }
  tag <- tag_carousel <- tags$div(class = "carousel__slide",tag_res)
  tag
}

app_html <- function(src,width = "100%",height = "100%") {
  tags$iframe(
    src = src,
    width = width,
    height = height,
    frameborder="no",
    border=0,
    scrolling="no",
    marginwidth=0,
    marginheight=0
  )
}

app_img <- function(src,data_caption) {
  tags$a(`data-fancybox` = "gallery",
         `data-caption` = data_caption,
         href = src,
         tags$img(src = src))
}

app_pdf <- function(src,thumbnail = FALSE) {
  if(!thumbnail) {
    thumbnail <- tempfile(fileext = "png")
    magick::image_read_pdf(src,pages = 1) |>
      magick::image_write(path = thumbnail)
  }
  tag <- tags$a(href = src,
                `data-type` = "pdf",
                tags$img(src = thumbnail))
}


app_video <- function(src,thumbnail = FALSE) {
  if(!thumbnail) {
    thumbnail <- tempfile(fileext = "png")
    magick::image_read_video(src,format = "png") |>
      magick::image_write(path = thumbnail)
  }
  tag <- tags$a(href = src,
                `data-type` = "video",
                `data-plyr` = NA,
                `data-fancybox` = "gallery",
                tags$img(src = thumbnail))
}
