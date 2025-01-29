import dayjs from "./dayjs.min.js";
import BaseHtmlElement from "./base_element.js";
import { getCalendarRows, changeDateMonth } from "./date_helpers.js";

let attributes = [
  "id",
  "date",
  "day-class",
  "row-class",
  "cell-class",
  "head-cell-class",
  "day-selected-class",
  "day-outside-class",
  "day-indicator-class",
  "on-change",
];
class DatePicker extends BaseHtmlElement {
  static observedAttributes = attributes;
  constructor() {
    super();

    // Define properties for each attribute
    for (const attribute of attributes) {
      this.defineProperty(attribute);
    }
  }

  setup() {
    // Setup any event handlers and reference any html nodes to the element state

    this.layout = false;

    this.nextBtn = document.getElementById(`${this.id}_next_button`);
    this.prevBtn = document.getElementById(`${this.id}_prev_button`);

    this.selectedDateEl = document.getElementById(`${this.id}_selected_date`);
    this.currentMonthEl = document.getElementById(`${this.id}_current_month`);

    this.nextBtn?.addEventListener("click", (e) => {
      e.stopPropagation();
      this.nextMonth(this.selectedDate);
    });

    this.prevBtn?.addEventListener("click", (e) => {
      e.stopPropagation();
      this.prevMonth(this.selectedDate);
    });
  }

  connectedCallback() {
    let dt = new Date(this.date);
    this.rows = getCalendarRows(dayjs(dt));
    this.selectedDate = dayjs(dt);
    this.isDateSelected = false;
    this.setup();

    requestAnimationFrame(() => {
      this.render(true);
    });
  }

  attributeChangedCallback(_name, oldValue, newValue) {
    if (oldValue !== newValue && this.layout) {
      this.setup();
      requestAnimationFrame(() => {
        this.render(true);
      });
    }
  }

  render(refresh = false) {
    let elementsNode = document.getElementById(`${this.id}_elements`);
    let daysHeadNode = document.getElementById(`${this.id}_days`);
    let dayRowNode = document.createElement("tr");

    if (this.currentMonthEl)
      this.currentMonthEl.textContent = this.selectedDate.format("MMMM YYYY");

    // If render is a force refresh
    if (refresh) {
      daysHeadNode?.replaceChildren();
      elementsNode?.replaceChildren();
      elementsNode?.classList.add("hidden");
      this.currentMonthEl?.classList.add("hidden");
    }

    // Instantiate nodes to clone
    let dayCellNode = document.createElement("th");
    let dateCellNode = document.createElement("td");
    let btn = document.createElement("button");
    let indicator = document.createElement("span");

    for (const cell of this.rows[0]) {
      let dayCell = dayCellNode.cloneNode();
      dayCell.classList.add(...this["head-cell-class"].split(" "));
      dayCell.textContent = cell.value.format("dd");
      dayCell.ariaLabel = cell.value.format("dddd");
      dayRowNode?.appendChild(dayCell);
    }

    daysHeadNode?.appendChild(dayRowNode);

    for (const row of this.rows) {
      let datesRow = dayRowNode.cloneNode();
      datesRow.classList.add(...this["row-class"].split(" "));

      for (const cell of row) {
        let dateCell = dateCellNode.cloneNode();
        let dateBtn = btn.cloneNode();

        dateCell.classList.add(...this["cell-class"].split(" "));
        dateCell.role = "presentation";

        dateBtn.role = "gridcell";
        dateBtn.tabIndex = -1;
        dateBtn.type = "button";

        if (cell.value.isSame(this.selectedDate, "month")) {
          dateBtn.classList.add(...this["day-class"].split(" "));
        }

        if (cell.value.month() !== this.selectedDate.month()) {
          dateBtn.classList.add(...this["day-outside-class"].split(" "));
        }

        dateBtn.textContent = cell.value.format("D");

        if (
          cell.value.isSame(this.selectedDate, "date") &&
          cell.value.isSame(this.selectedDate, "month")
        ) {
          dateBtn.classList.add(...this["day-selected-class"].split(" "));

          if (this.isDateSelected)
            dateBtn.setAttribute("aria-selected", "true");

          let dateIndicator = indicator.cloneNode();

          dateIndicator.classList.add(
            ...this["day-indicator-class"].split(" ")
          );

          dateBtn.appendChild(dateIndicator);
        }

        dateBtn.addEventListener("click", (e) => {
          if (dateBtn.getAttribute("aria-selected")) {
            e.stopPropagation();

            dateBtn.removeAttribute("aria-selected");
            dateBtn.classList.remove(...this["day-selected-class"].split(" "));

            if (cell.value.isSame(this.selectedDate, "month")) {
              dayBtn.classList.add(...this["day-class"].split(" "));
            }

            if (cell.value.month() !== this.selectedDate.month()) {
              this.selectDate(cell.value, true);
              dayBtn.classList.add(...this["day-outside-class"].split(" "));
            }

            this.isDateSelected = false;

            return;
          }

          e.stopPropagation();

          document
            .querySelectorAll("button[aria-selected='true']")
            .forEach((el) => {
              el.removeAttribute("aria-selected");
              el.classList.remove(...this["day-selected-class"].split(" "));
            });

          dateBtn.setAttribute("aria-selected", "true");
          dateBtn.classList.add(...this["day-selected-class"].split(" "));

          this.isDateSelected = true;

          this.selectDate(cell.value, true);
        });

        dateCell.appendChild(dateBtn);
        datesRow.appendChild(dateCell);
      }

      elementsNode?.appendChild(datesRow);
    }

    daysHeadNode?.classList.remove("hidden");
    elementsNode?.classList.remove("hidden");
    this.currentMonthEl?.classList.remove("hidden");

    this.layout = true;
  }

  /**
   *
   * @param {dayjs.Dayjs} date
   * @returns {void}
   */

  nextMonth(date) {
    this.selectedDate = changeDateMonth(date, true);
    this.rows = getCalendarRows(this.selectedDate);
    this.render(true);
  }

  /**
   *
   * @param {dayjs.Dayjs} date
   * @returns {void}
   */

  prevMonth(date) {
    this.selectedDate = changeDateMonth(date, false);
    this.rows = getCalendarRows(this.selectedDate);
    this.render(true);
  }

  /**
   *
   * @param {dayjs.Dayjs} date
   * @returns {void}
   */

  selectDate(date, draw = false) {
    if (draw) {
      this.selectedDate = date;
      this.rows = getCalendarRows(date);
      this.render(true);
    }

    this.onDateChanged();

    this.selectedDateEl.textContent = date.format("D MMM, YYYY");
    this.currentMonthEl.textContent = date.format("MMMM YYYY");
  }

  onDateChanged() {
    if (this["on-change"]) {
      this.pushEvent(`${this["on-change"]}`, {
        date: this.selectedDate.toISOString(),
      });
    }
  }
}

window.customElements.define("date-picker", DatePicker);
