defmodule Tremorx.Components.Layout do
  @moduledoc """
  Flex, Grid, Divider and Card
  """

  alias Tails
  alias Tremorx.Theme
  use Phoenix.Component

  attr(:flex_direction, :string, default: "row")
  attr(:justify_content, :string, default: "between")
  attr(:align_items, :string, default: "center")
  attr(:class, :string, required: false, default: nil)
  slot(:inner_block, required: false)
  attr(:rest, :global)

  @doc """
  Renders a flex
  """
  def flex(assigns) do
    ~H"""
    <div
      class={
        Tails.classes([
          Theme.make_class_name("flex", "root"),
          "flex w-full",
          Theme.get_flex_direction_style(@flex_direction),
          Theme.get_align_items_style(@align_items),
          Theme.get_justify_content_style(@justify_content),
          if(is_nil(@class), do: "", else: @class)
        ])
      }

      {@rest}
    >
    <%= render_slot(@inner_block) %>
    </div>
    """
  end

  attr(:class, :string, required: false, default: nil)
  slot(:inner_block, required: false, default: nil)
  attr(:rest, :global)

  def divider(%{inner_block: []} = assigns) do
    ~H"""
      <div
      class={
        Tails.classes([
          Theme.make_class_name("divider", "root"),
          "w-full mx-auto my-6 flex justify-between gap-3 items-center text-tremor-default",
          "text-tremor-content",
          "dark:text-dark-tremor-content",
          if(is_nil(@class), do: "", else: @class)
        ])}

        {@rest}
      >
          <div class={Tails.classes(["w-full h-[1px] bg-tremor-border dark:bg-dark-tremor-border"])}>
          </div>
      </div>
    """
  end

  def divider(assigns) do
    ~H"""
    <%!-- h-[1px] --%>
      <div
      class={
        Tails.classes([
          Theme.make_class_name("divider", "root"),
          "w-full mx-auto my-6 flex justify-between gap-3 items-center text-tremor-default",
          "text-tremor-content",
          "dark:text-dark-tremor-content",
          if(is_nil(@class), do: "", else: @class)
        ])}

        {@rest}
      >

        <div class={Tails.classes(["w-full h-[1px] bg-tremor-border dark:bg-dark-tremor-border"])}>
        </div>

        <div class={Tails.classes(["text-inherit whitespace-nowrap"])}>
          <%= render_slot(@inner_block) %>
        </div>

        <div class={Tails.classes(["w-full h-[1px] bg-tremor-border dark:bg-dark-tremor-border"])}>
        </div>
      </div>
    """
  end

  attr(:num_items, :string, default: "1")
  attr(:num_items_sm, :string, default: nil)
  attr(:num_items_md, :string, default: nil)
  attr(:num_items_lg, :string, default: nil)
  slot(:inner_block, required: false)
  attr(:rest, :global)
  attr(:class, :string, required: false, default: nil)

  @doc """
  Renders a grid
  """
  def grid(assigns) do
    ~H"""
    <div
      class={
        Tails.classes([
          Theme.make_class_name("grid", "root"),
          "grid",
          Theme.get_grid_cols_style(@num_items),
          if(is_nil(@num_items_sm), do: "", else: Theme.get_grid_cols_style("sm", @num_items_sm)),
          if(is_nil(@num_items_md), do: "", else: Theme.get_grid_cols_style("md", @num_items_md)),
          if(is_nil(@num_items_lg), do: "", else: Theme.get_grid_cols_style("lg", @num_items_lg)),
          if(is_nil(@class), do: "", else: @class)
        ])} {@rest}>
        <%= render_slot(@inner_block) %>
    </div>
    """
  end

  attr(:num_col_span, :string, default: "1")
  attr(:num_col_span_sm, :string, default: nil)
  attr(:num_col_span_md, :string, default: nil)
  attr(:num_col_span_lg, :string, default: nil)
  slot(:inner_block, required: false)
  attr(:rest, :global)
  attr(:class, :string, required: false, default: nil)

  @doc """
  Renders a col
  """
  def col(assigns) do
    ~H"""
    <div
      class={
        Tails.classes([
          Theme.make_class_name("col", "root"),
          Theme.get_col_span_style(@num_col_span),
          if(is_nil(@num_col_span_sm), do: "", else: Theme.get_col_span_style("sm", @num_col_span_sm)),
          if(is_nil(@num_col_span_md), do: "", else: Theme.get_col_span_style("md", @num_col_span_md)),
          if(is_nil(@num_col_span_lg), do: "", else: Theme.get_col_span_style("lg", @num_col_span_lg)),
          if(is_nil(@class), do: "", else: @class)
        ])} {@rest}>
        <%= render_slot(@inner_block) %>
    </div>
    """
  end

  attr(:decoration, :string, default: "none", values: ~w(top bottom left right none))
  attr(:decoration_color, :string, required: false, default: nil)
  slot(:inner_block, required: false)
  attr(:rest, :global)
  attr(:class, :string, required: false, default: nil)

  @doc """
  Renders a card
  """
  def card(assigns) do
    ~H"""
      <div
        class={
          Tails.classes([
            Theme.make_class_name("card", "root"),
            "relative w-full text-left ring-1 rounded-tremor-default",
            "bg-tremor-background ring-tremor-ring shadow-tremor-card",
            "dark:bg-dark-tremor-background dark:ring-dark-tremor-ring dark:shadow-dark-tremor-card",

            if(is_nil(@decoration_color),
              do:
                "border-tremor-brand dark:border-dark-tremor-brand",
              else:
                Tails.classes([
                  Theme.get_color_style(@decoration_color, "border", "border"),
                ])
            ),
            Theme.get_decoration_alignment_style(@decoration),
            Theme.get_spacing_style("three_xl", "padding_all"),
            if(is_nil(@class), do: "", else: @class)
          ])
      } {@rest}>
        <%= render_slot(@inner_block) %>
      </div>
    """
  end
end
