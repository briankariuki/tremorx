function preloadImages(array, waitForOtherResources, timeout) {
  var loaded = false,
    list = preloadImages.list,
    images = array.slice(0),
    t = timeout || 15 * 1000,
    timer;
  if (!preloadImages.list) {
    preloadImages.list = [];
  }
  if (!waitForOtherResources || document.readyState === "complete") {
    loadNow();
  } else {
    window.addEventListener("load", function () {
      clearTimeout(timer);
      loadNow();
    });
    // in case window.addEventListener doesn't get called (sometimes some resource gets stuck)
    // then preload the images anyway after some timeout time
    timer = setTimeout(loadNow, t);
  }

  function loadNow() {
    if (!loaded) {
      loaded = true;
      for (var i = 0; i < images.length; i++) {
        var image = new Image();
        image.onload =
          image.onerror =
          image.onabort =
            function () {
              var index = list?.indexOf(this);
              if (index !== -1) {
                // remove image from the array once it's loaded
                // for memory consumption reasons
                list?.splice(index, 1);
              }
            };
        list?.push(image);
        image.src = images[i];
      }
    }
  }
}

export default ImageCache = {
  mounted() {
    style = this.el.currentStyle || window.getComputedStyle(this.el, false);
    bgImage = style.backgroundImage.slice(4, -1).replace(/"/g, "");

    if (bgImage) {
      preloadImages([bgImage], true);
    } else {
      preloadImages([this.el.src], true);
    }
  },
  destroyed() {},
};
