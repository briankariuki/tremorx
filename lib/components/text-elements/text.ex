defmodule Tremorx.Components.Text do
  @moduledoc """
  Renders some text
  """

  alias Tails
  alias Tremorx.Theme

  use Phoenix.Component

  attr(:rest, :global)
  slot(:inner_block, required: false)
  attr(:class, :string, required: false, default: nil)
  attr(:color, :string, required: false, default: nil)

  @doc """
  Renders some text content
  """
  def text(assigns) do
    ~H"""
    <p
      class={
        "text-tremor-default " <>  Tails.classes([

          if(is_nil(@color),
            do: Tails.classes(["text-tremor-content", "dark:text-dark-tremor-content"]),
            else: Theme.get_color_style(@color, "text", "text")
          ),
          if(is_nil(@class), do: "", else: @class)
        ])
      }
      {@rest}
    >
      <%= render_slot(@inner_block) %>
    </p>
    """
  end

  attr(:rest, :global)
  slot(:inner_block, required: false)
  attr(:class, :string, required: false, default: nil)
  attr(:color, :string, required: false, default: nil)

  @doc """
  Renders some title content
  """
  def title(assigns) do
    ~H"""
    <p
      class={
        "text-tremor-title " <> Tails.classes([
          "font-medium",
          if(is_nil(@color),
            do:
              Tails.classes(["text-tremor-content-emphasis", "dark:text-dark-tremor-content-emphasis"]),
            else: Theme.get_color_style(@color, "dark_text", "text")
          ),
          if(is_nil(@class), do: "", else: @class)
        ])
      }
      {@rest}
    >
      <%= render_slot(@inner_block) %>
    </p>
    """
  end

  attr(:rest, :global)
  slot(:inner_block, required: false)
  attr(:class, :string, required: false, default: nil)
  attr(:color, :string, required: false, default: nil)

  @doc """
  Renders some subtitle content
  """
  def subtitle(assigns) do
    ~H"""
    <p
      class={
        Tails.classes([
          if(is_nil(@color),
            do: Tails.classes(["text-tremor-content-subtle", "dark:text-dark-tremor-content-subtle"]),
            else: Theme.get_color_style(@color, "light_text", "text")
          ),
          if(is_nil(@class), do: "", else: @class)
        ])
      }
      {@rest}
    >
      <%= render_slot(@inner_block) %>
    </p>
    """
  end

  attr(:rest, :global)
  slot(:inner_block, required: false)
  attr(:class, :string, required: false, default: nil)
  attr(:color, :string, required: false, default: nil)

  @doc """
  Renders some metric content
  """
  def metric(assigns) do
    ~H"""
    <p
      class={
        "text-tremor-metric " <> Tails.classes([
          "font-semibold",
        if(is_nil(@color),
          do: Tails.classes(["text-tremor-content-emphasis", "dark:text-dark-tremor-content-emphasis"]),
          else: Theme.get_color_style(@color, "dark_text", "text")
        ),
        if(is_nil(@class), do: "", else: @class)
      ])
    }
      {@rest}
    >
      <%= render_slot(@inner_block) %>
    </p>
    """
  end

  attr(:rest, :global)
  slot(:inner_block, required: false)
  attr(:class, :string, required: false, default: nil)

  @doc """
  Renders some text content in italics
  """
  def italic(assigns) do
    ~H"""
    <i
      class={
        Tails.classes([
          "italic text-inherit",
          if(is_nil(@class), do: "", else: @class)
        ])
      }
      {@rest}
    >
      <%= render_slot(@inner_block) %>
    </i>
    """
  end

  attr(:rest, :global)
  slot(:inner_block, required: false)
  attr(:class, :string, required: false, default: nil)

  @doc """
  Renders some text content in bold
  """
  def bold(assigns) do
    ~H"""
    <b
      class={
        Tails.classes([
          "text-inherit font-bold",
          if(is_nil(@class), do: "", else: @class)
        ])
      }
      {@rest}
    >
      <%= render_slot(@inner_block) %>
    </b>
    """
  end
end
