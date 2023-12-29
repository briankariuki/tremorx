defmodule Tremorx.Components.Image do
  @moduledoc """
  Image
  """
  alias Tails
  use Phoenix.Component

  attr :src, :string, required: true
  attr :class, :string
  attr :alt, :string, default: "Image Description"
  attr :rest, :global

  @doc """
  Renders an image from url. Supports caching
  """
  def image(assigns) do
    ~H"""
    <img
      src={@src}
      class={
        Tails.classes([
          "object-fit",
          if(is_nil(@class) == true, do: "", else: @class)
        ])
      }
      alt={@alt}
      {@rest}
    />
    """
  end
end
