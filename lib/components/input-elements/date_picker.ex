defmodule Tremorx.Components.DatePicker do
  @moduledoc """
  DatePicker
  """
  use Phoenix.Component

  alias Tails
  alias Tremorx.Theme

  import Tremorx.Components.Menu
  import Tremorx.Components.Button
  # import TremorxWeb.CoreComponents

  attr :id, :string, required: true
  attr :date, :string, required: false, default: Date.utc_today() |> Date.to_string()
  attr :class, :string

  attr :on_changed, :string,
    default: nil,
    doc: "Event sent when date is changed. The event will include the changed date as a payload"

  attr :popover_class, :string, doc: "CSS class to customize the popover container"
  attr :cell_class, :string, doc: "CSS class to customize the date cells"
  attr :head_cell_class, :string, doc: "CSS class to customize the head day cells"
  attr :day_class, :string, doc: "CSS class to customize the day text"
  attr :nav_month_class, :string, doc: "CSS class to customize the navigation bar month text"
  attr :day_selected_class, :string, doc: "CSS class to customize the selected day"
  attr :day_indicator_class, :string, doc: "CSS class to customize the selected day indicator"
  attr :nav_button_class, :string, doc: "CSS class to customize the date navigation bar buttons"
  attr :nav_class, :string, doc: "CSS class to customize the navigation container"
  attr :trigger_btn_class, :string, doc: "CSS class to customize the trigger button"

  attr :placeholder, :string,
    doc: "Placeholder text for the trigger button",
    default: "Select date"

  attr :day_outside_class, :string,
    doc: "CSS class to customize the days outside the current month"

  attr :row_class, :string, doc: "CSS class to customize the row for the days"
  attr :rest, :global

  @doc """
  Renders a date picker
  """
  def date_picker(assigns) do
    day_class = [
      "size-9 rounded text-sm focus:z-10",
      "text-gray-900 dark:text-gray-50",
      "hover:bg-gray-200 hover:dark:bg-gray-700",
      "w-[2.25rem] h-[2.25rem]"
    ]

    assigns =
      assigns
      |> assign(
        cell_class:
          Tails.classes([
            Theme.make_class_name("datePicker", "cell"),
            "relative p-0 text-center focus-within:relative",
            "text-gray-900 dark:text-gray-50",
            if(is_nil(assigns[:cell_class]), do: "", else: assigns[:cell_class])
          ]),

        # relative size-9 rounded text-sm focus:z-10 hover:bg-gray-200
        # hover:dark:bg-gray-700 outline outline-offset-2 outline-0
        # focus-visible: outline-2 outline-blue-500
        # dark:outline-blue-500 text-gray-400 dark:text-gray-600
        day_class:
          Tails.classes(
            [
              Theme.make_class_name("datePicker", "day"),

              # focus style
              "outline outline-offset-2 outline-0",
              "focus-visible:outline-2 outline-blue-500",
              # "dark:outline-blue-500 text-gray-400 dark:text-gray-600",
              if(is_nil(assigns[:day_class]), do: "", else: assigns[:day_class])
            ] ++ day_class
          ),
        row_class:
          Tails.classes([
            Theme.make_class_name("datePicker", "row"),
            "w-full mt-0.5",
            if(is_nil(assigns[:row_class]), do: "", else: assigns[:row_class])
          ]),
        head_cell_class:
          Tails.classes([
            Theme.make_class_name("datePicker", "headCell"),
            "w-9 font-medium text-sm sm:text-xs text-center text-gray-400 dark:text-gray-600 pb-2",
            if(is_nil(assigns[:head_cell_class]), do: "", else: assigns[:head_cell_class])
          ]),
        day_selected_class:
          Tails.classes(
            day_class ++
              [
                Theme.make_class_name("datePicker", "selectedDay"),
                "rounded",
                "aria-selected:bg-blue-500 aria-selected:text-white",
                "dark:aria-selected:bg-blue-500 dark:aria-selected:text-white",
                "font-semibold",
                if(is_nil(assigns[:day_selected_class]),
                  do: "",
                  else: assigns[:day_selected_class]
                )
              ]
          ),
        day_outside_class:
          Tails.classes(
            day_class ++
              [
                Theme.make_class_name("datePicker", "outsideDay"),
                "text-gray-400 dark:text-gray-600",
                if(is_nil(assigns[:day_outside_class]), do: "", else: assigns[:day_outside_class])
              ]
          ),
        day_indicator_class:
          Tails.classes([
            Theme.make_class_name("datePicker", "indicator"),
            "absolute inset-x-1/2 bottom-1.5 h-0.5 w-4 -translate-x-1/2 rounded-[2px] bg-blue-500 dark:bg-blue-500",
            if(is_nil(assigns[:day_indicator_class]), do: "", else: assigns[:day_indicator_class])
          ]),
        nav_button_class:
          Tails.classes([
            Theme.make_class_name("datePicker", "navBtn"),
            "flex size-8 shrink-0 select-none items-center justify-center rounded border p-1 outline-none transition sm:size-[30px]",
            # text color
            "text-gray-600 hover:text-gray-800",
            "dark:text-gray-400 hover:dark:text-gray-200",
            # border color
            "border-gray-300 dark:border-gray-800",
            # background color
            "hover:bg-gray-50 active:bg-gray-100",
            "hover:dark:bg-gray-900 active:dark:bg-gray-800",
            #  disabled
            "disabled:pointer-events-none",
            "disabled:border-gray-200 disabled:dark:border-gray-800",
            "disabled:text-gray-400 disabled:dark:text-gray-600",
            if(is_nil(assigns[:nav_button_class]), do: "", else: assigns[:nav_button_class])
          ]),
        nav_class:
          Tails.classes([
            Theme.make_class_name("datePicker", "nav"),
            "gap-1 flex items-center rounded-full size-full justify-between p-4",
            if(is_nil(assigns[:nav_class]), do: "", else: assigns[:nav_class])
          ]),
        nav_month_class:
          Tails.classes([
            Theme.make_class_name("datePicker", "navMonth"),
            "hidden text-sm font-medium capitalize tabular-nums text-gray-900 dark:text-gray-50",
            if(is_nil(assigns[:nav_month_class]), do: "", else: assigns[:nav_month_class])
          ]),
        trigger_btn_class:
          Tails.classes([
            Theme.make_class_name("datePicker", "triggerBtn"),
            # base
            "peer flex w-full cursor-pointer appearance-none items-center gap-x-2 truncate rounded-md border px-3 py-2 shadow-sm outline-none transition-all sm:text-sm",
            # background color
            "bg-white dark:bg-gray-950",
            # border color
            "border-gray-300 dark:border-gray-800",
            # text color
            "text-gray-900 dark:text-gray-50",
            # placeholder color
            "placeholder-gray-400 dark:placeholder-gray-500",
            # hover
            "hover:bg-gray-50 hover:dark:bg-gray-950/50",
            # disabled
            "disabled:pointer-events-none",
            "disabled:bg-gray-100 disabled:text-gray-400",
            "disabled:dark:border-gray-800 disabled:dark:bg-gray-800 disabled:dark:text-gray-500",
            if(is_nil(assigns[:trigger_btn_class]), do: "", else: assigns[:trigger_btn_class])
          ])
      )

    ~H"""
    <div class="max-w-xs w-full">
      <.menu class="max-w-xs " menu_btn_class={@trigger_btn_class} menu_items_class="mt-2">
        <:button>
          <svg
            viewBox="0 0 24 24"
            xmlns="http://www.w3.org/2000/svg"
            width="24"
            height="24"
            fill="currentColor"
            class="size-5 shrink-0 text-gray-400 dark:text-gray-600"
          >
            <path d="M17 3H21C21.5523 3 22 3.44772 22 4V20C22 20.5523 21.5523 21 21 21H3C2.44772 21 2 20.5523 2 20V4C2 3.44772 2.44772 3 3 3H7V1H9V3H15V1H17V3ZM4 9V19H20V9H4ZM6 11H8V13H6V11ZM11 11H13V13H11V11ZM16 11H18V13H16V11Z">
            </path>
          </svg>

          <span className="flex-1 overflow-hidden text-ellipsis whitespace-nowrap text-left text-gray-900 dark:text-gray-50">
            <span id={"#{@id}_selected_date"} class="text-gray-400 dark:text-gray-600">
              <%= @placeholder %>
            </span>
          </span>
        </:button>
        <:item>
          <div
            class={
              Tails.classes([
                Theme.make_class_name("datePicker", "popover"),
                # base
                "relative z-50 w-full rounded-md border text-sm shadow-xl shadow-black/[2.5%]",
                # border color
                "border-gray-200 dark:border-gray-800",
                # background color
                "bg-white dark:bg-gray-950",
                "p-0"

                # if(is_nil(@popover_class), do: "", else: @popover_class)
              ])
            }
            {@rest}
          >
            <div class="hidden" id={"#{@id}_send_data"} phx-hook="SendData"></div>
            <div class="space-y-4 p-3 w-full">
              <date-picker
                id={@id}
                cell-class={@cell_class}
                day-class={@day_class}
                row-class={@row_class}
                head-cell-class={@head_cell_class}
                day-selected-class={@day_selected_class}
                day-outside-class={@day_outside_class}
                day-indicator-class={@day_indicator_class}
                id={@id}
                date={@date}
                placeholder={@placeholder}
                on-changed={@on_changed}
              >
                <div class="flex items-center justify-between">
                  <div class="flex items-center gap-1">
                    <button type="button" id={"#{@id}_prev_button"} class={"#{@nav_button_class}"}>
                      <span class="text-primary">
                        <svg
                          xmlns="http://www.w3.org/2000/svg"
                          fill="currentColor"
                          viewBox="0 0 24 24"
                          width="24"
                          height="24"
                        >
                          <path d="M10.8284 12.0007L15.7782 16.9504L14.364 18.3646L8 12.0007L14.364 5.63672L15.7782 7.05093L10.8284 12.0007Z">
                          </path>
                        </svg>
                      </span>
                    </button>
                  </div>

                  <div
                    role="presentation"
                    aria-live="polite"
                    id={"#{@id}_current_month"}
                    phx-update="ignore"
                    class={"#{@nav_month_class}"}
                  >
                  </div>

                  <div class="flex items-center gap-1">
                    <button type="button" id={"#{@id}_next_button"} class={"#{@nav_button_class}"}>
                      <span class="text-primary">
                        <svg
                          xmlns="http://www.w3.org/2000/svg"
                          fill="currentColor"
                          viewBox="0 0 24 24"
                          width="24"
                          height="24"
                        >
                          <path d="M13.1717 12.0007L8.22192 7.05093L9.63614 5.63672L16.0001 12.0007L9.63614 18.3646L8.22192 16.9504L13.1717 12.0007Z">
                          </path>
                        </svg>
                      </span>
                    </button>
                  </div>
                </div>

                <table class={
                  Tails.classes([
                    Theme.make_class_name("datePicker", "table"),
                    "w-full border-collapse mt-1"
                  ])
                }>
                  <thead id={"#{@id}_days"} phx-update="ignore" class="hidden gap-0 grid-cols-7">
                  </thead>
                  <tbody id={"#{@id}_elements"} phx-update="ignore" class="hidden"></tbody>
                </table>
              </date-picker>
            </div>

            <div class="flex items-center gap-x-2 border-t border-gray-200 p-3 dark:border-gray-800">
              <div class="flex-1">
                <.button variant="secondary" class="h-8 w-full" type="button">
                  Cancel
                </.button>
              </div>

              <div class="flex-1">
                <.button variant="primary" class="h-8 w-full" type="button">
                  Apply
                </.button>
              </div>
            </div>
          </div>
        </:item>
      </.menu>
    </div>
    """
  end
end
