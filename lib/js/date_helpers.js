import * as Types from "./types.js";

/**
 *
 * @param {dayjs.Dayjs} date
 * @returns {Types.CalendarCell[]}
 */
export function getCalendarCells(date) {
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
 * @returns {Array<Types.CalendarCell[]>}
 */

export function getCalendarRows(date) {
  const cells = getCalendarCells(date);
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

export function changeDateMonth(date, isNextMonth) {
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
