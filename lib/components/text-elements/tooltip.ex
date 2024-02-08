defmodule Tremorx.Components.Tooltip do
  @moduledoc """
  Uses tippy.js to show a tooltip
  """
  use Phoenix.Component

  attr :id, :string, default: "tooltip"

  attr :content, :any, default: "My tooltip", doc: "The content of the tippy."

  attr :placement, :string,
    values:
      ~w(top top-start top-end right right-start right-end bottom bottom-start bottom-end left left-start left-end),
    doc: "The tooltip placement in relation with the reference element",
    default: "top"

  attr :animation, :string,
    values:
      ~w(fade shift-away shift-away-subtle shift-away-extreme shift-toward shift-toward-subtle shift-toward-extreme scale scale-subtle scale-extreme perspective perspective-subtle perspective-extreme),
    doc: "The transition animation of the tooltip",
    default: "fade"

  attr :theme, :string,
    values: ~w(light light-border material translucent),
    doc: "The theme of the tooltip",
    default: "translucent"

  attr :arrow, :boolean,
    doc: "Whether to display the tooltip arrow",
    default: true

  attr :arrow_type, :string,
    values: ~w(sharp round),
    doc: "The arrow type displayed by the tooltip",
    default: "round"

  attr :size, :string,
    values: ~w(small regular large),
    doc: "The size of the tooltip",
    default: "regular"

  attr :touch, :boolean,
    doc: "Whether to allow touch events for the tooltip",
    default: true

  attr :rest, :global,
    doc: "Other attributes can be passed to tippy using data-tippy-* attributes"

  slot :inner_block

  @doc """
  Renders a tooltip around the child element
  """

  def tooltip(assigns) do
    ~H"""
    <div
      id={@id}
      data-placement={@placement}
      data-animation={@animation}
      data-theme={@theme}
      data-content={@content}
      data-size={@size}
      data-arrow={@arrow}
      data-arrow-type={@arrow_type}
      data-touch={@touch}
      phx-hook="Tooltip"
      {@rest}
    >
      <%= render_slot(@inner_block) %>
    </div>
    """
  end
end
