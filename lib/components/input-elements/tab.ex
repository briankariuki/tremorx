defmodule Tremorx.Components.Tab do
  @moduledoc """
  Tabs - Tab, TabGroup, TabList, TabPanels, TabPanel
  """

  alias Tremorx.Theme
  alias Tails

  use Phoenix.Component

  attr :id, :string, default: "tabs"
  attr :variant, :string, default: "line"
  attr :color, :string, default: nil
  attr :class, :string, default: nil

  attr :tab_list_class, :string,
    default: nil,
    doc: "CSS classes styles to apply to the tab list container"

  attr :tab_panel_class, :string,
    default: nil,
    doc: "CSS classes styles to apply to the tabpanel container"

  attr :tab_panels_class, :string,
    default: nil,
    doc: "CSS classes styles to apply to the tabpanels container"

  attr :tab_class, :string,
    default: nil,
    doc: "CSS classes styles to apply to the tab button"

  slot :tab, doc: "The tab button"
  slot :tab_content, doc: "The content after the tab buttons"
  slot :tabpanel, doc: "The tab content"
  attr :rest, :global

  def tabs(assigns) do
    ~H"""
    <div
      id={@id}
      phx-hook="Tab"
      class={
        Tails.classes([
          Theme.make_class_name("tabs", "root"),
          if(@class, do: @class, else: "")
        ])
      }
      {@rest}
    >
      <div class="flex items-center">
        <div
          id={"tablist-#{@id}"}
          phx-update="ignore"
          class={
            Tails.classes([
              Theme.make_class_name("TabList", "root"),
              "justify-start overflow-x-clip",
              get_tablist_styles(@variant),
              if(@tab_list_class, do: @tab_list_class, else: "")
            ])
          }
          role="tablist"
          aria-labelledby={"tablist-#{@id}"}
        >
          <button
            :for={{tab, index} <- Enum.with_index(@tab)}
            class={
              Tails.classes([
                Theme.make_class_name("tab", "root"),
                "flex whitespace-nowrap truncate max-w-xs outline-none focus:ring-0 text-tremor-default transition duration-100",
                if(@color,
                  do: Theme.get_color_style(@color, "text", "text"),
                  else:
                    if(@variant == "solid",
                      do:
                        "ui-selected:text-tremor-content-emphasis dark:ui-selected:text-dark-tremor-content-emphasis",
                      else: "ui-selected:text-tremor-brand dark:ui-selected:text-dark-tremor-brand"
                    )
                ),
                get_tab_styles(@variant, @color),
                if(@tab_class, do: @tab_class, else: "")
              ])
            }
            id={"tab-#{index}-#{@id}"}
            type="button"
            role="tab"
            aria-selected={if(index == 0, do: "true", else: "false")}
            aria-controls={"tabpanel-#{index}-#{@id}"}
            tabindex={if(index == 0, do: nil, else: "-1")}
            data-variant={@variant}
          >
            <%= render_slot(tab) %>
          </button>
        </div>

        <div class="flex-1">
          <%= render_slot(@tab_content) %>
        </div>
      </div>

      <div
        role="tabpanels"
        class={
          Tails.classes([
            Theme.make_class_name("TabPanels", "root"),
            "w-full",
            if(@tab_panels_class, do: @tab_panels_class, else: "")
          ])
        }
      >
        <div
          :for={{panel, index} <- Enum.with_index(@tabpanel)}
          phx-update="ignore"
          id={"tabpanel-#{index}-#{@id}"}
          role="tabpanel"
          tabindex="0"
          aria-labelledby={"tab-#{index}-#{@id}"}
          class={
            Tails.classes([
              Theme.make_class_name("TabPanel", "root"),
              "w-full mt-2",
              if(index == 0, do: "", else: "hidden"),
              if(@tab_panel_class, do: @tab_panel_class, else: "")
            ])
          }
        >
          <%= render_slot(panel) %>
        </div>
      </div>
    </div>
    """
  end

  @doc false
  defp get_tab_styles(variant, color) do
    case variant do
      "line" ->
        Tails.classes([
          "ui-selected:border-b-2 hover:border-b-2 border-transparent transition duration-100",
          "hover:border-tremor-content hover:text-tremor-content-emphasis text-tremor-content",
          "dark:hover:border-dark-tremor-content-emphasis dark:hover:text-dark-tremor-content-emphasis dark:text-dark-tremor-content",
          if(is_nil(color),
            do: "ui-selected:border-tremor-brand dark:ui-selected:border-dark-tremor-brand",
            else: Theme.get_color_style(color, "border", "border")
          ),
          Theme.get_spacing_style("px", "negative_margin_bottom"),
          Theme.get_spacing_style("sm", "padding_x"),
          Theme.get_spacing_style("sm", "padding_y")
        ])

      "solid" ->
        Tails.classes([
          "border-transparent border rounded-tremor-small",
          "ui-selected:border-tremor-border ui-selected:bg-tremor-background ui-selected:shadow-tremor-input hover:text-tremor-content-emphasis ui-selected:text-tremor-brand",
          "dark:ui-selected:border-dark-tremor-border dark:ui-selected:bg-dark-tremor-background dark:ui-selected:shadow-dark-tremor-input dark:hover:text-dark-tremor-content-emphasis dark:ui-selected:text-dark-tremor-brand",
          if(is_nil(color),
            do: "text-tremor-content dark:text-dark-tremor-content",
            else: Theme.get_color_style(color, "text", "text")
          ),
          Theme.get_spacing_style("md", "padding_x"),
          Theme.get_spacing_style("two_xs", "padding_y")
        ])
    end
  end

  @doc false
  defp get_tablist_styles(variant) do
    case variant do
      "line" ->
        Tails.classes([
          "flex",
          "border-tremor-border",
          "dark:border-dark-tremor-border",
          Theme.get_spacing_style("two_xl", "space_x"),
          Theme.get_border_style("sm", "bottom")
        ])

      "solid" ->
        Tails.classes([
          "inline-flex p-0.5 rounded-tremor-default",
          "bg-tremor-background-subtle",
          "dark:bg-dark-tremor-background-subtle",
          Theme.get_spacing_style("xs", "space_x")
        ])
    end
  end
end
