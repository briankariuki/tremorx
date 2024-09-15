defmodule Tremorx.Components.DonutChart do
  @moduledoc """
  Renders DonutChart
  """

  use Phoenix.Component
  alias Tails
  alias Tremorx.Theme

  attr :id, :string, default: "donutchart", doc: "The id of the chart"

  attr :value, :string,
    required: true,
    doc: "The value key of the data."

  attr :category, :string,
    required: true,
    doc: "The category key of the data."

  attr :label, :string,
    required: false,
    default: "",
    doc: "The label of the data."

  attr :show_animation, :boolean,
    required: false,
    default: false,
    doc: "Whether to show animation when the chart is rendered."

  attr :show_label, :boolean,
    required: false,
    default: false,
    doc: "Whether to show the label."

  attr :show_tooltip, :boolean,
    required: false,
    default: true,
    doc: "Whether to show the tooltip on hover."

  attr :no_data_text, :string,
    required: false,
    default: "",
    doc: "The text to display when there is no data."

  attr :value_format, :string,
    required: false,
    default: "(,.0f",
    doc: "The format to use for the value."

  attr :data, :list, required: true, doc: "The data to display on the chart"
  attr :colors, :list, default: [], doc: "The colors to use for each category"
  attr :class, :string, default: nil, doc: "css classes to apply to the chart wrapper container"
  attr :variant, :string, default: "donut", doc: "The variant of the chart", values: ~w(donut pie)
  attr :rest, :global

  @doc """
  A donut chart displays quantitative information through a circular visualization.
  """
  def donut_chart(assigns) do
    categories =
      Enum.map(assigns.data, fn d -> Map.get(d, assigns.category) end)
      |> build_categories(assigns.colors)

    assigns =
      assign(assigns,
        data_string: Jason.encode!(assigns.data),
        categories: categories,
        categories_string: Jason.encode!(categories),
        label_class:
          Tails.classes([
            # common
            "text-tremor-label",
            # light
            "fill-tremor-content",
            # dark
            "dark:fill-dark-tremor-content",
            "text-base"
          ]),
        donut_class:
          Tails.classes([
            # common
            ""
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
        phx-hook="DonutChart"
        id={@id <> "-hook"}
        data-items={@data_string}
        data-value={@value}
        data-category={@category}
        data-categories={@categories_string}
        data-tooltip-frame-class={@tooltip_frame_class}
        data-label={@label}
        data-variant={@variant}
        data-show-animation={"#{@show_animation}"}
        data-show-label={"#{@show_label}"}
        data-show-tooltip={"#{@show_tooltip}"}
        data-no-data-text={@no_data_text}
        data-label-class={@label_class}
        data-donut-class={@donut_class}
        data-value-format={@value_format}
        class={
          Tails.classes([
            Theme.make_class_name("donutchart", "root"),
            "w-full h-40",
            if(is_nil(@class), do: "", else: @class)
          ])
        }
        {@rest}
      >
      </div>
    </div>
    """
  end

  defp build_categories(categories, colors) do
    Enum.with_index(categories, fn element, index -> {index, element} end)
    |> Enum.map(fn {i, category} ->
      color = Enum.at(colors, i, get_category_colors(i, Theme.colors()))

      linear_g_color = Theme.get_color_style(color, "text", "text")
      donut_color = Theme.get_color_style(color, "background", "fill")
      donut_bg_color = Theme.get_color_style(color, "background", "bg")

      %{
        category: category,
        color: color,
        gradient: linear_g_color,
        donut: donut_color,
        background: donut_bg_color
      }
    end)
  end

  defp get_category_colors(_i, colors) do
    Enum.random(colors)
  end
end
