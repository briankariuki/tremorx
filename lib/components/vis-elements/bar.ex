defmodule Tremorx.Components.Bar do
  @moduledoc """
  Renders ProgressBar, DeltaBar
  """

  use Phoenix.Component
  alias Tails
  alias Tremorx.Theme

  attr :value, :any, default: nil
  attr :label, :string, default: nil
  attr :show_animation, :boolean, default: false
  attr :class, :string, default: nil
  attr :color, :string, default: nil
  attr :rest, :global

  @doc """
  Renders a progress bar
  """
  def progress_bar(assigns) do
    ~H"""
    <div
      class={
        Tails.classes([
          Theme.make_class_name("progressbar", "root"),
          "flex items-center w-full",
          if(is_nil(@class), do: "", else: @class)
        ])
      }
      {@rest}
    >
      <div class={
        Tails.classes([
          Theme.make_class_name("progressbar", "progressBarWrapper"),
          "relative flex items-center w-full rounded-tremor-full bg-opacity-20",
          if(is_nil(@color),
            do: "bg-tremor-brand-muted/50 dark:bg-dark-tremor-brand-muted",
            else: Theme.get_color_style(@color, "background", "bg")
          ),
          Theme.get_sizing_style("xs", "height")
        ])
      }>
        <div
          class={
            Tails.classes([
              Theme.make_class_name("progressbar", "progressBar"),
              "flex-col h-full rounded-tremor-full",
              if(is_nil(@color),
                do: "bg-tremor-brand dark:bg-dark-tremor-brand",
                else: Theme.get_color_style(@color, "background", "bg")
              ),
              if(@show_animation, do: "transition-all duration-1000", else: "")
            ])
          }
          style={"width: #{@value}%"}
        >
        </div>

        <div
          :if={@label != nil}
          class={
            Tails.classes([
              Theme.make_class_name("progressbar", "progressBar"),
              "w-16 truncate text-right",
              "text-tremor-content-emphasis",
              "dark:text-dark-tremor-content-emphasis",
              Theme.get_spacing_style("sm", "margin_left")
            ])
          }
        >
          <p class={
            Tails.classes([
              Theme.make_class_name("progressbar", "label"),
              "shrink-0 whitespace-nowrap truncate text-tremor-default"
            ])
          }>
            <%= @label %>
          </p>
        </div>
      </div>
    </div>
    """
  end
end
