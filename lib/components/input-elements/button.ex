defmodule Tremorx.Components.Button do
  @moduledoc """
  Button
  """

  alias Tails
  alias Tremorx.Theme
  import Tremorx.Assets
  use Phoenix.Component

  attr(:icon_position, :string, default: "left", values: ~w(left right))
  attr(:size, :string, default: "sm", values: ~w(xs sm md lg xl))
  attr(:color, :string, default: nil)
  attr(:class, :string, default: nil)
  attr(:variant, :string, default: "primary", values: ~w(primary secondary light))
  attr(:type, :string, default: "button", values: ~w(button submit))
  attr(:disabled, :boolean, default: nil)
  attr(:loading, :boolean, default: false)
  attr(:loading_text, :string, default: nil)
  attr(:tooltip, :string, default: nil)
  slot(:inner_block, required: false)
  slot(:icon, required: false)
  attr(:rest, :global)

  @doc """
  Renders a button
  """
  def button(assigns) do
    assigns =
      assign(assigns,
        button_color_style: get_button_colors(assigns[:variant], assigns[:color]),
        button_proportion_style:
          Theme.get_button_proportion_style(assigns[:variant], assigns[:size]),
        icon_size:
          Tails.classes([
            Theme.get_icon_size_style(assigns[:size], "width"),
            Theme.get_icon_size_style(assigns[:size], "height")
          ]),
        is_disabled: assigns[:loading] || assigns[:disabled],
        show_icon: assigns[:icon] != [] || assigns[:loading],
        show_loading_text: assigns[:loading] && assigns[:loading_text] != nil,
        need_icon_margin:
          if(assigns[:inner_block] != [] || (assigns[:loading] && assigns[:loading_text] != nil),
            do: true,
            else: false
          )
      )

    ~H"""
    <button
      type={@type}
      class={
        Tails.classes([
          Theme.make_class_name("button", "root"),
          "flex-shrink-0 inline-flex justify-center items-center group font-medium outline-none",
          if(@variant != "light",
            do:
              Tails.classes([
                "rounded-tremor-default",
                "shadow-tremor-input",
                "dark:shadow-dark-tremor-input",
                Theme.get_border_style("sm", "all")
              ]),
            else: ""
          ),
          Map.get(@button_proportion_style, :padding_x),
          Map.get(@button_proportion_style, :padding_y),
          Map.get(@button_proportion_style, :font_size),
          Map.get(@button_color_style, :text_color),
          Map.get(@button_color_style, :bg_color),
          Map.get(@button_color_style, :border_color),
          Map.get(@button_color_style, :hover_border_color),
          if(is_nil(@is_disabled),
            do:
              Tails.classes([
                Map.get(@button_color_style, :hover_text_color),
                Map.get(@button_color_style, :hover_bg_color),
                Map.get(@button_color_style, :hover_border_color)
              ]),
            else: "opacity-50 cursor-not-allowed"
          ),
          if(is_nil(@class), do: "", else: @class)
        ])
      }
      disabled={@is_disabled}
      {@rest}
    >
      <.button_icon_spinner
        :if={@show_icon && @icon_position != "right"}
        loading={@loading}
        icon_size={@icon_size}
        icon_position={@icon_position}
        need_icon_margin={@need_icon_margin}
      >
        <%= render_slot(@icon) %>
      </.button_icon_spinner>

      <span
        :if={@show_loading_text == true}
        class={
          Tails.classes([
            Theme.make_class_name("button", "text"),
            "text-sm whitespace-nowrap"
          ])
        }
      >
        <%= @loading_text %>
      </span>

      <span
        :if={@inner_block != [] && @show_loading_text == false}
        class={
          Tails.classes([
            Theme.make_class_name("button", "text"),
            "text-sm whitespace-nowrap"
          ])
        }
      >
        <%= render_slot(@inner_block) %>
      </span>

      <.button_icon_spinner
        :if={@show_icon && @icon_position == "right"}
        loading={@loading}
        icon_size={@icon_size}
        icon_position={@icon_position}
        need_icon_margin={@need_icon_margin}
      >
        <%= render_slot(@icon) %>
      </.button_icon_spinner>
    </button>
    """
  end

  attr(:icon_position, :string, default: "left", values: ~w(left right))
  attr(:icon_size, :string, default: "sm", values: ~w(xs sm md lg xl))
  attr(:class, :string, default: nil)
  attr(:need_icon_margin, :boolean, default: nil)
  attr(:loading, :boolean, default: false)
  attr(:state, :string, default: "default")
  slot(:inner_block)

  @doc """
  Renders a button icon or spinner
  """
  def button_icon_spinner(%{loading: true} = assigns) do
    assigns =
      assign(assigns,
        margin: get_icon_margin(assigns[:need_icon_margin], assigns[:icon_position])
      )

    ~H"""
    <%!-- <.icon name="hero-magnifying-glass" /> --%>
    <.loading_spinner class={
      Tails.classes([
        Theme.make_class_name("button", "icon"),
        "animate-spin shrink-0",
        @margin,
        get_spinner_size("default", @icon_size),
        get_spinner_size("entered", @icon_size),
        "transition-[width] duration-150"
      ])
    } />
    """
  end

  def button_icon_spinner(assigns) do
    assigns =
      assign(assigns,
        margin: get_icon_margin(assigns[:need_icon_margin], assigns[:icon_position])
      )

    ~H"""
    <div class={
      Tails.classes([
        Theme.make_class_name("button", "icon"),
        "shrink-0",
        @margin,
        get_spinner_size("default", @icon_size),
        get_spinner_size("entered", @icon_size),
        "transition-[width] duration-150",
        "flex items-center justify-center"
      ])
    }>
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  @doc false
  defp get_spinner_size(size, icon_size) do
    %{
      default:
        Tails.classes([
          Theme.get_sizing_style("none", "width"),
          Theme.get_sizing_style("none", "height")
        ]),
      entering:
        Tails.classes([
          Theme.get_sizing_style("none", "width"),
          Theme.get_sizing_style("none", "height")
        ]),
      entered: icon_size,
      exiting: icon_size,
      exited:
        Tails.classes([
          Theme.get_sizing_style("none", "width"),
          Theme.get_sizing_style("none", "height")
        ])
    }
    |> Map.get(String.to_atom(size))
  end

  @doc false
  defp get_icon_margin(need_icon_margin, icon_position) do
    cond do
      need_icon_margin != true ->
        ""

      icon_position == "left" ->
        Tails.classes([
          Theme.get_spacing_style("two_xs", "negative_margin_left"),
          Theme.get_spacing_style("xs", "margin_right")
        ])

      true ->
        Tails.classes([
          Theme.get_spacing_style("two_xs", "negative_margin_right"),
          Theme.get_spacing_style("xs", "margin_left")
        ])
    end
  end

  @doc false
  defp get_button_colors(variant, color) do
    case variant do
      "primary" ->
        %{
          text_color:
            if(is_nil(color),
              do: "text-tremor-brand-inverted dark:text-dark-tremor-brand-inverted",
              else: Theme.get_color_style("white", "text")
            ),
          hover_text_color:
            if(is_nil(color),
              do: "text-tremor-brand-inverted dark:text-dark-tremor-brand-inverted",
              else: Theme.get_color_style("white", "text")
            ),
          bg_color:
            if(is_nil(color),
              do: "bg-tremor-brand dark:bg-dark-tremor-brand",
              else: Theme.get_color_style(color, "background", "bg")
            ),
          hover_bg_color:
            if(is_nil(color),
              do: "hover:bg-tremor-brand-emphasis dark:hover:bg-dark-tremor-brand-emphasis",
              else: Theme.get_color_style(color, "dark_background", "hover_bg")
            ),
          border_color:
            if(is_nil(color),
              do: "border-tremor-brand dark:border-dark-tremor-brand",
              else: Theme.get_color_style(color, "border", "border")
            ),
          hover_border_color:
            if(is_nil(color),
              do:
                "hover:border-tremor-brand-emphasis dark:hover:border-dark-tremor-brand-emphasis",
              else: Theme.get_color_style(color, "dark_border", "hover_border")
            )
        }

      "secondary" ->
        %{
          text_color:
            if(is_nil(color),
              do: "text-tremor-brand dark:text-dark-tremor-brand",
              else: Theme.get_color_style(color, "text", "text")
            ),
          hover_text_color:
            if(is_nil(color),
              do: "hover:text-tremor-brand-emphasis dark:hover:text-dark-tremor-brand-emphasis",
              else: Theme.get_color_style(color, "text", "text")
            ),
          bg_color: Theme.get_color_style("transparent", "bg"),
          hover_bg_color:
            if(is_nil(color),
              do: "hover:bg-tremor-brand-faint dark:hover:bg-dark-tremor-brand-faint",
              else:
                Tails.classes([
                  Theme.get_color_style(color, "background", "hover_bg"),
                  "hover:bg-opacity-20 dark:hover:bg-opacity-20"
                ])
            ),
          border_color:
            if(is_nil(color),
              do: "border-tremor-brand dark:border-dark-tremor-brand",
              else: Theme.get_color_style(color, "border", "border")
            ),
          hover_border_color: ""
        }

      _ ->
        %{
          text_color:
            if(is_nil(color),
              do: "text-tremor-brand dark:text-dark-tremor-brand",
              else: Theme.get_color_style(color, "text", "text")
            ),
          hover_text_color:
            if(is_nil(color),
              do: "hover:text-tremor-brand-emphasis dark:hover:text-dark-tremor-brand-emphasis",
              else: Theme.get_color_style(color, "dark_text", "hover_text")
            ),
          bg_color: Theme.get_color_style("transparent", "bg"),
          hover_bg_color: "",
          border_color: "",
          hover_border_color: ""
        }
    end
  end
end
