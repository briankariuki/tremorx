defmodule Tremorx.Components.BarChart do
  @moduledoc """
  Renders BarChart
  """

  use Phoenix.Component
  alias Tails
  alias Tremorx.Theme
  alias Phoenix.LiveView.JS

  import Tremorx.Components.Legend

  attr :id, :string, default: "barchart", doc: "The id of the chart"

  attr :width, :integer,
    default: 640,
    doc:
      "The width of the chart. The chart will be resized to fit the available width before rendering"

  attr :height, :integer,
    default: 320,
    doc:
      "The height of the chart. The chart will be resized to fit the availabe height before rendering"

  attr :margin_top, :integer,
    default: 20,
    doc: "The top margin of the chart. Applied to the y axis range"

  attr :margin_right, :integer,
    default: 20,
    doc: "The right margin of the chart. Applied to the x axis range"

  attr :margin_bottom, :integer,
    default: 30,
    doc: "The bottom margin of the chart. Applied to the y axis range"

  attr :margin_left, :integer,
    default: 50,
    doc: "The left margin of the chart. Applied to the x axis range"

  attr :x_axis_margin, :integer,
    default: 20,
    doc: "The margin between x axis labels and the x axis line"

  attr :y_axis_width, :integer, default: 60, doc: "The width of the y axis labels"
  attr :x_axis_label, :string, default: nil, doc: "The label of the x axis"
  attr :y_axis_label, :string, default: nil, doc: "The label of the y axis"

  attr :y_axis_format, :string,
    default: "(,.0f",
    doc: "A format to apply to the y axis values. See d3-format for more information"

  attr :y_axis_ticks, :integer, default: 5, doc: "The minimum number of ticks on the y axis"

  attr :x_axis_label_offset, :integer, default: 32, doc: "The offset of the x axis label"
  attr :y_axis_label_offset, :integer, default: 30, doc: "The offset of the y axis label"

  attr :x_axis_text_offset, :integer,
    default: 16,
    doc: "The y-offset of the x axis ticks from the x axis line"

  attr :y_axis_text_offset, :integer,
    default: 8,
    doc: "The x-offset of the y axis ticks from the y axis line"

  attr :legend_height, :integer, default: 44, doc: "The height of the legend"

  attr :index, :string,
    required: true,
    doc: "The index of the data. This determines which value is used to create the x axis"

  attr :data, :list, required: true, doc: "The data to display on the chart"
  attr :categories, :list, required: true, doc: "The categories to display on the chart"
  attr :colors, :list, default: [], doc: "The colors to use for each category"
  attr :class, :string, default: nil, doc: "css classes to apply to the chart wrapper container"
  attr :rest, :global

  @doc """
  Bar charts compare numerical values and use the length of each bar to represent the value of each variable.
  """
  def bar_chart(assigns) do
    categories = build_categories(assigns.categories, assigns.colors)

    assigns =
      assign(assigns,
        categories: categories,
        categories_string: Jason.encode!(categories),
        data_string: Jason.encode!(assigns.data),
        legend_width:
          assigns.width - assigns.margin_right +
            if(is_nil(assigns.y_axis_label), do: 0, else: assigns.y_axis_label_offset),
        label_class:
          Tails.classes([
            # common
            "text-tremor-label",
            # light
            "fill-tremor-content",
            # dark
            "dark:fill-dark-tremor-content"
          ]),
        bar_class:
          Tails.classes([
            # common
            ""
          ]),
        axis_label_class:
          Tails.classes([
            "fill-tremor-content-emphasis text-tremor-default font-medium dark:fill-dark-tremor-content-emphasis"
          ]),
        tooltip_frame_class:
          Tails.classes([
            # common
            "rounded-tremor-default text-tremor-default border",
            # light
            "bg-tremor-background shadow-tremor-dropdown border-tremor-border",
            # dark
            "dark:bg-dark-tremor-background dark:shadow-dark-tremor-dropdown dark:border-dark-tremor-border"
          ])
      )

    ~H"""
    <div id={@id} class="pr-0 w-full h-full">
      <div
        phx-hook="BarChart"
        id={@id <> "-hook"}
        data-items={@data_string}
        data-categories={@categories_string}
        data-label-class={@label_class}
        data-bar-class={@bar_class}
        data-tooltip-frame-class={@tooltip_frame_class}
        data-width={@width}
        data-height={@height}
        data-margin-bottom={@margin_bottom}
        data-margin-top={@margin_top}
        data-margin-left={@margin_left}
        data-margin-right={@margin_right}
        data-x-axis-margin={@x_axis_margin}
        data-y-axis-width={@y_axis_width}
        data-y-axis-label={@y_axis_label}
        data-x-axis-label={@x_axis_label}
        data-axis-label-class={@axis_label_class}
        data-x-axis-label-offset={@x_axis_label_offset}
        data-y-axis-label-offset={@y_axis_label_offset}
        data-x-axis-text-offset={@x_axis_text_offset}
        data-y-axis-text-offset={@y_axis_text_offset}
        data-legend-height={@legend_height}
        data-legend-width={@legend_width}
        data-index={@index}
        data-y-axis-format={@y_axis_format}
        data-y-axis-ticks={@y_axis_ticks}
        class={
          Tails.classes([
            Theme.make_class_name("barchart", "root"),
            "relative",
            if(is_nil(@class), do: "", else: @class)
          ])
        }
        {@rest}
      >
        <div
          id={@id <> "-legend"}
          class={"absolute hidden left-0 w-[#{@legend_width}px]"}
          style={"width: #{@legend_width}px; height: #{@legend_height}px; top: 5px;"}
        >
          <.legend id={@id <> "-legend-main"} class="flex justify-end items-center">
            <:legend_item
              :for={category <- @categories}
              name={category.category}
              color={category.color}
              on_click={
                JS.dispatch("legendclick",
                  to: "##{@id}-hook",
                  detail: %{category: category.category}
                )
              }
            >
            </:legend_item>

            <%!-- <:scroll_left_icon>
              <.icon name="hero-chevron-left" />
            </:scroll_left_icon>
            <:scroll_right_icon>
              <.icon name="hero-chevron-right" />
            </:scroll_right_icon> --%>
          </.legend>
        </div>
      </div>
    </div>
    """
  end

  defp build_categories(categories, colors) do
    Enum.with_index(categories, fn element, index -> {index, element} end)
    |> Enum.map(fn {i, category} ->
      color = Enum.at(colors, i, get_category_colors(i, Theme.colors()))

      linear_g_color = Theme.get_color_style(color, "text", "text")
      bar_color = Theme.get_color_style(color, "background", "fill")
      bar_bg_color = Theme.get_color_style(color, "background", "bg")

      %{
        category: category,
        color: color,
        gradient: linear_g_color,
        bar: bar_color,
        background: bar_bg_color
      }
    end)
  end

  defp get_category_colors(_i, colors) do
    Enum.random(colors)
  end
end
