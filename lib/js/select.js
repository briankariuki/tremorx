import { enter, leave } from "./util";

export default Select = {
  mounted() {
    this.isOpen = false;
    this.activeIndex = undefined;
    this.selected = undefined;

    this.button = this.el.querySelector(".tremor-select-button");
    this.clear = this.el.querySelector(".tremor-select-clear");
    this.menu = this.el.querySelector(".tremor-select-items");
    this.items = this.el.querySelectorAll(".tremor-select-item");
    this.selectContent = this.el.querySelector(".tremor-select-content");
    this.hidden = this.el.querySelector("[data-select-hidden]");

    this.button.addEventListener("click", this.toggle.bind(this));
    this.clear.addEventListener("click", this.onClear.bind(this));
    document.addEventListener("click", this.onClickOutside.bind(this));
    document.addEventListener("keydown", this.onKeyEvent.bind(this));

    this.items.forEach((item) =>
      item.addEventListener("click", this.onClickSelectItem.bind(this, item))
    );

    if (this.el.dataset.defaultValue) {
      this.selected = this.el.dataset.defaultValue;
      this.selectContent.innerText = this.el.dataset.defaultValue;
      this.hidden.value = this.selected;
    }
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

    if (this.selected) {
      this.selectContent.innerText = this.selected;
      this.clear.classList.remove("hidden");
      this.clear.classList.add("inline-flex");

      this.hidden.value = this.selected;
      console.log(this.hidden.value);
      console.log(this.selected);
      this.hidden.dispatchEvent(new Event("change", { bubbles: true }));
    } else {
      this.clear.classList.remove("inline-flex");
      this.clear.classList.add("hidden");
      this.selectContent.innerText = this.el.dataset.placeholder;
    }

    this.items.forEach((item, index) =>
      index == this.activeIndex ||
      (item.innerText || item.textContent) == this.el.dataset.defaultValue
        ? item.focus({ preventScroll: true })
        : {}
    );
  },

  onClickSelectItem(item, _event) {
    if (!this.isOpen) return;

    this.selected = item.innerText || item.textContent;

    this.toggle();
  },

  onClear() {
    this.clear.classList.remove("inline-flex");
    this.clear.classList.add("hidden");
    this.selected = undefined;
    this.selectContent.innerText = this.el.dataset.placeholder;
    this.hidden.value = undefined;

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
    if (this.isOpen) {
      e.preventDefault();
    }

    if (!this.isOpen) return;

    if (e.key === "Tab") {
      this.toggle();
    }

    if (e.key === "Enter") {
      const item = this.items[this.activeIndex];
      this.selected = item.innerText || item.textContent;
      item.focus({ preventScroll: true });

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
