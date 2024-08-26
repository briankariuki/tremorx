import d3 from "./d3.min.js";

import {
  buildTooltip,
  parseXAxisValue,
  getClosesElementIndex,
  onLegendClick,
  throttle,
} from "./chart.js";
import { genColor, doesPointCollide } from "./util.js";

const BarChart = {
  mounted() {
    this.id = this.el.getAttribute("id").split("-hook")[0];

    this.el.classList.add(`w-[${this.width}px]`, `h-[${this.height}px]`);
    this.legend = this.el.querySelector(`#${this.id}-legend`);

    this.yAxisComp = 1.5;

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
    this.dataArray = JSON.parse(this.items);

    this.dataArray.forEach((d, i) => {
      d["color-id"] = genColor(i);

      return d;
    });

    this.categories = JSON.parse(this.categories);
    this.labelClass = this.el.dataset.labelClass;
    this.axisLabelClass = this.el.dataset.axisLabelClass;
    this.barClass = this.el.dataset.barClass;
    this.tooltipFrameClass = this.el.dataset.tooltipFrameClass;
    this.width = Number.parseInt(this.el.dataset.width);
    this.height = Number.parseInt(this.el.dataset.height);
    this.marginTop = Number.parseInt(this.el.dataset.marginTop);
    this.marginLeft = Number.parseInt(this.el.dataset.marginLeft);
    this.marginBottom = Number.parseInt(this.el.dataset.marginBottom);
    this.marginRight = Number.parseInt(this.el.dataset.marginRight);
    this.xAxisMargin = Number.parseInt(this.el.dataset.xAxisMargin);

    this.xAxisLabelOffset = Number.parseInt(this.el.dataset.xAxisLabelOffset);
    this.yAxisLabelOffset = Number.parseInt(this.el.dataset.yAxisLabelOffset);

    this.xAxisTextOffset = Number.parseInt(this.el.dataset.xAxisTextOffset);
    this.yAxisTextOffset = Number.parseInt(this.el.dataset.yAxisTextOffset);

    this.xAxisLabel = this.el.dataset.xAxisLabel;
    this.yAxisLabel = this.el.dataset.yAxisLabel;
    this.yAxisWidth = this.el.dataset.yAxisWidth;
    this.index = this.el.dataset.index;

    this.yAxisFormat = this.el.dataset.yAxisFormat;
    this.yAxisTicks = this.el.dataset.yAxisTicks;

    this.aspectRatio = this.width / this.height;

    this.barPadding = 0.2;

    // ([d]) => -d.frequency,
    this.xAxisExtent = d3.groupSort(
      this.dataArray,
      ([d]) => d[this.index],
      (d) => d[this.index]
    );
  },

  resizeToWindowSize() {
    let targetWidth = this.el.getBoundingClientRect();
    let defaultWidth = Number.parseInt(this.el.dataset.width);

    this.width = Math.min(targetWidth.width, defaultWidth);

    if (this.width != defaultWidth) {
      this.height = this.width / this.aspectRatio;
    }

    let legendWidth = this.width - this.marginRight;

    if (this.yAxisLabel) {
      legendWidth = legendWidth + this.yAxisLabelOffset;
    }

    this.legend.style.width = `${legendWidth}px`;
  },
  draw(isUpdate = false) {
    //Recalculate the width and height
    if (isUpdate) {
      if (this.yAxisLabel) {
        this.width = this.width + this.yAxisLabelOffset;
        this.marginLeft = this.marginLeft + this.yAxisLabelOffset;
      }

      if (this.xAxisLabel) {
        this.height = this.height + this.xAxisLabelOffset;
        this.marginBottom = this.marginBottom + this.xAxisLabelOffset;
      }
    }

    // Create the SVG container.
    const svg = d3
      .create("svg")
      .attr("class", `${this.id}`)
      .attr("width", this.width)
      .attr("height", this.height);

    // Declare the x (horizontal position) scale.
    const x = d3
      .scaleBand()
      .domain(this.xAxisExtent)
      .range([
        this.marginLeft + this.xAxisMargin,
        this.width - this.marginRight - this.xAxisMargin,
      ])
      .padding(this.barPadding);

    // Declare the y (vertical position) scale.
    const y = d3
      .scaleLinear()
      .domain(
        d3.extent(
          (function (array, names, scale) {
            let res = [0];
            array.forEach(function (item) {
              names.forEach(function (name) {
                res = res.concat(item[name]);
              });
            });

            // Push a higher value multiplied by a constant to the array
            // This adds an extra tick to the y-axis

            sorted = res.sort(d3.ascending);

            res.push(sorted[sorted.length - 1] * scale);

            return res;
          })(
            this.dataArray,
            this.categories.map((e) => e.category),
            this.yAxisComp
          )
        )
      )
      .range([this.height - this.marginBottom, this.marginTop]);

    // Tooltip
    let tooltip = d3
      .select("body")
      .append("div")
      .attr(
        "class",
        `tooltip-donut annot pointer-events-none absolute ${this.tooltipFrameClass}`
      )
      .style("opacity", 0)
      .style("display", "none");

    // Add the vertical indicator
    svg
      .append("rect")
      .attr("class", "indicator pointer-events-none")
      .attr("opacity", "0")
      .attr("x", 0)
      .attr("y", this.marginTop)
      .attr("height", this.height - this.marginBottom - this.marginTop);

    // Add the x-axis.
    this.xAxis = svg
      .append("g")
      .attr("transform", `translate(${0},${this.height - this.marginBottom})`)
      .call(d3.axisBottom(x).tickSizeInner(0).tickSizeOuter(0))
      .call((g) =>
        g.selectAll(".tick text").attr("y", `${this.xAxisTextOffset}`)
      )
      .call((g) => g.select(".domain").remove())
      .call((g) => g.selectAll(".tick text").attr("class", this.labelClass));

    // Append x-axis label
    if (this.xAxisLabel) {
      this.xAxis
        .append("g")
        .attr(
          "transform",
          `translate(${this.width / 2 + this.xAxisMargin}, ${
            this.marginBottom - this.xAxisLabelOffset / 2
          })`
        )
        .append("text")
        .attr("class", `${this.axisLabelClass}`)
        .attr("text-anchor", "middle")
        .attr("transform", "rotate(0)")
        .text(this.xAxisLabel);
    }

    // Add the y-axis, remove the domain line, add grid lines and a label.
    this.yAxis = svg
      .append("g")
      .attr("transform", `translate(${this.marginLeft},0)`)
      .call(
        d3
          .axisLeft(y)
          .tickFormat(d3.format(this.yAxisFormat))
          .tickSizeInner(0)
          .tickSizeOuter(0)
          .ticks(this.yAxisTicks)
      )
      .call((g) => g.select(".domain").remove())
      .call((g) =>
        g
          .selectAll(".tick line")
          .clone()
          .attr("x2", this.width - this.marginLeft - this.marginRight)
          .attr("stroke-opacity", 0.1)
          .attr("class", "pointer-events-none")
      )
      .call((g) =>
        g
          .selectAll(".tick text")
          .attr("x", `-${this.yAxisTextOffset}`)
          .attr("class", "pointer-events-none")
      )
      .call((g) => g.selectAll(".tick text").attr("class", this.labelClass));

    if (this.categories.length > 1) {
      // Add invisible bars.
      this.categories.forEach((element) => {
        svg
          .append("g")
          .selectAll()
          .data(this.dataArray)
          .join("rect")
          .attr("x", (d) => x(d[this.index]) + (x.step() * x.padding()) / 2)
          .attr("y", (d) => y(d[element.category]))
          .attr("hide-color-id", (d) => d["color-id"])
          .attr("fill", "none")
          .attr("opacity", "0")
          .attr("class", `${this.barClass} ${element.bar}`)
          .attr("height", (d) => y(0) - y(d[element.category]))
          .attr("width", x.bandwidth() + x.padding() * x.step());
      });

      const cats = this.categories;
      const index = this.index;

      this.xSubgroup = d3
        .scaleBand()
        .domain(this.categories.map((e) => e.category))
        .range([0, x.bandwidth()])
        .padding([0.05]);

      const xSubgroupColor = d3
        .scaleOrdinal()
        .domain(this.categories.map((e) => e.category))
        .range(this.categories.map((e) => e.bar));

      // Add bars.
      svg
        .append("g")
        .selectAll()
        .data(this.dataArray)
        .enter()
        .append("g")
        .attr("transform", function (d) {
          return "translate(" + x(d[index]) + ",0)";
        })
        .selectAll("rect")
        .data(function (d) {
          return cats.map(function (cat) {
            return { cat: cat, value: d[cat.category], ...d };
          });
        })
        .enter()
        .append("rect")
        .attr("x", (d) => this.xSubgroup(d.cat.category))
        .attr("y", (d) => y(d.value))
        .attr("color-id", (d) => d["color-id"])
        .attr("fill", function (d) {
          return xSubgroupColor(d.cat.category);
        })
        .attr("class", `${this.barClass}`)
        // .attr("bar-category", element.category)
        .attr("height", (d) => y(0) - y(d.value))
        .attr("width", this.xSubgroup.bandwidth() - this.barPadding)
        .each(function (d) {
          this.classList.add(d.cat.bar);
          this.setAttribute("bar-category", d.cat.category);
        });
    } else {
      // Add bars.
      this.categories.forEach((element) => {
        svg
          .append("g")
          .selectAll()
          .data(this.dataArray)
          .join("rect")
          .attr("x", (d) => x(d[this.index]) + this.barPadding)
          .attr("y", (d) => y(d[element.category]))
          .attr("color-id", (d) => d["color-id"])
          .attr("fill", "currentColor")
          .attr("class", `${this.barClass} ${element.bar}`)
          .attr("height", (d) => y(0) - y(d[element.category]))
          .attr("width", x.bandwidth() - this.barPadding);
      });
    }

    // Append y-axis label
    if (this.yAxisLabel) {
      this.yAxis
        .append("g")
        .attr(
          "transform",
          `translate(-${this.yAxisWidth}, ${this.height / 2 - this.marginTop})`
        )
        .append("text")
        .attr("class", `${this.axisLabelClass}`)
        .attr("text-anchor", "middle")
        .attr("transform", "rotate(-90)")
        .text(this.yAxisLabel);
    }

    svg
      .on(
        "mousemove",
        throttle((d) => {
          if (!d.currentTarget) return;

          const clientBox = d.currentTarget.getBBox();
          const clientRect = d.currentTarget.getBoundingClientRect();

          const ticks = svg.selectAll(".tick line").nodes();
          const firstTick = ticks[0].getBoundingClientRect();
          const lastTick = ticks[ticks.length - 1].getBoundingClientRect();

          const localX = Math.round(
            ((d.clientX - clientRect.x) / clientRect.width) * clientBox.width
          );

          const localY = Math.round(
            ((d.clientY - clientRect.y) / clientRect.height) * clientBox.height
          );

          let box = {
            top: y(y.ticks().at(-2)),

            left: this.marginLeft - this.xAxisMargin,
            right: this.width - this.marginRight * 2,
            bottom: firstTick.y - lastTick.y,
          };

          // Check if the mouse is outside the chart axis box
          if (
            localY >= firstTick.y - this.height ||
            localX <= box.left ||
            localX >= box.right
          ) {
            let evt = new MouseEvent("mouseout");
            svg.node().dispatchEvent(evt);

            return;
          }

          // Find the closest bar to the mouse position and get its data
          let closestCategory = null;
          let idx = -1;
          let bars = [];
          let c = 1000;

          if (this.categories.length > 1) {
            bars = svg.selectAll(`rect[hide-color-id]`).nodes();
            c = x.bandwidth();
            idx = getClosesElementIndex(
              bars,
              localX + x.bandwidth() / 2,
              "x",
              c,
              true
            );
          } else {
            bars = svg.selectAll(`rect[color-id]`).nodes();
            idx = getClosesElementIndex(bars, localX, "x", c, false);
          }

          if (idx == -1) {
            let evt = new MouseEvent("mouseout");
            svg.node().dispatchEvent(evt);

            return;
          }

          let bar = bars[idx]; //get bar
          let d3Bar = d3.select(bar);
          closestCategory = d3Bar.datum();

          const xLocation = parseXAxisValue(
            this.xAxisType,
            this.xAxisFormat,
            closestCategory[this.index]
          );

          svg
            .selectAll(".indicator")
            .style("opacity", 0.03)
            .attr("x", x(xLocation) - (x.step() * x.padding()) / 2)
            .attr("y", y(y.ticks().at(-2)))
            .attr("height", firstTick.y - lastTick.y)
            .attr("width", x.bandwidth() + x.step() * x.padding());

          tooltip
            .transition()
            .duration("10")
            .style("opacity", 1)
            .style("display", "block");

          let tooltipContent = buildTooltip(
            closestCategory[this.index],
            closestCategory,
            this.categories
          );

          tooltip.html(tooltipContent.innerHTML);

          // Wait for tooltip to render
          window.requestAnimationFrame(() => {
            const { width } = tooltip.node().getBoundingClientRect();

            if (clientBox.width - x(xLocation) < width * 0.85) {
              tooltip
                .style("left", x(xLocation) + clientRect.x + 24 - width + "px")
                .style(
                  "top",
                  clientRect.top +
                    y(y.ticks().at(-2)) / 2 -
                    this.marginTop +
                    "px"
                );
            } else {
              tooltip
                .style("left", x(xLocation) + clientRect.x + 24 + "px")
                .style(
                  "top",
                  clientRect.top +
                    y(y.ticks().at(-2)) / 2 -
                    this.marginTop +
                    "px"
                );
            }
          });
        }, 128)
      )
      .on("mouseout", (d) => {
        if (!d.currentTarget) return;

        const clientBox = d.currentTarget.getBBox();

        const clientRect = d.currentTarget.getBoundingClientRect();

        const localX = Math.round(
          ((d.clientX - clientRect.x) / clientRect.width) * clientBox.width
        );

        const localY = Math.round(
          ((d.clientY - clientRect.y) / clientRect.height) * clientBox.height
        );

        const ticks = svg.selectAll(".tick line").nodes();
        const firstTick = ticks[0].getBoundingClientRect();
        const lastTick = ticks[ticks.length - 1].getBoundingClientRect();

        let box = {
          top: y(y.ticks().at(-2)),
          left: this.marginLeft - this.xAxisMargin,
          right: this.width - this.marginRight * 2,
          bottom: firstTick.y - lastTick.y,
        };

        if (
          doesPointCollide(
            { x: localX - box.left, y: localY - box.top },
            box
          ) &&
          localX <= box.right
        ) {
          return;
        }

        //Remove all the annotations - indicator, bars and tooltip
        svg.selectAll(".chartannotation").remove();

        tooltip
          .transition()
          .duration("10")
          .style("opacity", 0)
          .style("display", "none");

        svg.selectAll(".indicator").style("opacity", 0);
      });

    // Display the legend
    this.legend.classList.remove("hidden");

    // Append the svg chart to the element
    this.el.appendChild(svg.node());

    // Add an event listener for the legend items click event
    this.el.addEventListener("legendclick", (e) =>
      onLegendClick(e, svg, this.categories)
    );
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

export default BarChart;
