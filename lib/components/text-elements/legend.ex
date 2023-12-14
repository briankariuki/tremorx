defmodule Tremorx.Components.Legend do
  @moduledoc """
  Renders a Legend menu
  """

  alias Tails
  alias Tremorx.Theme

  use Phoenix.Component
  alias Phoenix.LiveView.JS

  @doc """
  Renders a legend
  """

  attr(:class, :string, required: false, default: nil)
  attr(:active, :string, required: false, default: nil)
  attr(:enable_slider, :boolean, required: false, default: nil)
  attr(:rest, :global)

  slot :legend_item, required: true do
    attr(:name, :string, required: true)
    attr(:color, :string, required: true)
    attr(:class, :string, required: false)
    attr(:on_click, JS, required: false)
  end

  slot(:scroll_left_icon, required: false)
  slot(:scroll_right_icon, required: false)

  def legend(assigns) do
    assigns =
      assigns
      |> assign_new(:legend_id, fn ->
        "legend_#{to_string(System.unique_integer([:positive]))}"
      end)

    ~H"""
    <ol
      id={@legend_id}
      data-enable-slider={to_string(@enable_slider)}
      phx-mounted={JS.dispatch("legend_mounted", detail: %{id: @legend_id})}
      class={
        Tails.classes([
          Theme.make_class_name("legend", "root"),
          "relative overflow-hidden",
          if(is_nil(@class), do: "", else: @class)
        ])
      }
      {@rest}
    >
      <div
        tabIndex="0"
        class={
          Tails.classes([
            "h-full flex",
            if(to_string(@enable_slider) == "true", do: "", else: "flex-wrap")
          ])
        }
      >
        <.legend_item
          :for={item <- @legend_item}
          name={item[:name]}
          color={item[:color]}
          active={@active}
          on_click={item[:on_click]}
        />
      </div>

      <div
        :if={to_string(@enable_slider) == "true"}
        class={
          Tails.classes([
            "absolute top-0 bottom-0 left-0 w-4 bg-gradient-to-r from-white to-transparent pointer-events-none"
          ])
        }
      >
      </div>

      <div
        :if={to_string(@enable_slider) == "true"}
        class={
          Tails.classes([
            "absolute top-0 bottom-0 right-10 w-4 bg-gradient-to-r from-transparent to-white pointer-events-none"
          ])
        }
      >
      </div>

      <div
        :if={to_string(@enable_slider) == "true"}
        class={
          Tails.classes([
            "absolute flex top-0 pr-1 bottom-0 right-0 items-center justify-center h-full bg-tremor-background"
          ])
        }
      >
        <.scroll_button
          id={"left_btn_#{@legend_id}"}
          disable="false"
          on_click={JS.dispatch("scroll_legend", detail: %{id: @legend_id, direction: "left"})}
        >
          <%= render_slot(@scroll_left_icon) %>
        </.scroll_button>
        <.scroll_button
          id={"right_btn_#{@legend_id}"}
          disable="false"
          on_click={JS.dispatch("scroll_legend", detail: %{id: @legend_id, direction: "right"})}
        >
          <%= render_slot(@scroll_right_icon) %>
        </.scroll_button>
      </div>
    </ol>

    <script>
      function checkScroll(element){
        if(!element.firstElementChild) return;
        const scrollable = element.firstElementChild
        const hasLeftScroll = scrollable.scrollLeft > 0;
        const hasRightScroll = scrollable.scrollWidth - scrollable.clientWidth > scrollable.scrollLeft;

        scrollable.setAttribute("data-has-left-scroll", hasLeftScroll)
        scrollable.setAttribute("data-has-right-scroll", hasRightScroll)

        if(hasLeftScroll || hasRightScroll) {
          scrollable.classList.add(
            "pl-4", "pr-12",
            "items-center", "overflow-auto",
            "snap-mandatory", "[&::-webkit-scrollbar]:hidden", "[scrollbar-width:none]"
          )
        } else {
          scrollable.classList.remove(
            "pl-4", "pr-12",
            "items-center", "overflow-auto",
            "snap-mandatory", "[&::-webkit-scrollbar]:hidden", "[scrollbar-width:none]"
          )
        }

        const legendId = element.getAttribute("id")
        const scrollLeftBtn = document.getElementById(`left_btn_${legendId}`)
        const scrollRightBtn = document.getElementById(`right_btn_${legendId}`)

        if(scrollLeftBtn) {
          scrollLeftBtn.disabled = !hasLeftScroll
          scrollLeftBtn.setAttribute("disable", !hasLeftScroll)

          if(!hasLeftScroll) {
            scrollLeftBtn.classList.remove(
              "cursor-pointer",
              "text-tremor-content",
              "hover:text-tremor-content-emphasis",
              "hover:bg-tremor-background-subtle",
              "dark:text-dark-tremor",
              "dark:hover:text-tremor-content-emphasis",
              "dark:hover:bg-dark-tremor-background-subtle");
            scrollLeftBtn.classList.add(
              "cursor-not-allowed",
              "text-tremor-content-subtle",
              "dark:text-dark-tremor-subtle");
          } else {
            scrollLeftBtn.classList.remove(
              "cursor-not-allowed",
              "text-tremor-content-subtle",
              "dark:text-dark-tremor-subtle");
            scrollLeftBtn.classList.add(
              "cursor-pointer",
              "text-tremor-content",
              "hover:text-tremor-content-emphasis",
              "hover:bg-tremor-background-subtle",
              "dark:text-dark-tremor",
              "dark:hover:text-tremor-content-emphasis",
              "dark:hover:bg-dark-tremor-background-subtle");
          }
        }

        if(scrollRightBtn) {
          scrollRightBtn.disabled = !hasRightScroll
          scrollRightBtn.setAttribute("disable", !hasRightScroll)

          if(!hasRightScroll) {
            scrollRightBtn.classList.remove(
              "cursor-pointer",
              "text-tremor-content",
              "hover:text-tremor-content-emphasis",
              "hover:bg-tremor-background-subtle",
              "dark:text-dark-tremor",
              "dark:hover:text-tremor-content-emphasis",
              "dark:hover:bg-dark-tremor-background-subtle");
            scrollRightBtn.classList.add(
              "cursor-not-allowed",
              "text-tremor-content-subtle",
              "dark:text-dark-tremor-subtle");
          } else {
            scrollRightBtn.classList.remove(
              "cursor-not-allowed",
              "text-tremor-content-subtle",
              "dark:text-dark-tremor-subtle");
            scrollRightBtn.classList.add(
              "cursor-pointer",
              "text-tremor-content",
              "hover:text-tremor-content-emphasis",
              "hover:bg-tremor-background-subtle",
              "dark:text-dark-tremor",
              "dark:hover:text-tremor-content-emphasis",
              "dark:hover:bg-dark-tremor-background-subtle");
          }
        }
      }

      function scrollToTest(legendId, direction) {
        const legend = document.getElementById(legendId)
        const scrollable = legend.firstElementChild
        const width = scrollable?.clientWidth ?? 0;
        const enableSlider = legend?.dataset["enableSlider"]

        if(scrollable && enableSlider) {
          scrollable.scrollTo({
            left: direction === "left" ? scrollable.scrollLeft - width : scrollable.scrollLeft + width,
            behavior: "smooth",
          });

          setTimeout(() => {
            checkScroll(legend);
          }, 400);
        }
      }

      document.addEventListener("legend_mounted",  (e) => {
        const legendId = e.detail.id
        const legend = e.target
        const enableSlider = legend.dataset["enableSlider"]
        if(enableSlider) {
          checkScroll(legend)
        }
      })

      document.addEventListener("scroll_legend",  (e) => {
        const legendId = e.detail.id
        const direction = e.detail.direction
        scrollToTest(legendId, direction)
      })
    </script>
    """
  end

  @doc """
  Renders a legend item
  """

  attr(:name, :string, required: true)
  attr(:color, :string, required: true)
  attr(:class, :string, required: false, default: nil)
  attr(:active, :string, required: false, default: nil)
  attr(:on_click, JS, required: false, default: nil)

  def legend_item(assigns) do
    ~H"""
    <li
      phx-click={if(is_nil(@on_click) == false, do: @on_click, else: nil)}
      phx-value-color={@color}
      phx-value-name={@name}
      class={
        Tails.classes([
          Theme.make_class_name("legend", "legend-item"),
          "group inline-flex items-center px-2 py-0.5 rounded-tremor-small transition whitespace-nowrap",
          if(is_nil(@on_click) == false, do: "cursor-pointer", else: "cursor-default"),
          "text-tremor-content",
          if(is_nil(@on_click) == false,
            do: "hover:bg-tremor-background-subtle",
            else: ""
          ),
          "dark:text-dark-tremor-content",
          if(is_nil(@on_click) == false,
            do: "dark:hover:bg-dark-tremor-background-subtle",
            else: ""
          ),
          if(is_nil(@class), do: "", else: @class)
        ])
      }
    >
      <svg
        class={
          Tails.classes([
            "flex-none",
            Theme.get_color_style(@color, "text", "text"),
            Theme.get_sizing_style("xs", "height"),
            Theme.get_sizing_style("xs", "width"),
            Theme.get_spacing_style("xs", "margin_right"),
            if(is_nil(@active) == false and @active !== @name, do: "opacity-40", else: "opacity-100")
          ])
        }
        fill="currentColor"
        viewBox="0 0 8 8"
      >
        <circle cx={4} cy={4} r={4} />
      </svg>

      <p class={
        Tails.classes([
          "whitespace-nowrap truncate text-tremor-default",
          "text-tremor-content",
          if(is_nil(@on_click) == false,
            do: "group-hover:text-tremor-content-emphasis",
            else: ""
          ),
          "dark:text-dark-tremor-content",
          if(is_nil(@active) == false and @active !== @name, do: "opacity-40", else: "opacity-100"),
          if(is_nil(@on_click) == false,
            do: "dark:group-hover:text-dark-tremor-content-emphasis",
            else: ""
          )
        ])
      }>
        <%= @name %>
      </p>
    </li>
    """
  end

  @doc """
  Renders a legend scroll button
  """

  attr(:id, :string, required: true)
  attr(:disable, :string, required: false)
  slot(:inner_block, required: false)
  attr(:on_click, JS, required: false, default: nil)

  def scroll_button(assigns) do
    ~H"""
    <button
      id={@id}
      phx-click={if(is_nil(@on_click) == false, do: @on_click, else: nil)}
      type="button"
      phx-throttle="300"
      class={
        Tails.classes([
          Theme.make_class_name("legend", "legend-slider-button"),
          "w-5 group inline-flex items-center truncate rounded-tremor-small transition",
          if(@disable == "true", do: "cursor-not-allowed", else: "cursor-pointer"),
          if(@disable == "true",
            do: "text-tremor-content-subtle",
            else:
              "text-tremor-content hover:text-tremor-content-emphasis hover:bg-tremor-background-subtle"
          ),
          if(@disable == "true",
            do: "dark:text-dark-tremor-subtle",
            else:
              "dark:text-dark-tremor dark:hover:text-tremor-content-emphasis dark:hover:bg-dark-tremor-background-subtle"
          )
        ])
      }
      disable={@disable}
    >
      <%!-- <.icon name="hero-chevron-left" /> --%>
      <%!-- <.icon name="hero-chevron-right" /> --%>

      <%= render_slot(@inner_block) %>
    </button>
    """
  end
end
