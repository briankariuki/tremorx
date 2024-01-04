export default TabAutomatic = {
  mounted() {
    this.firstTab = null;
    this.lastTab = null;
    this.tabs = [];

    this.tabs = Array.from(this.el.querySelectorAll("[role=tab]"));
    this.tabpanels = [];

    for (let i = 0; i < this.tabs.length; i++) {
      const tab = this.tabs[i];
      const tabpanel = document.getElementById(
        tab.getAttribute("aria-controls")
      );

      tab.tabIndex = -1;
      tab.setAttribute("aria-selected", "false");
      this.tabpanels.push(tabpanel);

      tab.addEventListener("keydown", this.onKeydown.bind(this));
      tab.addEventListener("click", this.onClick.bind(this));

      if (!this.firstTab) {
        this.firstTab = tab;
      }
      this.lastTab = tab;
    }

    this.setSelectedTab(this.firstTab, false);
  },

  /**
   * Sets the selected tab.
   * @param {HTMLElement} currentTab - The current tab element.
   * @param {boolean?} setFocus - Whether focus should be set.
   */
  async setSelectedTab(currentTab, setFocus) {
    if (typeof setFocus !== "boolean") {
      setFocus = true;
    }

    for (let i = 0; i < this.tabs.length; i++) {
      const tab = this.tabs[i];

      const uiSelectedClasses = Array.from(tab.classList).filter((e) =>
        e.includes("ui-selected")
      );

      let selectedClasses = [];

      for (const uiClass of uiSelectedClasses) {
        let selectedClass = "";
        if (uiClass.includes(":ui-selected")) {
          selectedClass = uiClass.replace(":ui-selected", "");
        } else {
          selectedClass = uiClass.replace("ui-selected:", "");
        }
        selectedClasses.push(selectedClass);
      }

      if (currentTab === tab) {
        tab.setAttribute("aria-selected", "true");
        tab.removeAttribute("tabindex");

        tab.classList.add(...selectedClasses);
        tab.classList.remove(
          "dark:text-dark-tremor-content",
          "text-tremor-content-emphasis",
          "hover:text-tremor-content-emphasis",
          "hover:border-tremor-content",
          "text-tremor-content"
        );

        this.tabpanels[i].classList.remove("hidden");

        if (setFocus) {
          tab.focus();
        }
      } else {
        tab.setAttribute("aria-selected", "false");
        tab.tabIndex = -1;
        tab.classList.remove(...selectedClasses);

        if (tab.getAttribute("data-variant") == "line") {
          tab.classList.add(
            "dark:text-dark-tremor-content",
            "hover:text-tremor-content-emphasis",
            "hover:border-tremor-content",
            "text-tremor-content"
          );
        } else {
          tab.classList.add(
            "dark:text-dark-tremor-content",
            "hover:text-tremor-content-emphasis",
            "text-tremor-content"
          );
        }

        this.tabpanels[i].classList.add("hidden");
      }
    }
  },

  /**
   * Sets the selected tab to previous
   * @param {HTMLElement} currentTab - The current selected tab
   */
  setSelectedToPreviousTab(currentTab) {
    if (currentTab === this.firstTab) {
      this.setSelectedTab(currentTab);
    } else {
      let index = this.tabs.indexOf(currentTab);
      this.setSelectedTab(this.tabs[index - 1]);
    }
  },

  /**
   * Sets the selected tab to next
   * @param {HTMLElement} currentTab - The current selected tab
   */
  setSelectedToNextTab(currentTab) {
    if (currentTab === this.lastTab) {
      this.setSelectedTab(this.firstTab);
    } else {
      let index = this.tabs.indexOf(currentTab);
      this.setSelectedTab(this.tabs[index + 1]);
    }
  },

  /**
   * Handle keydown event
   * @param {Event} event - The event fired onkeydown
   */

  onKeydown(event) {
    const target = event.currentTarget;
    let flag = false;

    switch (event.key) {
      case "ArrowLeft":
        this.setSelectedToPreviousTab(target);
        flag = true;

        break;

      case "ArrowRight":
        this.setSelectedToNextTab(target);
        flag = true;
        break;

      case "Home":
        this.setSelectedTab(this.firstTab);
        flag = true;
        break;

      case "End":
        this.setSelectedTab(this.lastTab);
        flag = true;
        break;

      default:
        break;
    }

    if (flag) {
      event.stopPropagation();
      event.preventDefault();
    }
  },

  /**
   * Handle click event
   * @param {Event} event - The event fired onclick
   */

  onClick(event) {
    const target = event.currentTarget;
    this.setSelectedTab(target);
  },
};
