const dateOptions1 = {
  year: "2-digit",
  month: "numeric",
  day: "numeric",
  hour: "numeric",
  minute: "numeric",
};

const dateOptions2 = {
  year: "numeric",
  month: "long",
  day: "numeric",
  hour: "numeric",
  minute: "numeric",
};

const dateOptions3 = {
  month: "short",
  day: "numeric",
};

export default LocalTime = {
  mounted() {
    this.updated();
  },

  updated() {
    let dt = new Date(this.el.textContent);

    let format = dateOptions2;

    if (this.el.dataset.format) {
      switch (this.el.dataset.format) {
        case "dateOptions3":
          format = dateOptions3;
          break;

        case "dateOptions1":
          format = dateOptions1;
          break;

        default:
          format = dateOptions2;

          break;
      }
    }
    this.el.textContent = dt.toLocaleString("en-US", format);

    this.el.classList.remove("invisible");
  },
};
