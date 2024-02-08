export default Tooltip = {
  async mounted() {
    //Load tippyjs dependency
    await this.load();

    const placement = this.el.dataset.placement;
    const animation = this.el.dataset.animation;
    const theme = this.el.dataset.theme;
    const content = this.el.dataset.content;
    const size = this.el.dataset.size;
    const arrow = this.el.dataset.arrow;
    const arrowType = this.el.dataset.arrowType;
    const touch = this.el.dataset.touch;

    //Initialize tooltip
    tippy(this.el, {
      content: content,
      placement: placement,
      animation: animation,
      theme: theme,
      arrow: arrow,
      size: size,
      arrowType: arrowType,
      touch: touch,
    });
  },

  async load() {
    Promise.allSettled([
      await this.addScript("https://unpkg.com/@popperjs/core@2"),
      await this.addScript("https://unpkg.com/tippy.js@6"),
      await this.addLink(
        "https://unpkg.com/tippy.js@6.3.7/animations/perspective-extreme.css"
      ),
      await this.addLink(
        "https://unpkg.com/tippy.js@6.3.7/animations/perspective-subtle.css"
      ),
      await this.addLink(
        "https://unpkg.com/tippy.js@6.3.7/animations/perspective.css"
      ),

      await this.addLink(
        "https://unpkg.com/tippy.js@6.3.7/animations/scale-extreme.css"
      ),
      await this.addLink(
        "https://unpkg.com/tippy.js@6.3.7/animations/scale-subtle.css"
      ),
      await this.addLink(
        "https://unpkg.com/tippy.js@6.3.7/animations/scale.css"
      ),

      await this.addLink(
        "https://unpkg.com/tippy.js@6.3.7/animations/shift-away-extreme.css"
      ),
      await this.addLink(
        "https://unpkg.com/tippy.js@6.3.7/animations/shift-away-subtle.css"
      ),
      await this.addLink(
        "https://unpkg.com/tippy.js@6.3.7/animations/shift-away.css"
      ),

      await this.addLink(
        "https://unpkg.com/tippy.js@6.3.7/animations/shift-toward-extreme.css"
      ),
      await this.addLink(
        "https://unpkg.com/tippy.js@6.3.7/animations/shift-toward-subtle.css"
      ),
      await this.addLink(
        "https://unpkg.com/tippy.js@6.3.7/animations/shift-toward.css"
      ),

      await this.addLink(
        "https://unpkg.com/tippy.js@6.3.7/themes/light-border.css"
      ),

      await this.addLink("https://unpkg.com/tippy.js@6.3.7/themes/light.css"),
      await this.addLink(
        "https://unpkg.com/tippy.js@6.3.7/themes/material.css"
      ),
      await this.addLink(
        "https://unpkg.com/tippy.js@6.3.7/themes/translucent.css"
      ),
    ]);
  },

  addScript(src) {
    return new Promise((resolve, reject) => {
      const s = document.createElement("script");

      s.setAttribute("src", src);
      s.addEventListener("load", resolve);
      s.addEventListener("error", reject);

      document.body.appendChild(s);
    });
  },

  addLink(src) {
    return new Promise((resolve, reject) => {
      const s = document.createElement("link");

      s.setAttribute("rel", "stylesheet");
      s.setAttribute("href", src);
      s.addEventListener("load", resolve);
      s.addEventListener("error", reject);

      document.body.appendChild(s);
    });
  },
};
