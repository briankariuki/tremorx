defmodule Tremorx.Components.Badge do
  @moduledoc """
  Renders a badge
  """

  alias Tails
  alias Tremorx.Theme
  alias Tremorx.Assets

  use Phoenix.Component

  attr :class, :string, default: nil
  attr :color, :string, default: nil
  attr :size, :string, default: "sm", values: ~w(xs sm md lg xl)
  attr :rest, :global
  slot :icon
  slot :inner_block

  @doc """
  Badges are subtle elements to highlight information which are often used in tables and lists as well as in combination with metrics
  """
  def badge(assigns) do
    ~H"""
    <span
      class={
        Tails.classes([
          Theme.make_class_name("Badge", "root"),
          "w-max flex-shrink-0 inline-flex justify-center items-center cursor-default rounded-tremor-full",
          if(is_nil(@color),
            do:
              Tails.classes([
                # light
                "bg-tremor-brand-muted text-tremor-brand-emphasis",
                # dark
                "dark:bg-dark-tremor-brand-muted dark:text-dark-tremor-brand-emphasis"
              ]),
            else:
              Tails.classes([
                Theme.get_color_style(@color, "background", "bg"),
                Theme.get_color_style(@color, "text", "text"),
                "bg-opacity-20 dark:bg-opacity-25"
              ])
          ),
          Theme.get_badge_proportion_style(@size, "padding_x"),
          Theme.get_badge_proportion_style(@size, "padding_y"),
          Theme.get_badge_proportion_style(@size, "font_size"),
          if(is_nil(@class), do: "", else: @class)
        ])
      }
      {@rest}
    >
      <div
        :if={@icon != []}
        class={
          Tails.classes([
            Theme.make_class_name("Badge", "icon"),
            "shrink-0 -ml-1 mr-1.5 flex items-center",
            Theme.get_icon_size_style(@size, "height"),
            Theme.get_icon_size_style(@size, "width")
          ])
        }
      >
        <%= render_slot(@icon) %>
      </div>

      <p class={
        Tails.classes([
          Theme.make_class_name("Badge", "text"),
          "text-sm whitespace-nowrap"
        ])
      }>
        <%= render_slot(@inner_block) %>
      </p>
    </span>
    """
  end

  attr :class, :string, default: nil
  attr :size, :string, default: "sm", values: ~w(xs sm md lg xl)

  attr :delta_type, :string,
    default: "increase",
    values: ~w(increase moderate_increase decrease moderate_decrease unchanged)

  attr :rest, :global
  slot :inner_block

  @doc """
  Renders a badge delta
  """
  def badge_delta(assigns) do
    ~H"""
    <span
      class={
        Tails.classes([
          Theme.make_class_name("BadgeDelta", "root"),
          "w-max flex-shrink-0 inline-flex justify-center items-center cursor-default rounded-tremor-full bg-opacity-20 dark:bg-opacity-25",
          get_badge_delta_color(@delta_type, "bg_color"),
          get_badge_delta_color(@delta_type, "text_color"),
          Theme.get_badge_proportion_style(@size, "padding_x"),
          Theme.get_badge_proportion_style(@size, "padding_y"),
          Theme.get_badge_proportion_style(@size, "font_size"),
          if(is_nil(@class), do: "", else: @class)
        ])
      }
      {@rest}
    >
      <div class={
        Tails.classes([
          Theme.make_class_name("Badge", "icon"),
          "shrink-0 flex items-center",
          if(@inner_block != [], do: "-ml-1 mr-1.5", else: Theme.get_icon_size_style(@size, "height")),
          Theme.get_icon_size_style(@size, "width")
        ])
      }>
        <Assets.arrow_up_icon :if={@delta_type == "increase"} />
        <Assets.arrow_up_right_icon :if={@delta_type == "moderate_increase"} />
        <Assets.arrow_down_icon :if={@delta_type == "decrease"} />
        <Assets.arrow_down_right_icon :if={@delta_type == "moderate_decrease"} />
        <Assets.arrow_right_icon :if={@delta_type == "unchanged"} />
      </div>

      <p class={
        Tails.classes([
          Theme.make_class_name("BadgeDelta", "text"),
          "text-sm whitespace-nowrap"
        ])
      }>
        <%= render_slot(@inner_block) %>
      </p>
    </span>
    """
  end

  defp get_badge_delta_color(delta, key) do
    %{
      increase: %{
        bg_color: Theme.get_color_style("emerald", "background", "bg"),
        text_color: Theme.get_color_style("emerald", "text", "text")
      },
      moderate_increase: %{
        bg_color: Theme.get_color_style("emerald", "background", "bg"),
        text_color: Theme.get_color_style("emerald", "text", "text")
      },
      decrease: %{
        bg_color: Theme.get_color_style("rose", "background", "bg"),
        text_color: Theme.get_color_style("rose", "text", "text")
      },
      moderate_decrease: %{
        bg_color: Theme.get_color_style("rose", "background", "bg"),
        text_color: Theme.get_color_style("rose", "text", "text")
      },
      unchanged: %{
        bg_color: Theme.get_color_style("orange", "background", "bg"),
        text_color: Theme.get_color_style("orange", "text", "text")
      }
    }
    |> Map.get(String.to_atom(delta))
    |> Map.get(String.to_atom(key))
  end
end
