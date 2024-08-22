import d3 from "./d3.min.js";

/**
 * Build the base tooltip
 *
 * @param {String} label
 * @param {Object} data
 * @param {Record<string, unknown>[]} categories
 *
 * @returns {HTMLElement}
 **/

export function buildTooltip(label, data, categories) {
  let tooltip = document.createElement("div");
  let tooltipTitle = document.createElement("div");
  let tooltipTitleText = document.createElement("p");
  let tooltipRows = document.createElement("div");

  tooltipTitle.classList.add(
    "border-tremor-border",
    "border-b",
    "px-4",
    "py-2",
    "dark:border-dark-tremor-border"
  );

  tooltipTitleText.classList.add(
    "font-medium",
    "text-tremor-content-emphasis",
    "dark:text-dark-tremor-content-emphasis"
  );

  tooltipRows.classList.add("px-4", "py-2", "space-y-1");

  tooltipTitleText.appendChild(document.createTextNode(label));

  categories.forEach((category) => {
    let tooltipRow = buildTooltipRow(
      data[category.category],
      category.category,
      category.background
    );

    tooltipRows.append(tooltipRow);
  });

  tooltipTitle.appendChild(tooltipTitleText);
  tooltip.appendChild(tooltipTitle);
  tooltip.appendChild(tooltipRows);

  return tooltip;
}

/**
 * Build a tooltip row
 *
 * @param {String} value
 * @param {String} name
 * @param {String} color
 *
 * @returns {HTMLElement}
 **/

export function buildTooltipRow(value, name, color) {
  let row = document.createElement("div");
  let rowLabel = document.createElement("div");
  let rowLabelIndicator = document.createElement("span");
  let rowLabelText = document.createElement("p");
  let rowValueText = document.createElement("p");

  //Set css classes
  row.classList.add("flex", "items-center", "justify-between", "space-x-8");
  rowLabel.classList.add("flex", "items-center", "space-x-2");
  rowLabelIndicator.classList.add(
    "shrink-0",
    "rounded-tremor-full",
    "border-2",
    "h-3",
    "w-3",
    "border-tremor-background",
    "shadow-tremor-card",
    "dark:border-dark-tremor-background",
    "dark:shadow-dark-tremor-card",
    color
  );
  rowLabelText.classList.add(
    "text-right",
    "whitespace-nowrap",
    "text-tremor-content",
    "dark:text-dark-tremor-content"
  );
  rowValueText.classList.add(
    "font-medium",
    "tabular-nums",
    "text-right",
    "whitespace-nowrap",
    "text-tremor-content-emphasis",
    "dark:text-dark-tremor-content-emphasis"
  );

  //Append tooltip row elements
  const valueTextnode = document.createTextNode(value);
  rowValueText.appendChild(valueTextnode);

  const labelTextnode = document.createTextNode(name);
  rowLabelText.appendChild(labelTextnode);

  rowLabel.appendChild(rowLabelIndicator);
  rowLabel.appendChild(rowLabelText);
  row.appendChild(rowLabel);

  row.appendChild(rowValueText);

  return row;
}

/**
 * Finds the closest dot index to the mouse position
 *
 * @param {any[]} dots
 * @param {Number} positionX
 *
 * @returns {Number}
 **/

export function getClosestDotIndex(dots, positionX) {
  let idx = -1;
  let c = 1000;

  dots.forEach(function (d, i) {
    let x = d3.select(d).attr("cx");
    let dis = Math.abs(x - positionX);

    if (dis < c) {
      c = dis;
      idx = i; // find closest
    }
  });

  return idx;
}

/**
 * Throttles the function
 *
 * @param {Function} fn
 * @param {Number} threshhold
 * @param {unknown} scope
 *
 * @returns {void}
 **/

export function throttle(fn, threshhold, scope) {
  threshhold || (threshhold = 250);
  let last, deferTimer;
  return function () {
    let context = scope || this;

    let now = +new Date(),
      args = arguments,
      event = d3.event;
    if (last && now < last + threshhold) {
      // hold on to it
      clearTimeout(deferTimer);
      deferTimer = setTimeout(function () {
        last = now;
        d3.event = event;
        fn.apply(context, args);
      }, threshhold);
    } else {
      last = now;
      d3.event = event;
      fn.apply(context, args);
    }
  };
}

/**
 * Handle the legend click event
 *
 * @param {CustomEvent} e
 * @param {d3.Selection} svg
 * @param {Record<string, unknown>[]} categories
 *
 * @returns {void}
 **/

export function onLegendClick(e, svg, categories) {
  const isLegendActive = e.detail.dispatcher.dataset.legend == "active";

  const parentEl = e.detail.dispatcher.parentNode;
  const legends = parentEl.querySelectorAll("li");

  legends.forEach(function (d, i) {
    let name = d.dataset.legendName;

    if (isLegendActive) {
      d.removeAttribute("data-legend");

      return;
    }

    if (e.detail.category == name) {
      d.setAttribute("data-legend", "active");
    } else {
      d.setAttribute("data-legend", "inactive");
    }
  });

  categories.forEach((element) => {
    const paths = svg
      .selectAll(`path[area-category="${element.category}"]`)
      .nodes();

    const lines = svg
      .selectAll(`path[line-category="${element.category}"]`)
      .nodes();

    paths.forEach(function (d, i) {
      let path = d3.select(d);

      if (!path) return;

      if (isLegendActive) {
        path.transition().duration("10").attr("opacity", "0.6");

        return;
      }

      if (element.category != e.detail.category) {
        path.transition().duration("10").attr("opacity", "0.5");
      } else {
        path.transition().duration("10").attr("opacity", "0.6");
      }
    });
    lines.forEach(function (d, i) {
      let line = d3.select(d);

      if (!line) return;

      if (isLegendActive) {
        line.transition().duration("10").attr("stroke-opacity", "1");

        return;
      }

      if (element.category != e.detail.category) {
        line.transition().duration("10").attr("stroke-opacity", "0.3");
      } else {
        line.transition().duration("10").attr("stroke-opacity", "1");
      }
    });
  });
}

/**
 * Parse the x-axis value
 *
 * @param {String} type
 * @param {String} format
 * @param {unknown} value
 *
 * @returns {unknown}
 */

export function parseXAxisValue(type, format, value) {
  if (type == "date") {
    return d3.utcParse(format)(value);
  }

  if (type == "time") {
    return d3.timeParse(format)(value);
  }

  return value;
}

/**
 * Format the x-axis value
 *
 * @param {String} type
 * @param {String} format
 * @param {unknown} value
 *
 * @returns {unknown}
 */

export function formatXAxisValue(type, format, value) {
  if (type == "date") {
    return d3.utcFormat(format)(value);
  }

  if (type == "time") {
    return d3.timeFormat(format)(value);
  }

  return d3.format(format)(value);
}

/**
 * Generate the x-axis ticks
 *
 * @param {unknown} extent
 * @param {String} type
 * @param {Number | null} count
 *
 * @returns {unknown}
 */

export function xAxisTicks(extent, type, count) {
  if (type == "date") {
    return d3.utcMonth.filter((d, i) => {
      if (i == 0) return false;
      return d3.utcMonth.count(extent[0], d) % 2 === 0;
    });
  }

  if (type == "time") {
    return d3.utcTime.filter((d, i) => {
      if (i == 0) return false;
      return d3.utcTime.count(extent[0], d) % 2 === 0;
    });
  }

  return count;
}
