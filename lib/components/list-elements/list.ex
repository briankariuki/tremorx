defmodule Tremorx.Components.List do
  @moduledoc """
  Renders a list
  """

  alias Tails
  alias Tremorx.Theme

  use Phoenix.Component

  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block

  @doc """
  Vertical indexes to display data and text, such as rankings.
  """

  def list(assigns) do
    ~H"""
    <ul
      class={
        Tails.classes([
          Theme.make_class_name("list", "root"),
          # common
          "w-full divide-y",
          # light
          "divide-tremor-border text-tremor-content",
          # dark
          "dark:divide-dark-tremor-border dark:text-dark-tremor-content",
          if(is_nil(@class), do: "", else: @class)
        ])
      }
      {@rest}
    >
      <%= render_slot(@inner_block) %>
    </ul>
    """
  end

  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block

  @doc """
  Renders a list item
  """

  def list_item(assigns) do
    ~H"""
    <li
      class={
        Tails.classes([
          Theme.make_class_name("listItem", "root"),
          # common
          "w-full flex justify-between items-center text-tremor-default py-2",
          if(is_nil(@class), do: "", else: @class)
        ])
      }
      {@rest}
    >
      <%= render_slot(@inner_block) %>
    </li>
    """
  end
end
