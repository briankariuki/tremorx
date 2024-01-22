defmodule Tremorx.Components.Table do
  @moduledoc """
  Renders a table
  """

  alias Tails
  alias Tremorx.Theme

  use Phoenix.Component

  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block

  def table(assigns) do
    ~H"""
    <div
      class={
        Tails.classes([
          Theme.make_class_name("table", "root"),
          "overflow-auto",
          if(is_nil(@class), do: "", else: @class)
        ])
      }
      {@rest}
    >
      <table class={
        Tails.classes([
          Theme.make_class_name("table", "table"),
          # common
          "w-full text-tremor-default",
          # light
          "text-tremor-content",
          # dark
          "dark:text-dark-tremor-content"
        ])
      }>
        <%= render_slot(@inner_block) %>
      </table>
    </div>
    """
  end

  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block

  @doc """
  Renders the table body
  """
  def table_body(assigns) do
    ~H"""
    <tbody
      class={
        Tails.classes([
          Theme.make_class_name("TableBody", "root"),
          # common
          "align-top divide-y",
          # light
          "divide-tremor-border",
          # dark
          "dark:divide-dark-tremor-border",
          if(is_nil(@class), do: "", else: @class)
        ])
      }
      {@rest}
    >
      <%= render_slot(@inner_block) %>
    </tbody>
    """
  end

  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block

  @doc """
  Renders the table cell
  """
  def table_cell(assigns) do
    ~H"""
    <td
      class={
        Tails.classes([
          Theme.make_class_name("TableCell", "root"),
          "align-middle whitespace-nowrap text-left p-4",
          if(is_nil(@class), do: "", else: @class)
        ])
      }
      {@rest}
    >
      <%= render_slot(@inner_block) %>
    </td>
    """
  end

  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block

  @doc """
  Renders the table foot
  """
  def table_foot(assigns) do
    ~H"""
    <tfoot
      class={
        Tails.classes([
          Theme.make_class_name("TableFoot", "root"),
          # common
          "text-left font-medium border-t-[1px] ",
          # light
          "text-tremor-content border-tremor-border",
          # dark
          "dark:text-dark-tremor-content dark:border-dark-tremor-border",
          if(is_nil(@class), do: "", else: @class)
        ])
      }
      {@rest}
    >
      <%= render_slot(@inner_block) %>
    </tfoot>
    """
  end

  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block

  @doc """
  Renders the table footer cell
  """
  def table_footer_cell(assigns) do
    ~H"""
    <th
      class={
        Tails.classes([
          Theme.make_class_name("TableFooterCell", "root"),
          # common
          "top-0 px-4 py-3.5",
          # light
          "text-tremor-content font-medium",
          # dark
          "dark:text-dark-tremor-content",
          if(is_nil(@class), do: "", else: @class)
        ])
      }
      {@rest}
    >
      <%= render_slot(@inner_block) %>
    </th>
    """
  end

  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block

  @doc """
  Renders the table head
  """
  def table_head(assigns) do
    ~H"""
    <thead
      class={
        Tails.classes([
          Theme.make_class_name("TableHead", "root"),
          # common
          "text-left",
          # light
          "text-tremor-content",
          # dark
          "dark:text-dark-tremor-content",
          if(is_nil(@class), do: "", else: @class)
        ])
      }
      {@rest}
    >
      <%= render_slot(@inner_block) %>
    </thead>
    """
  end

  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block

  @doc """
  Renders the table header cell
  """
  def table_header_cell(assigns) do
    ~H"""
    <th
      class={
        Tails.classes([
          Theme.make_class_name("TableHeaderCell", "root"),
          # common
          "whitespace-nowrap text-left font-semibold top-0 px-4 py-3.5",
          # light
          "text-tremor-content",
          # dark
          "dark:text-dark-tremor-content",
          if(is_nil(@class), do: "", else: @class)
        ])
      }
      {@rest}
    >
      <%= render_slot(@inner_block) %>
    </th>
    """
  end

  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block

  @doc """
  Renders the table row
  """
  def table_row(assigns) do
    ~H"""
    <tr
      class={
        Tails.classes([
          Theme.make_class_name("TableRow", "row"),
          if(is_nil(@class), do: "", else: @class)
        ])
      }
      {@rest}
    >
      <%= render_slot(@inner_block) %>
    </tr>
    """
  end
end
