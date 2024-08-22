import d3 from "./d3.min.js";

import {
  buildTooltip,
  parseXAxisValue,
  formatXAxisValue,
  xAxisTicks,
  getClosestDotIndex,
  onLegendClick,
  throttle,
} from "./chart.js";

const AreaChart = {
  mounted() {
    this.id = this.el.getAttribute("id").split("-hook")[0];

    // Initiate the state on first mount
    this.updateState();

    this.el.classList.add(`w-[${this.width}px]`, `h-[${this.height}px]`);
    this.legend = this.el.querySelector(`#${this.id}-legend`);

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
    this.categories = JSON.parse(this.categories);
    this.labelClass = this.el.dataset.labelClass;
    this.axisLabelClass = this.el.dataset.axisLabelClass;
    this.dotClass = this.el.dataset.dotClass;
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

    this.xAxisType = this.el.dataset.xAxisType;
    this.xAxisFormat = this.el.dataset.xAxisFormat;
    this.yAxisFormat = this.el.dataset.yAxisFormat;
    this.yAxisTicks = this.el.dataset.yAxisTicks;
    this.xAxisTicks = this.el.dataset.xAxisTicks;

    this.aspectRatio = this.width / this.height;

    this.xAxisExtent = d3.extent(this.dataArray, (d) =>
      parseXAxisValue(this.xAxisType, this.xAxisFormat, d[this.index])
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
      .attr("class", this.id)
      .attr("width", this.width)
      .attr("height", this.height);

    // Helper to parse x axis value

    // Declare the x (horizontal position) scale.
    const x = d3
      .scaleUtc()
      .domain(this.xAxisExtent)
      .range([
        this.marginLeft + this.xAxisMargin,
        this.width - this.marginRight - this.xAxisMargin,
      ]);

    // Declare the y (vertical position) scale.
    const y = d3
      .scaleLinear()
      .domain(
        d3.extent(
          (function (array, names) {
            var res = [0];
            array.forEach(function (item) {
              names.forEach(function (name) {
                res = res.concat(item[name]);
              });
            });

            // Push a higher value multiplied by a constant to the array
            // This adds an extra tick to the y-axis

            res.push(res[1] * 1.5);

            return res;
          })(
            this.dataArray,
            this.categories.map((e) => e.category)
          )
        )
      )
      .range([this.height - this.marginBottom, this.marginTop]);
    const defs = svg.append("defs");

    // Add the areas and lines.
    this.categories.forEach((element) => {
      const area = d3
        .area()
        .x((d) =>
          x(parseXAxisValue(this.xAxisType, this.xAxisFormat, d[this.index]))
        )
        .y0(y(0))
        .y1((d) => y(d[element.category]));

      const line = d3
        .line()
        .x((d) =>
          x(parseXAxisValue(this.xAxisType, this.xAxisFormat, d[this.index]))
        )
        .y((d) => y(d[element.category]));

      // Define the gradient
      const gradient = defs
        .append("linearGradient")
        .attr("id", `${element.color}`)
        .attr("class", `${element.gradient}`)
        .attr("x1", "0%")
        .attr("y1", "0%")
        .attr("x2", "0%")
        .attr("y2", "100%");

      gradient
        .append("stop")
        .attr("offset", "5%")
        .attr("stop-color", "currentColor")
        .attr("stop-opacity", 0.15);

      gradient
        .append("stop")
        .attr("offset", "95%")
        .attr("stop-color", "currentColor")
        .attr("stop-opacity", 0);

      // Append a path for the area (under the axes).
      svg
        .append("path")
        .attr("fill", `url(#${element.color})`)
        .attr("area-category", element.category)
        .attr("d", area(this.dataArray));

      // Append a line path
      svg
        .append("path")
        .attr(
          "class",
          `${element.gradient} hover:cursor-pointer pointer-events-none`
        )
        .attr("line-category", element.category)
        .attr("stroke", "currentColor")
        .attr("stroke-width", "2")
        .attr("stroke-opacity", "1")
        .attr("stroke-linecap", "round")
        .attr("stroke-linejoin", "round")
        .attr("fill-opacity", "0.6")
        .attr("fill", "none")
        .attr("d", line(this.dataArray));
    });

    // Add the vertical indicator
    svg
      .append("line")
      .attr("class", "indicator pointer-events-none")
      .style("stroke", "#d1d5db")
      .attr("stroke-width", "1")
      .attr("opacity", "0")
      .attr("x1", 0)
      .attr("y1", this.marginTop)
      .attr("x2", 0)
      .attr("y2", this.height - this.marginBottom);

    // Add the dots
    this.categories.forEach((element) => {
      let index = this.index;

      let xAxisType = this.xAxisType;
      let xAxisFormat = this.xAxisFormat;

      svg
        .append("g")
        .selectAll("circle")
        .data(this.dataArray)
        .enter()
        .append("circle")
        .attr("r", 5)
        .attr("dot-category", element.category)
        .attr("cx", function (d) {
          return x(parseXAxisValue(xAxisType, xAxisFormat, d[index]));
        })
        .attr("cy", function (d) {
          return y(d[element.category]);
        })
        .attr("class", `${this.dotClass} ${element.dot} hover:cursor-pointer`)
        .attr("opacity", 0);
    });

    // Add the x-axis.
    this.xAxis = svg
      .append("g")
      .attr("transform", `translate(${0},${this.height - this.marginBottom})`)
      .call(
        d3
          .axisBottom(x)
          .tickFormat((value) =>
            formatXAxisValue(this.xAxisType, this.xAxisFormat, value)
          )
          .ticks(xAxisTicks(this.xAxisExtent, this.xAxisType, this.xAxisTicks))
          .tickSizeInner(0)
          .tickSizeOuter(0)
      )
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

    // console.log(this.yAxisFormat);

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

    // Add the mouseover event listener
    svg
      .on(
        "mousemove",
        throttle((d) => {
          if (!d.currentTarget) return;
          const clientBox = d.currentTarget.getBBox();
          const clientRect = d.currentTarget.getBoundingClientRect();

          const localX = Math.round(
            ((d.clientX - clientRect.x) / clientRect.width) * clientBox.width
          );

          // Find the closest dot to the mouse position and get its data
          let closestCategory = null;

          this.categories.forEach((element) => {
            let idx = -1;

            const dots = svg
              .selectAll(`circle[dot-category="${element.category}"]`)
              .nodes();

            idx = getClosestDotIndex(dots, localX);

            let dot = dots[idx]; //get dot
            let d3Dot = d3.select(dot);
            closestCategory = d3Dot.datum();
            d3Dot.transition().duration("10").attr("opacity", "1");

            dots.forEach(function (d, i) {
              if (i != idx) {
                let dot = d3.select(d);

                if (dot) dot.transition().duration("10").attr("opacity", "0");
              }
            });
          });

          // svg.selectAll(".chartannotation").remove();

          const xLocation = parseXAxisValue(
            this.xAxisType,
            this.xAxisFormat,
            closestCategory.date
          );

          svg
            .selectAll(".indicator")
            .style("opacity", 1)
            .attr("x1", x(xLocation))
            .attr("x2", x(xLocation))
            .attr("y1", this.marginTop + this.marginTop)
            .attr("y2", this.height - this.marginBottom);

          tooltip
            .transition()
            .duration("10")
            .style("opacity", 1)
            .style("display", "block");

          let tooltipContent = buildTooltip(
            closestCategory.date,
            closestCategory,
            this.categories
          );

          tooltip.html(tooltipContent.innerHTML);

          // Wait for tooltip to render
          window.requestAnimationFrame(() => {
            const { width } = tooltip.node().getBoundingClientRect();

            if (clientBox.width - x(xLocation) < width * 0.85) {
              tooltip
                .style("left", x(xLocation) + clientRect.x - 8 - width + "px")
                .style("top", clientRect.top - this.marginTop + "px");
            } else {
              tooltip
                .style("left", x(xLocation) + clientRect.x + 8 + "px")
                .style("top", clientRect.top - this.marginTop + "px");
            }
          });
        }, 80)
      )
      .on("mouseout", (_) => {
        //Remove all the annotations - indicator, dots and tooltip
        svg.selectAll(".chartannotation").remove();

        tooltip
          .transition()
          .duration("10")
          .style("opacity", 0)
          .style("display", "none");

        svg.selectAll(".indicator").style("opacity", 0);

        this.categories.forEach((element) => {
          const dots = svg
            .selectAll(`circle[dot-category="${element.category}"]`)
            .nodes();

          dots.forEach(function (d, i) {
            let dot = d3.select(d);

            if (dot) dot.transition().duration("10").attr("opacity", "0");
          });
        });
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

export default AreaChart;
