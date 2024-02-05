import { enter, leave } from "./util";

export default MultiSelect = {
  mounted() {
    this.isOpen = false;
    this.activeIndex = undefined;
    this.selected = undefined;
    this.filterItems = [];
    this.selectedItems = [];

    this.button = this.el.querySelector(".tremor-MultiSelect-button");
    this.input = this.el.querySelector(".tremor-MultiSelect-input");

    this.clear = this.el.querySelector(".tremor-MultiSelect-clear");
    this.menu = this.el.querySelector(".tremor-MultiSelect-items");
    this.items = this.el.querySelectorAll(".tremor-MultiSelect-item");
    this.selectContent = this.el.querySelector(".tremor-MultiSelect-content");
    this.selectWrapper = this.el.querySelector(
      ".tremor-MultiSelect-selectWrapper"
    );
    this.selectMenu = this.el.querySelector(".tremor-MultiSelect-selectMenu");
    this.selectItem = this.el.querySelector(".tremor-MultiSelect-selectItem");

    this.search = this.el.querySelector(".tremor-MultiSelect-search");
    this.hidden = this.el.querySelector("[data-multi-select-hidden]");

    this.button.addEventListener("click", this.toggle.bind(this));
    this.clear.addEventListener("click", this.onClear.bind(this));
    this.input.addEventListener("input", this.onSearchItem.bind(this));

    document.addEventListener("click", this.onClickOutside.bind(this));
    document.addEventListener("keydown", this.onKeyEvent.bind(this));

    this.items.forEach((item) =>
      item.addEventListener("click", this.onClickSelectItem.bind(this, item))
    );

    if (
      this.el.dataset.defaultValue != undefined &&
      this.el.dataset.defaultValue != ""
    ) {
      this.selected = this.el.dataset.defaultValue;
      this.hidden.value = this.selected;

      const defaultValues = this.el.dataset.defaultValue.split(
        this.el.dataset.selectJoinBy
      );

      if (defaultValues.length > 0) {
        this.clear.classList.remove("hidden");
        this.clear.classList.add("inline-flex");
        this.selectContent.classList.add("hidden");
        this.selectWrapper.classList.remove("hidden");
      }

      defaultValues.forEach((value, index) => {
        const item = Array.from(this.items).find(
          (item) =>
            item.innerText.toLowerCase().search(value.toLowerCase()) != -1
        );

        if (item != null) this.onDefaultSelectItem(item, index);
      });
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
      for (const item of this.items) {
        try {
          this.menu.removeChild(item);
        } catch (error) {}
      }
      for (const item of items) {
        this.menu.appendChild(item);
      }

      this.menu.classList.remove("hidden");
    } else {
      this.menu.classList.add("hidden");
    }

    this.filterItems = items;
  },

  onClickSelectItem(item, _event) {
    if (!this.isOpen) return;

    const selectedIndex = this.selectedItems.indexOf(item);

    if (selectedIndex != -1) {
      this.selected = "";
      this.selectedItems.splice(selectedIndex, 1);

      const checkbox = item.querySelector(".tremor-MultiSelectItem-checkbox");
      checkbox.checked = false;

      this.selectWrapper.classList.remove("hidden");

      const removeItemNode = Array.from(this.selectMenu.childNodes).find(
        (node) => node.innerText == item.innerText
      );

      this.selectMenu.removeChild(removeItemNode);
    } else {
      this.selected = item.innerText || item.textContent;
      this.selectedItems = [...this.selectedItems, item];

      this.selectContent.innerText = this.selected;

      const checkbox = item.querySelector(".tremor-MultiSelectItem-checkbox");
      checkbox.checked = true;

      this.selectWrapper.classList.remove("hidden");
      const selectItemNode = this.selectItem.cloneNode(true);

      selectItemNode.querySelector(
        ".tremor-MultiSelect-contentItem"
      ).innerText = this.selected;
      selectItemNode.classList.remove("hidden");
      selectItemNode.classList.add("flex");

      //Add clear button event
      selectItemNode
        .querySelector(".tremor-MultiSelect-clearItem")
        .addEventListener(
          "click",
          this.onClearSelectedItem.bind(
            this,
            selectItemNode,
            item,
            selectedIndex
          )
        );

      this.selectMenu.append(selectItemNode);
    }

    this.onSelect();
  },

  onDefaultSelectItem(item, index) {
    this.selected = item.innerText || item.textContent;
    this.selectedItems = [...this.selectedItems, item];

    this.selectContent.innerText = this.selected.trim();

    const checkbox = item.querySelector(".tremor-MultiSelectItem-checkbox");
    checkbox.checked = true;

    this.selectWrapper.classList.remove("hidden");
    const selectItemNode = this.selectItem.cloneNode(true);

    selectItemNode.querySelector(".tremor-MultiSelect-contentItem").innerText =
      this.selected.trim();
    selectItemNode.classList.remove("hidden");
    selectItemNode.classList.add("flex");

    //Add clear button event
    selectItemNode
      .querySelector(".tremor-MultiSelect-clearItem")
      .addEventListener(
        "click",
        this.onClearSelectedItem.bind(this, selectItemNode, item, index)
      );

    this.selectMenu.append(selectItemNode);
  },

  onClearSelectedItem(selectedItem, menuItem, selectedIndex, _event) {
    const checkbox = menuItem.querySelector(".tremor-MultiSelectItem-checkbox");
    checkbox.checked = false;

    this.selectedItems.splice(selectedIndex, 1);
    this.selectMenu.removeChild(selectedItem);

    this.onSelect();
  },

  onSelect() {
    if (this.selectedItems.length > 0) {
      this.clear.classList.remove("hidden");
      this.clear.classList.add("inline-flex");
      this.selectContent.classList.add("hidden");
    } else {
      this.clear.classList.remove("inline-flex");
      this.clear.classList.add("hidden");
      this.selectWrapper.classList.add("hidden");
      this.selectContent.classList.remove("hidden");
      this.selectContent.innerText = this.el.dataset.placeholder;

      this.selectMenu.replaceChildren();
    }

    this.hidden.value = this.selectedItems
      .map((item) => item.innerText)
      .join(this.el.dataset.selectJoinBy);
    this.hidden.dispatchEvent(new Event("input", { bubbles: true }));
  },

  onClear() {
    this.clear.classList.remove("inline-flex");
    this.clear.classList.add("hidden");
    this.selected = undefined;
    this.selectContent.innerText = this.el.dataset.placeholder;
    this.input.value = "";
    this.filterItems = [];
    this.selectedItems = [];
    this.menu.replaceChildren(this.search, ...this.items);
    this.hidden.value = undefined;
    this.selectWrapper.classList.add("hidden");
    this.selectContent.classList.remove("hidden");

    this.selectMenu.replaceChildren();

    for (const item of this.items) {
      const checkbox = item.querySelector(".tremor-MultiSelectItem-checkbox");
      checkbox.checked = false;
    }

    if (!this.isOpen) return;
    this.toggle();
  },

  onClickOutside(e) {
    if (!this.isOpen) return;
    let targetElement = e.target;

    do {
      if (targetElement == this.el) return;

      if (this.filterItems.length > 0) {
        for (const item of this.filterItems) {
          this.menu.appendChild(item);
        }
      } else {
        for (const item of this.items) {
          this.menu.appendChild(item);
        }
      }

      targetElement = targetElement.parentNode;
    } while (targetElement);

    for (const item of this.items) {
      this.menu.appendChild(item);
    }

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
