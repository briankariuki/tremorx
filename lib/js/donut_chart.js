import d3 from "./d3.min.js";

import { genColor } from "./util.js";

import { buildTooltip, throttle } from "./chart.js";

const DonutChart = {
  mounted() {
    this.id = this.el.getAttribute("id").split("-hook")[0];
    this.legend = this.el.querySelector(`#${this.id}-legend`);
    this.tau = 2 * Math.PI;

    // Initiate the state on first mount
    this.updateState();

    // Resize to window and then draw
    this.resizeToWindowSize();
    this.draw(true);

    // Redraw based on the new size whenever the browser window is resized.
    window.addEventListener("resize", (_) => {
      d3.selectAll(`svg.${this.id}`).remove();
      d3.selectAll(".chartannotation").remove();

      this.resizeToWindowSize();

      this.draw(false);
    });
  },

  updateState() {
    this.items = this.el.dataset.items;
    this.categories = this.el.dataset.categories;
    this.category = this.el.dataset.category;
    this.value = this.el.dataset.value;
    this.label = this.el.dataset.label;
    this.variant = this.el.dataset.variant;
    this.valueFormat = this.el.dataset.valueFormat;
    this.dataArray = JSON.parse(this.items);
    this.categories = JSON.parse(this.categories);
    this.tooltipFrameClass = this.el.dataset.tooltipFrameClass;
    this.labelClass = this.el.dataset.labelClass;
    this.showLabel = this.el.dataset.showLabel;
    this.showTooltip = this.el.dataset.showTooltip;
    this.showAnimation = this.el.dataset.showAnimation;
    this.padAngle = Number.parseFloat(this.el.dataset.padAngle);
    this.innerRadiusPercent = Number.parseFloat(
      this.el.dataset.innerRadiusPercent
    );

    this.padding = Number.parseInt(this.el.dataset.padding);

    this.total = 0;

    this.dataArray.forEach((d, i) => {
      d["color-id"] = genColor(i);
      this.total = this.total + d[this.value];

      return d;
    });
  },

  resizeToWindowSize() {
    let { width, height } = this.el.getBoundingClientRect();

    this.outerRadius = height / 2 - this.padding;

    if (this.variant == "donut") {
      this.innerRadius = this.outerRadius * this.innerRadiusPercent;
    } else {
      this.innerRadius = 1.0;
    }

    this.width = width;
    this.height = height;
  },

  draw(isUpdate = false) {
    if (isUpdate) {
      this.resizeToWindowSize();
    }
    // Create the SVG container.
    const svg = d3
      .create("svg")
      .attr("class", `${this.id}`)
      .attr("viewBox", [
        -this.width / 2,
        -this.height / 2,
        this.width,
        this.height,
      ]);

    // Tooltip
    let tooltip = d3
      .select("body")
      .append("div")
      .attr(
        "class",
        `tooltip-pie annot pointer-events-none absolute ${this.tooltipFrameClass}`
      )
      .style("opacity", 0)
      .style("display", "none");

    this.arc = d3
      .arc()
      .innerRadius(this.innerRadius)
      .outerRadius(this.outerRadius);

    this.pie = d3
      .pie()
      .sort(null)
      .padAngle(this.padAngle)
      .value((d) => d[this.value]);

    const categories = this.categories;
    const category = this.category;
    const value = this.value;
    const valueFormat = this.valueFormat;
    const showTooltip = this.showTooltip;

    if (this.showLabel == "true" && this.variant == "donut") {
      svg
        .append("text")
        .attr("class", `${this.labelClass}`)
        .attr("text-anchor", "middle")
        .attr("dominant-baseline", "middle")
        .text((_) =>
          valueFormat != null && valueFormat != ""
            ? d3.format(valueFormat)(this.total)
            : this.total
        );
    }

    function arcTween(a, arc) {
      const i = d3.interpolate(this._current, a);
      this._current = i(0);
      return (t) => arc(i(t));
    }

    this.path = svg
      .append("g")
      .datum(this.dataArray)
      .selectAll("path")
      .data(this.pie)
      .join("path")
      .attr("fill", "currentColor")
      .attr("class", function (d, i) {
        let displayCategories = categories.filter(
          (e) => e.category == d.data[category]
        );

        return `hover:cursor-pointer ${displayCategories[0].donut}`;
      })
      .attr("color-id", (d) => d.data["color-id"])
      .attr("d", this.arc)

      .each(function (d) {
        this.addEventListener("click", function (event) {
          if (d3.select(event.target).attr("path-active") == "true") {
            svg
              .selectAll("path[color-id]")
              .attr("opacity", "1.0")
              .attr("path-active", null);

            return;
          }

          let paths = svg.selectAll("path[color-id]").nodes();

          paths.forEach((element) => {
            if (d.data["color-id"] == d3.select(element).attr("color-id")) {
              d3.select(element)
                .attr("opacity", "1.0")
                .attr("path-active", "true");
            } else {
              d3.select(element)
                .attr("opacity", "0.3")
                .attr("path-active", null);
            }
          });
        });

        this.addEventListener("mouseover", function (event) {
          const clientBox = event.currentTarget.getBBox();
          const clientRect = event.currentTarget.getBoundingClientRect();

          if (showTooltip != "true") {
            return;
          }

          tooltip
            .transition()
            .duration("10")
            .style("opacity", 1)
            .style("display", "block");

          let displayCategories = categories.filter(
            (e) => e.category == d.data[category]
          );

          let tooltipContent = buildTooltip(
            d.data[category],
            d.data,
            displayCategories,
            false,
            value,
            valueFormat != null && valueFormat != ""
              ? (v) => d3.format(valueFormat)(v)
              : null
          );

          tooltip.html(tooltipContent.innerHTML);

          // Wait for tooltip to render
          window.requestAnimationFrame(() => {
            const { width, height } = tooltip.node().getBoundingClientRect();

            tooltip
              .style("left", clientRect.x + clientBox.width + "px")
              .style(
                "top",
                clientRect.y + clientBox.height / 2 - height / 2 + "px"
              );
          });
        });

        this.addEventListener("mouseout", function (event) {
          //Remove all the annotations - indicator, bars and tooltip
          svg.selectAll(".chartannotation").remove();

          tooltip
            .transition()
            .duration("10")
            .style("opacity", 0)
            .style("display", "none");

          svg.selectAll(".indicator").style("opacity", 0);
        });
        this.name = d.data[category];
        this._current = d;
      });

    if (this.showAnimation == "true") {
      this.path
        .transition()
        .duration(750)
        .attrTween("d", (d) => arcTween(d, this.arc));
    }

    // Append the svg chart to the element
    this.el.appendChild(svg.node());
  },

  updated() {
    this.updateState();

    window.requestAnimationFrame(() => {
      this.draw(true);
    });
  },
  destroyed() {
    window.removeEventListener("resize", (_) => {
      d3.selectAll(`svg.${this.id}`).remove();
      d3.selectAll(".chartannotation").remove();
    });
  },
};

export default DonutChart;
