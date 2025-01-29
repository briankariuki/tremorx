defmodule Tremorx.Components.Menu do
  @moduledoc """
  Renders a Dropdown Menu
  """

  alias Tails
  alias Tremorx.Theme
  use Phoenix.Component

  slot :button,
    required: false,
    doc: "The element that will be placed as a child of the menu button"

  attr :on_click, JS, default: nil, doc: "Action triggered when menu button is clicked"

  slot :item,
    required: false,
    doc: "A list of items that will be displayed in the menu items container"

  attr :class, :string,
    default: nil,
    doc: "CSS classes styles to apply to the menu parent container"

  attr :menu_btn_class, :string,
    default: nil,
    doc: "CSS classes styles to apply to the menu button"

  attr :menu_items_class, :string,
    default: nil,
    doc: "CSS classes styles to apply to the menu items container"

  attr :menu_item_class, :string,
    default: nil,
    doc:
      "CSS classes styles to apply to the menu item container. Use this to style active and hover states"

  attr :id, :string, default: "menu"
  attr :rest, :global

  attr :enter, :string,
    doc: "CSS class to apply on enter transition",
    default: "transition ease-out duration-200"

  attr :enter_from, :string,
    doc: "CSS class to apply on enter from",
    default: "transform opacity-0 scale-95 -translate-y-2"

  attr :enter_to, :string,
    doc: "CSS class to apply on enter to",
    default: "transform opacity-100 scale-100 translate-y-0"

  attr :leave, :string,
    doc: "CSS class to apply on leave transition",
    default: "transition ease-in duration-150"

  attr :leave_from, :string,
    doc: "CSS class to apply on leave from",
    default: "transform opacity-100 scale-100 translate-y-0"

  attr :leave_to, :string,
    doc: "CSS class to apply on leave to",
    default: "transform opacity-0 scale-95 -translate-y-2"

  @doc """
  Renders the dropdown menu
  """
  def menu(assigns) do
    ~H"""
    <div
      id={@id}
      class={
        Tails.classes([
          Theme.make_class_name("menu", "root"),
          "relative w-full",
          if(is_nil(@class), do: "", else: @class)
        ])
      }
      data-open="false"
      phx-hook="Menu"
      data-enter={@enter}
      data-enter-from={@enter_from}
      data-enter-to={@enter_to}
      data-leave={@leave}
      data-leave-from={@leave_from}
      data-leave-to={@leave_to}
      {@rest}
    >
      <button
        type="button"
        class={
          Tails.classes([
            Theme.make_class_name("menu", "button"),
            "relative",
            if(is_nil(@menu_btn_class), do: "", else: @menu_btn_class)
          ])
        }
        aria-haspopup="true"
        aria-expanded="false"
        phx-click={if(is_nil(@on_click) == true, do: "", else: @on_click)}
      >
        <%= render_slot(@button) %>
      </button>

      <ul
        class={
          Tails.classes([
            Theme.make_class_name("menu", "items"),
            "absolute z-[10000] w-full hidden",
            if(is_nil(@menu_items_class), do: "", else: @menu_items_class)
          ])
        }
        aria-role="menu"
        inert="true"
      >
        <%= for item <- @item do %>
          <li
            class={
              Tails.classes([
                Theme.make_class_name("menu", "item"),
                "cursor-pointer flex group w-full",
                if(is_nil(@menu_item_class), do: "", else: @menu_item_class)
              ])
            }
            tabindex="-1"
            aria-role="menuitem"
          >
            <%= render_slot(item) %>
          </li>
        <% end %>
      </ul>
    </div>
    """
  end
end
