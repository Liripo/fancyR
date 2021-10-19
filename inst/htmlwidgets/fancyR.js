HTMLWidgets.widget({

  name: 'fancyR',

  type: 'output',

  factory: function(el, width, height) {

    // TODO: define shared variables for this instance
    console.log(el)

    return {

      renderValue: function(x) {

        // code to render the widget
        el.innerHTML = x.html;
        var mainCarousel = new Carousel(document.getElementById(el.id),
        {
          // 增加点
          Dots: x.dots,
          on: {
            createSlide: (carousel, slide) => {
              if(x.panzoom) {
                slide.Panzoom = new Panzoom(slide.$el.querySelector(".panzoom"), {
                  panOnlyZoomed: true,
                });
              };
            },
            deleteSlide: (carousel, slide) => {
              if (x.panzoom && slide.Panzoom) {
                slide.Panzoom.destroy();

                slide.Panzoom = null;
              }
            },
          },
        });
        Fancybox.bind('[data-fancybox = ="gallery"]', {
            //option
            Thumbs: false,
            //鼠标下拉close fancybox操作
            dragToClose: false,
            Image: {
              zoom: false,
              click: false,
              wheel: "slide",
            },
            on: {
              // Move caption inside the slide
              reveal: (f, slide) => {
                slide.$caption && slide.$content.appendChild(slide.$caption);
              },
            },
        });
      },
      resize: function(width, height) {

        // TODO: code to re-render the widget with a new size

      }

    };
  }
});
