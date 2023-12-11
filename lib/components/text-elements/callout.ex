defmodule Tremorx.Components.Callout do
  @moduledoc """
  Renders a Callout card
  """

  alias Tails
  alias Tremorx.Theme

  use Phoenix.Component

  attr(:title, :string, required: true)
  attr(:color, :string, required: false, default: nil)
  attr(:class, :string, required: false, default: nil)
  slot(:inner_block, required: false)
  slot(:icon, required: false)
  attr(:rest, :global)

  @doc """
  Renders a callout
  """
  def callout(assigns) do
    ~H"""
    <div
      class={
        Tails.classes([
          Theme.make_class_name("callout", "root"),
          "flex flex-col overflow-hidden rounded-tremor-default text-tremor-default",
          if(is_nil(@color),
            do:
              Tails.classes([
                # light
                "bg-tremor-brand-faint border-tremor-brand-emphasis text-tremor-brand-emphasis",
                # dark
                "dark:bg-dark-tremor-brand-muted/70 dark:border-dark-tremor-brand-emphasis dark:text-dark-tremor-brand-emphasis"
              ]),
            else:
              Tails.classes([
                Theme.get_color_style(@color, "background", "bg"),
                Theme.get_color_style(@color, "dark_border", "border"),
                Theme.get_color_style(@color, "dark_text", "text"),
                "dark:bg-opacity-10 bg-opacity-10"
              ])
          ),
          Theme.get_spacing_style("lg", "padding_y"),
          Theme.get_spacing_style("lg", "padding_right"),
          Theme.get_spacing_style("two_xl", "padding_left"),
          Theme.get_border_style("lg", "left"),
          if(is_nil(@class), do: "", else: @class)
        ])
      }
      {@rest}
    >
      <div class={
        Tails.classes([
          Theme.make_class_name("callout", "header"),
          "flex items-start"
        ])
      }>
        <span
          :if={@icon != []}
          class={
            Tails.classes([
              Theme.make_class_name("callout", "icon"),
              "flex-none",
              Theme.get_sizing_style("lg", "height"),
              Theme.get_sizing_style("lg", "width"),
              Theme.get_spacing_style("xs", "margin_right")
            ])
          }
        >
          <% # <.icon name="hero-arrow-up-right" /> %>
          <%= render_slot(@icon) %>
        </span>
        <h4 class={
          Tails.classes([
            Theme.make_class_name("callout", "title"),
            "font-semibold"
          ])
        }>
          <%= @title %>
        </h4>
      </div>

      <p class={
        Tails.classes([
          Theme.make_class_name("callout", "body"),
          "overflow-y-auto",
          if(is_nil(@inner_block), do: "", else: Theme.get_spacing_style("sm", "margin_top"))
        ])
      }>
        <%= render_slot(@inner_block) %>
      </p>
    </div>
    """
  end
end
