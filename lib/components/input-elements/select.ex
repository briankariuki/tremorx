defmodule Tremorx.Components.Select do
  @moduledoc """
  Renders select and select item
  """

  use Phoenix.Component
  alias Tremorx.Theme
  alias Tails
  alias Tremorx.Assets

  attr :class, :string, default: nil
  attr :placeholder, :string, default: "Select..."
  attr :on_change, JS, default: nil, doc: "Action triggered when item is selected"
  attr :value, :string, default: nil
  attr :default_value, :string, default: nil
  attr :disabled, :boolean, default: false
  attr :enable_clear, :boolean, default: true
  attr :rest, :global
  attr :id, :string, default: "select"
  slot :icon
  slot :item
  attr :name, :any, default: nil

  attr :enter, :string,
    doc: "CSS class to apply on enter transition",
    default: "transition ease duration-100 transform"

  attr :enter_from, :string,
    doc: "CSS class to apply on enter from",
    default: "opacity-0 -translate-y-4"

  attr :enter_to, :string,
    doc: "CSS class to apply on enter to",
    default: "opacity-100 translate-y-0"

  attr :leave, :string,
    doc: "CSS class to apply on leave transition",
    default: "transition ease duration-100 transform"

  attr :leave_from, :string,
    doc: "CSS class to apply on leave from",
    default: "opacity-100 translate-y-0"

  attr :leave_to, :string,
    doc: "CSS class to apply on leave to",
    default: "opacity-0 -translate-y-4"

  @doc """
  Allows users to pick one or more values from a range of predefined items.
  """
  def select(assigns) do
    assigns =
      assigns
      |> assign(has_selection: has_selection(assigns[:value]))

    ~H"""
    <div
      id={@id}
      class={
        Tails.classes([
          Theme.make_class_name("select", "root"),
          "w-full min-w-[10rem] relative text-tremor-default",
          if(is_nil(@class), do: "", else: @class)
        ])
      }
      data-open="false"
      phx-hook="Select"
      data-clear={@enable_clear}
      data-placeholder={@placeholder}
      data-enter={@enter}
      data-enter-from={@enter_from}
      data-enter-to={@enter_to}
      data-leave={@leave}
      data-leave-from={@leave_from}
      data-leave-to={@leave_to}
      data-default-value={@default_value || @value}
      {@rest}
    >
      <input name={@name} type="hidden" class="hidden" data-select-hidden="select" />

      <button
        type="button"
        class={
          Tails.classes([
            Theme.make_class_name("select", "button"),
            # common
            "w-full outline-none text-left whitespace-nowrap truncate rounded-tremor-default focus:ring-2 transition duration-100 border pr-8 py-2",
            # light
            "border-tremor-border shadow-tremor-input focus:border-tremor-brand-subtle focus:ring-tremor-brand-muted",
            # dark
            "dark:border-dark-tremor-border dark:shadow-dark-tremor-input dark:focus:border-dark-tremor-brand-subtle dark:focus:ring-dark-tremor-brand-muted",
            if(@icon != [], do: "pl-10", else: "pl-3"),
            get_select_button_colors(@has_selection, @disabled, nil)
          ])
        }
      >
        <span
          :if={@icon != []}
          class={
            Tails.classes([
              "absolute inset-y-0 left-0 flex items-center ml-px pl-2.5"
            ])
          }
        >
          <span class={
            Tails.classes([
              Theme.make_class_name("select", "icon"),
              # common
              "flex-none h-5 w-5",
              # light
              "text-tremor-content-subtle",
              # dark
              "dark:text-dark-tremor-content-subtle"
            ])
          }>
            <%= render_slot(@icon) %>
          </span>
        </span>
        <span class={
          Tails.classes(["w-[90%] block truncate", Theme.make_class_name("select", "content")])
        }>
          <%= @value || @placeholder %>
        </span>

        <span class={
          Tails.classes([
            "absolute inset-y-0 right-0 flex items-center mr-3"
          ])
        }>
          <Assets.arrow_down_head_icon class={
            Tails.classes([
              Theme.make_class_name("select", "arrowDownIcon"),
              # common
              "flex-none h-5 w-5",
              # light
              "text-tremor-content-subtle",
              # dark
              "dark:text-dark-tremor-content-subtle"
            ])
          } />
        </span>
      </button>

      <button
        :if={@enable_clear == true}
        type="button"
        class={
          Tails.classes([
            Theme.make_class_name("select", "clear"),
            "absolute inset-y-0 right-0  items-center mr-8 hidden"
          ])
        }
      >
        <Assets.x_circle_icon class={
          Tails.classes([
            Theme.make_class_name("select", "clearIcon"),
            # common
            "flex-none h-4 w-4",
            # light
            "text-tremor-content-subtle",
            # dark
            "dark:text-dark-tremor-content-subtle"
          ])
        } />
      </button>

      <ul
        class={
          Tails.classes([
            Theme.make_class_name("select", "items"),
            # common
            "z-[1000] w-full absolute hidden divide-y overflow-y-auto outline-none rounded-tremor-default max-h-[228px] left-0 border my-1",
            # light
            "bg-tremor-background border-tremor-border divide-tremor-border shadow-tremor-dropdown",
            # dark
            "dark:bg-dark-tremor-background dark:border-dark-tremor-border dark:divide-dark-tremor-border dark:shadow-dark-tremor-dropdown"
          ])
        }
        aria-role="item"
        aria-hidden="true"
      >
        <%= for item <- @item do %>
          <li
            class={
              Tails.classes([
                Theme.make_class_name("selectItem", "root"),
                Theme.make_class_name("select", "item"),
                # common
                "flex justify-start items-center cursor-default text-tremor-default px-2.5 py-2.5 focus:outline-none",
                # light
                "focus:bg-tremor-background-muted  focus:text-tremor-content-strong hover:text-tremor-content-strong hover:bg-tremor-background-muted text-tremor-content-emphasis",
                # dark
                "dark:focus:bg-dark-tremor-background-muted  dark:focus:text-dark-tremor-content-strong dark:hover:text-dark-tremor-content-strong dark:hover:bg-dark-tremor-background-muted dark:text-dark-tremor-content-emphasis"
              ])
            }
            tabindex="-1"
            aria-role="selectitem"
          >
            <%= render_slot(item) %>
          </li>
        <% end %>
      </ul>
    </div>
    """
  end

  defp get_select_button_colors(has_selection, disabled, has_error) do
    Tails.classes([
      if(disabled == true,
        do: "bg-tremor-background-subtle dark:bg-dark-tremor-background-subtle",
        else: "bg-tremor-background dark:bg-dark-tremor-background"
      ),
      if(disabled == false,
        do: "hover:bg-tremor-background-muted dark:hover:bg-dark-tremor-background-muted",
        else: ""
      ),
      if(has_selection == true,
        do: "text-tremor-content-emphasis dark:text-dark-tremor-content-emphasis",
        else: "text-tremor-content dark:text-dark-tremor-content"
      ),
      if(disabled == true,
        do: "text-tremor-content-subtle dark:text-dark-tremor-content-subtle",
        else: ""
      ),
      if(has_error == true,
        do: "text-red-500",
        else: ""
      ),
      if(has_error == true,
        do: "border-red-500",
        else: "border-tremor-border dark:border-dark-tremor-border"
      )
    ])
  end

  @doc false
  defp has_selection(value) do
    is_nil(value) == false && value != ""
  end
end
