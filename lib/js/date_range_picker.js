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
  "day-in-range-class",
  "on-change",
  "placeholder",
];
document.addEventListener("DOMContentLoaded", (_) => {
  class DateRangePicker extends BaseHtmlElement {
    static observedAttributes = attributes;
    constructor() {
      super();

      // Define properties for each attribute
      for (const attribute of attributes) {
        this.defineProperty(attribute);
      }
    }

    // Setup any event handlers and reference any html nodes to the element state

    setup() {
      this.nextBtn = document.getElementById(`${this.id}_next_button`);
      this.prevBtn = document.getElementById(`${this.id}_prev_button`);

      this.cancelBtn = document.getElementById(`${this.id}_cancel_button`);
      this.applyBtn = document.getElementById(`${this.id}_apply_button`);

      this.selectedRangeEl = document.getElementById(
        `${this.id}_selected_range`
      );

      this.selectedRangeTriggerEl = document.getElementById(
        `${this.id}_selected_range_trigger`
      );

      this.prevMonthEl = document.getElementById(`${this.id}_prev_month`);
      this.nextMonthEl = document.getElementById(`${this.id}_next_month`);

      this.nextBtn?.addEventListener("click", (e) => {
        e.stopPropagation();
        this.nextMonth(this.selectedDate);
      });

      this.prevBtn?.addEventListener("click", (e) => {
        e.stopPropagation();
        this.prevMonth(this.selectedDate);
      });

      this.cancelBtn?.addEventListener("click", (e) => {
        this.clearDateRange();
      });

      this.applyBtn?.addEventListener("click", (e) => {
        this.onDateChanged();
      });
    }

    connectedCallback() {
      let dt = new Date(this.date);
      this.prevMonthRows = getCalendarRows(dayjs(dt));
      this.nextMonthRows = getCalendarRows(changeDateMonth(dayjs(dt), true));
      this.prevMonthDate = dayjs(dt);
      this.nextMonthDate = changeDateMonth(dayjs(dt), true);
      this.selectedFirstDate = null;
      this.selectedSecondDate = null;
      this.selectedRange = [];
      this.isDateRangeSelected = false;
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
      let prevMonthElementsNode = document.getElementById(
        `${this.id}_prev_month_elements`
      );
      let prevMonthDaysHeadNode = document.getElementById(
        `${this.id}_prev_month_days`
      );

      let nextMonthElementsNode = document.getElementById(
        `${this.id}_next_month_elements`
      );
      let nextMonthDaysHeadNode = document.getElementById(
        `${this.id}_next_month_days`
      );

      let [selectedFirstDate, selectedSecondDate] = this.selectedRange;

      if (selectedFirstDate && selectedSecondDate) {
        this.selectedRangeEl.textContent = `${selectedFirstDate.format(
          "DD MMM YYYY"
        )} - ${selectedSecondDate.format("DD MMM YYYY")}`;

        this.selectedRangeTriggerEl.textContent = `${selectedFirstDate.format(
          "DD MMM YYYY"
        )} - ${selectedSecondDate.format("DD MMM YYYY")}`;
      }

      // render prev month
      this.renderDatesTable(
        prevMonthElementsNode,
        prevMonthDaysHeadNode,
        this.prevMonthEl,
        this.prevMonthRows,
        this.prevMonthDate,
        "prev",
        this.selectedRange,
        refresh
      );
      // render next month
      this.renderDatesTable(
        nextMonthElementsNode,
        nextMonthDaysHeadNode,
        this.nextMonthEl,
        this.nextMonthRows,
        this.nextMonthDate,
        "next",
        this.selectedRange,
        refresh
      );
    }

    renderDatesTable(
      elementsNode,
      daysHeadNode,
      monthEl,
      rows,
      monthDate,
      type,
      selectedRange,
      refresh = false
    ) {
      // Instantiate nodes to clone
      let dayRowNode = document.createElement("tr");
      let dayCellNode = document.createElement("th");
      let dateCellNode = document.createElement("td");
      let btn = document.createElement("button");

      let [selectedFirstDate, selectedSecondDate] = selectedRange;

      // If render is a force refresh
      if (refresh) {
        daysHeadNode?.replaceChildren();
        elementsNode?.replaceChildren();
        elementsNode?.classList.add("hidden");
        monthEl?.classList.add("hidden");
      }

      monthEl.textContent = monthDate.format("MMMM YYYY");

      for (const cell of rows[0]) {
        let dayCell = dayCellNode.cloneNode();
        dayCell.classList.add(...this["head-cell-class"].split(" "));
        dayCell.textContent = cell.value.format("dd");
        dayCell.ariaLabel = cell.value.format("dddd");
        dayRowNode?.appendChild(dayCell);
      }

      daysHeadNode?.appendChild(dayRowNode);

      for (const row of rows) {
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

          if (cell.value.isSame(monthDate, "month")) {
            dateBtn.classList.add(...this["day-class"].split(" "));
          }

          if (!cell.value.isSame(monthDate, "month")) {
            dateBtn.classList.add(...this["day-outside-class"].split(" "));
            dateBtn.classList.add("hidden");
          }

          dateBtn.textContent = cell.value.format("D");

          if (
            selectedFirstDate != null &&
            selectedSecondDate != null &&
            cell.value.isAfter(selectedFirstDate) &&
            cell.value.isBefore(selectedSecondDate)
          ) {
            dateBtn.classList.add(...this["day-in-range-class"].split(" "));

            dateBtn.setAttribute("aria-selected", "true");
          }

          if (
            (selectedFirstDate != null &&
              cell.value.isSame(selectedFirstDate)) ||
            (selectedSecondDate != null &&
              cell.value.isSame(selectedSecondDate))
          ) {
            dateBtn.classList.add(...this["day-selected-class"].split(" "));

            dateBtn.setAttribute("aria-selected", "true");
          }

          dateBtn.addEventListener("click", (e) => {
            if (
              dateBtn.getAttribute("aria-selected") &&
              (cell.value.isSame(selectedFirstDate) ||
                cell.value.isSame(selectedSecondDate))
            ) {
              e.stopPropagation();

              dateBtn.removeAttribute("aria-selected");
              dateBtn.classList.remove(
                ...this["day-selected-class"].split(" ")
              );

              this.clearDateRange();

              return;
            }

            e.stopPropagation();

            // document
            //   .querySelectorAll("button[aria-selected='true']")
            //   .forEach((el) => {
            //     el.removeAttribute("aria-selected");
            //     el.classList.remove(...this["day-selected-class"].split(" "));
            //   });

            dateBtn.setAttribute("aria-selected", "true");
            dateBtn.classList.add(...this["day-selected-class"].split(" "));

            this.selectDateRange(cell.value, type, true);
          });

          dateCell.appendChild(dateBtn);
          datesRow.appendChild(dateCell);
        }

        elementsNode?.appendChild(datesRow);
      }

      daysHeadNode?.classList.remove("hidden");
      elementsNode?.classList.remove("hidden");

      monthEl?.classList.remove("hidden");
    }

    /**
     *
     * @param {dayjs.Dayjs} date
     * @returns {void}
     */

    nextMonth(date) {
      this.prevMonthDate = changeDateMonth(this.prevMonthDate, true);
      this.nextMonthDate = changeDateMonth(this.nextMonthDate, true);

      this.prevMonthRows = getCalendarRows(this.prevMonthDate);
      this.nextMonthRows = getCalendarRows(this.nextMonthDate);

      this.render(true);
    }

    /**
     *
     * @param {dayjs.Dayjs} date
     * @returns {void}
     */

    prevMonth(date) {
      this.prevMonthDate = changeDateMonth(this.prevMonthDate);
      this.nextMonthDate = changeDateMonth(this.nextMonthDate);

      this.prevMonthRows = getCalendarRows(this.prevMonthDate);
      this.nextMonthRows = getCalendarRows(this.nextMonthDate);

      this.render(true);
    }

    /**
     *
     * @param {dayjs.Dayjs} date
     * @returns {void}
     */

    selectDateRange(date, type, draw = false) {
      if (
        this.selectedFirstDate != null &&
        date.isAfter(this.selectedFirstDate)
      ) {
        this.selectedSecondDate = date;
        this.selectedRange = [this.selectedFirstDate, this.selectedSecondDate];

        if (draw) {
          this.render(true);

          this.onDateChanged();
        }

        return;
      }

      if (type == "prev") {
        if (this.selectedFirstDate == null) {
          this.selectedFirstDate = date;
        } else if (
          this.selectedFirstDate != null &&
          this.selectedSecondDate == null &&
          date.isBefore(this.selectedFirstDate)
        ) {
          this.selectedSecondDate = this.selectedFirstDate;
          this.selectedFirstDate = date;
        } else if (
          this.selectedFirstDate != null &&
          this.selectedSecondDate != null &&
          date.isBefore(this.selectedFirstDate)
        ) {
          this.selectedFirstDate = date;
        } else {
          this.selectedSecondDate = date;
        }

        this.selectedRange = [this.selectedFirstDate, this.selectedSecondDate];

        if (draw) {
          this.render(true);

          this.onDateChanged();
        }
      }

      if (type == "next") {
        if (this.selectedFirstDate == null) {
          this.selectedFirstDate = date;
        } else if (
          this.selectedFirstDate != null &&
          this.selectedSecondDate == null &&
          date.isBefore(this.selectedFirstDate)
        ) {
          this.selectedSecondDate = this.selectedFirstDate;
          this.selectedFirstDate = date;
        } else if (
          this.selectedFirstDate != null &&
          this.selectedSecondDate != null &&
          date.isBefore(this.selectedFirstDate)
        ) {
          this.selectedFirstDate = date;
        } else {
          this.selectedSecondDate = date;
        }

        this.selectedRange = [this.selectedFirstDate, this.selectedSecondDate];

        if (draw) {
          this.render(true);

          this.onDateChanged();
        }
      }
    }

    onDateChanged() {
      if (
        this["on-change"] &&
        this.selectedFirstDate != null &&
        this.selectedSecondDate != null
      ) {
        this.pushEvent(`${this["on-change"]}`, {
          range: {
            start: this.selectedFirstDate?.toISOString(),
            end: this.selectedSecondDate?.toISOString(),
          },
        });
      }
    }

    clearDateRange() {
      this.selectedFirstDate = null;
      this.selectedSecondDate = null;
      this.selectedRange = [];

      this.selectedRangeEl.textContent = "";
      this.selectedRangeTriggerEl.textContent = this.placeholder;

      this.render(true);

      if (this["on-change"]) {
        this.pushEvent(`${this["on-change"]}`, {
          range: null,
        });
      }
    }
  }

  window.customElements.define("date-range-picker", DateRangePicker);
});
