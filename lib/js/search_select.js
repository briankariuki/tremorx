import { enter, leave } from "./util";

export default SearchSelect = {
  mounted() {
    this.isOpen = false;
    this.activeIndex = undefined;
    this.selected = undefined;
    this.filterItems = [];

    this.input = this.el.querySelector(".tremor-SearchSelect-input");
    this.clear = this.el.querySelector(".tremor-SearchSelect-clear");
    this.menu = this.el.querySelector(".tremor-SearchSelect-items");
    this.items = this.el.querySelectorAll(".tremor-SearchSelect-item");
    this.hidden = this.el.querySelector("[data-search-select-hidden]");

    this.input.addEventListener("click", this.toggle.bind(this));
    this.input.addEventListener("input", this.onSearchItem.bind(this));

    this.clear.addEventListener("click", this.onClear.bind(this));
    document.addEventListener("click", this.onClickOutside.bind(this));
    document.addEventListener("keydown", this.onKeyEvent.bind(this));

    this.items.forEach((item) =>
      item.addEventListener("click", this.onClickSelectItem.bind(this, item))
    );

    if (this.el.dataset.defaultValue) {
      this.selected = this.el.dataset.defaultValue;
      this.input.value = this.el.dataset.defaultValue;
      this.hidden.value = this.selected;
    }
  },

  destroyed() {},

  toggle() {
    this.isOpen = !this.isOpen;
    this.input.setAttribute("aria-expanded", this.isOpen);
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
      this.input.value = this.selected;
      this.clear.classList.remove("hidden");
      this.clear.classList.add("inline-flex");
      this.filterItems = [];

      this.hidden.value = this.selected;
      this.hidden.dispatchEvent(new Event("input", { bubbles: true }));
    } else {
      this.clear.classList.remove("inline-flex");
      this.clear.classList.add("hidden");
      this.input.value = "";
    }

    this.items.forEach((item, index) =>
      index == this.activeIndex ||
      (item.innerText || item.textContent) == this.el.dataset.defaultValue
        ? item.focus({ preventScroll: true })
        : {}
    );
  },

  onSearchItem(_event) {
    const items = Array.from(this.items).filter(
      (item) =>
        item.innerText.toLowerCase().search(this.input.value.toLowerCase()) !=
        -1
    );

    if (items != 0) {
      this.menu.replaceChildren(...items);
      this.menu.classList.remove("hidden");
    } else {
      this.menu.classList.add("hidden");
    }

    this.filterItems = items;
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
    this.input.value = "";
    this.hidden.value = undefined;
    this.filterItems = [];
    this.menu.replaceChildren(...this.items);

    if (!this.isOpen) return;
    this.toggle();
  },

  onClickOutside(e) {
    if (!this.isOpen) return;

    let targetElement = e.target;

    do {
      if (targetElement == this.el) return;

      if (this.filterItems.length > 0) {
        this.menu.replaceChildren(...this.filterItems);
      } else {
        this.menu.replaceChildren(...this.items);
      }

      targetElement = targetElement.parentNode;
    } while (targetElement);

    this.menu.replaceChildren(...this.items);

    this.toggle();
  },

  onKeyEvent(e) {
    if (this.input == document.activeElement) {
      return;
    }
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
      this.input.focus({ preventScroll: true });
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
