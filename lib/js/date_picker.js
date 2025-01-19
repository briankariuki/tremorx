import dayjs from "./dayjs.min.js";
import BaseHtmlElement from "./base_element.js";

/**
 * @typedef {object} CalendarCell
 * @property {string} text - the text value of the cell
 * @property {dayjs.Dayjs} value - the date value of the cell
 */

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
  "on-changed",
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

    this.nextBtn.addEventListener("click", (e) => {
      e.stopPropagation();
      this.nextMonth(this.selectedDate);
    });

    this.prevBtn.addEventListener("click", (e) => {
      e.stopPropagation();
      this.prevMonth(this.selectedDate);
    });

    this.selectedDateEl = document.getElementById(`${this.id}_selected_date`);
    this.currentMonthEl = document.getElementById(`${this.id}_current_month`);
  }

  connectedCallback() {
    let dt = new Date(this.date);
    this.rows = this.getCalendarRows(dayjs(dt));
    this.selectedDate = dayjs(dt);
    this.isDateSelected = false;

    requestAnimationFrame(() => {
      this.setup();
      this.draw(true);
    });
  }

  attributeChangedCallback(name, oldValue, newValue) {
    if (oldValue !== newValue && this.layout) {
      requestAnimationFrame(() => {
        this.setup();
        this.draw(true);
      });
    }
  }

  draw(isUpdate = false) {
    let elementsNode = document.getElementById(`${this.id}_elements`);
    let daysHeadNode = document.getElementById(`${this.id}_days`);
    let dayRowNode = document.createElement("tr");
    this.currentMonthEl.textContent = this.selectedDate.format("MMMM YYYY");

    // If draw is an update

    if (isUpdate) {
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

      elementsNode.appendChild(datesRow);
    }

    daysHeadNode?.classList.remove("hidden");
    elementsNode?.classList.remove("hidden");
    this.currentMonthEl?.classList.remove("hidden");

    this.layout = true;
  }

  /**
   *
   * @param {dayjs.Dayjs} date
   * @returns {CalendarCell[]}
   */
  getCalendarCells(date) {
    const daysInMonth = date.daysInMonth();
    const calendarCells = [];

    const prepareCell = (date, dayNumber) => {
      return {
        text: String(dayNumber),
        value: date.clone().set("date", dayNumber),
      };
    };

    for (let i = 0; i < daysInMonth; i++) {
      calendarCells.push(prepareCell(date, i + 1));
    }

    // how much more we need to add?
    const cellsToAdd = 35 - daysInMonth;

    const nextMonth = date.add(1, "month");
    const lastMonth = date.subtract(1, "month");

    //Check if calendarcell 1 is sunday
    if (calendarCells[0].value.day() == 0) {
      //Add to end of cells
      for (let i = 0; i < Math.round(cellsToAdd); i++) {
        calendarCells.push(prepareCell(nextMonth, i + 1));
      }
    } else {
      //Add to start of cells
      for (let i = 0; i < lastMonth.daysInMonth(); i++) {
        const currentLastMonthDate = lastMonth
          .clone()
          .set("date", lastMonth.daysInMonth() - i);

        calendarCells.unshift(
          prepareCell(lastMonth, lastMonth.daysInMonth() - i)
        );

        if (currentLastMonthDate.day() == 0) {
          break;
        }
      }

      const cellsToAdd =
        calendarCells.length % 7 == 0 ? 0 : 7 - (calendarCells.length % 7);

      //Add to end of cells
      for (let i = 0; i < cellsToAdd; i++) {
        calendarCells.push(prepareCell(nextMonth, i + 1));
      }
    }

    return calendarCells;
  }

  /**
   *
   * @param {dayjs.Dayjs} date
   * @returns {Array<CalendarCell[]>}
   */

  getCalendarRows(date) {
    const cells = this.getCalendarCells(date);
    const rows = [];
    // split one array into chunks
    for (let i = 0; i < cells.length; i += 7) {
      rows.push(cells.slice(i, i + 7));
    }

    return rows;
  }

  /**
   *
   * @param {dayjs.Dayjs} date
   * @param {boolean} isNextMonth
   * @returns {dayjs.Dayjs}
   */

  changeDateMonth(date, isNextMonth) {
    // should decrease year
    if (date.month() === 0 && !isNextMonth) {
      return date.set("year", date.year() - 1).set("month", 11);
    }
    // should increase year
    if (date.month() === 11 && isNextMonth) {
      return date.set("year", date.year() + 1).set("month", 0);
    }
    // add or substract
    return date.add(isNextMonth ? 1 : -1, "month");
  }

  /**
   *
   * @param {dayjs.Dayjs} date
   * @returns {void}
   */

  nextMonth(date) {
    this.selectedDate = this.changeDateMonth(date, true);
    this.rows = this.getCalendarRows(this.selectedDate);
    this.draw(true);
  }

  /**
   *
   * @param {dayjs.Dayjs} date
   * @returns {void}
   */

  prevMonth(date) {
    this.selectedDate = this.changeDateMonth(date, false);
    this.rows = this.getCalendarRows(this.selectedDate);
    this.draw(true);
  }

  /**
   *
   * @param {dayjs.Dayjs} date
   * @returns {void}
   */

  selectDate(date, draw = false) {
    if (draw) {
      this.selectedDate = date;
      this.rows = this.getCalendarRows(date);
      this.draw(true);
    }

    this.onDateChanged();

    this.selectedDateEl.textContent = date.format("D MMM, YYYY");
    this.currentMonthEl.textContent = date.format("MMMM YYYY");
  }

  onDateChanged() {
    if (this["on-changed"]) {
      this.pushEvent(`${this["on-changed"]}`, {
        date: this.selectedDate.toISOString(),
      });
    }
  }
}

window.customElements.define("date-picker", DatePicker);
