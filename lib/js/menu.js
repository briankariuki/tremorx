import { enter, leave } from "./util";

export default Menu = {
  mounted() {
    this.isOpen = false;
    this.activeIndex = undefined;

    this.button = this.el.querySelector(".tremor-menu-button");
    this.menu = this.el.querySelector(".tremor-menu-items");
    this.items = this.el.querySelectorAll(".tremor-menu-item");

    this.button.addEventListener("click", this.toggle.bind(this));
    document.addEventListener("click", this.onClickOutside.bind(this));
    document.addEventListener("keydown", this.onKeyEvent.bind(this));

    this.items.forEach((item) =>
      item.addEventListener("click", this.onClickMenuItem.bind(this))
    );
  },

  destroyed() {},

  toggle() {
    this.isOpen = !this.isOpen;
    this.button.setAttribute("aria-expanded", this.isOpen);
    this.menu.setAttribute("aria-hidden", !this.isOpen);
    this.el.dataset.open = this.isOpen;

    if (this.isOpen == true) {
      enter(this.menu, {
        enter: this.el.dataset.enter.split(" "),
        enterFrom: this.el.dataset.enterFrom.split(" "),
        enterTo: this.el.dataset.enterTo.split(" "),
      });
    } else {
      leave(this.menu, {
        leave: this.el.dataset.leave.split(" "),
        leaveFrom: this.el.dataset.leaveFrom.split(" "),
        leaveTo: this.el.dataset.leaveTo.split(" "),
      });
    }
  },

  onClickMenuItem() {
    if (!this.isOpen) return;

    this.toggle();
  },

  onClickOutside(e) {
    if (!this.isOpen) return;
    let targetElement = e.target;

    do {
      if (targetElement == this.el) return;
      targetElement = targetElement.parentNode;
    } while (targetElement);

    this.toggle();
  },

  onKeyEvent(e) {
    e.preventDefault();

    if (!this.isOpen) return;

    if (e.key === "Tab") {
      this.toggle();
    }

    if (e.key === "Escape") {
      this.toggle();
      this.button.focus({ preventScroll: true });
    }

    if (e.key === "ArrowDown") {
      this.activeIndex =
        this.activeIndex < this.items.length - 1 ? this.activeIndex + 1 : 0;
      this.items[this.activeIndex].focus({ preventScroll: true });
    }

    if (e.key === "ArrowUp") {
      this.activeIndex =
        this.activeIndex > 0 ? this.activeIndex - 1 : this.items.length - 1;
      this.items[this.activeIndex].focus({ preventScroll: true });
    }
  },
};
