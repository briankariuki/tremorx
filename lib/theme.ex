defmodule Tremorx.Theme do
  @moduledoc """
  Defines various Tremor theme configurations
  """

  @doc """
  Defines the color names from color and shade
  """
  def color_names(color, shade \\ nil)

  def color_names(color, shade)
      when color in ["white", "black", "transparent"] or is_nil(shade) do
    [
      bg_color: "bg-#{color}",
      hover_bg_color: "hover:bg-#{color}",
      select_bg_color: "ui-selected:bg-#{color}",
      text_color: "text-#{color}",
      select_text_color: "ui-selected:text-#{color}",
      hover_text_color: "hover:text-#{color}",
      border_color: "border-#{color}",
      select_border_color: "ui-selected:border-#{color}",
      hover_border_color: "hover:border-#{color}",
      ring_color: "ring-#{color}",
      stroke_color: "stroke-#{color}",
      fill_color: "fill-#{color}"
    ]
  end

  def color_names(color, shade) do
    [
      bg_color: "bg-#{color}-#{shade}",
      hover_bg_color: "hover:bg-#{color}-#{shade}",
      select_bg_color: "ui-selected:bg-#{color}-#{shade}",
      text_color: "text-#{color}-#{shade}",
      select_text_color: "ui-selected:text-#{color}-#{shade}",
      hover_text_color: "hover:text-#{color}-#{shade}",
      border_color: "border-#{color}-#{shade}",
      select_border_color: "ui-selected:border-#{color}-#{shade}",
      hover_border_color: "hover:border-#{color}-#{shade}",
      ring_color: "ring-#{color}-#{shade}",
      stroke_color: "stroke-#{color}-#{shade}",
      fill_color: "fill-#{color}-#{shade}"
    ]
  end

  @doc """
  Returns the color classes using the color, palette and type
  """
  def get_color_style(color, palette, type) do
    color_names(color, color_palette() |> Keyword.fetch!(String.to_atom(palette)))
    |> Keyword.fetch!(String.to_atom("#{type}_color"))
  end

  @doc """
  Creates a css class name from the component name and class
  """
  def make_class_name(component, class) do
    "tremor-#{component}-#{class}"
  end

  @doc """
  Returns the value from size and key
  """
  def get_sizing_style(size, key) do
    sizing()
    |> Map.get(String.to_atom(size))
    |> Map.get(String.to_atom(key))
  end

  @doc """
  Returns the value from spacing and key
  """
  def get_spacing_style(size, key) do
    spacing()
    |> Map.get(String.to_atom(size))
    |> Map.get(String.to_atom(key))
  end

  @doc """
  Returns the value from border and key
  """
  def get_border_style(size, key) do
    border()
    |> Map.get(String.to_atom(size))
    |> Map.get(String.to_atom(key))
  end

  @doc """
  defines the color palettes
  """
  def color_palette() do
    [
      canvas_background: 50,
      light_background: 100,
      background: 500,
      dark_background: 600,
      darkest_background: 800,
      light_border: 200,
      border: 500,
      dark_border: 700,
      light_ring: 200,
      ring: 300,
      light_text: 400,
      text: 500,
      dark_text: 700,
      darkest_text: 900,
      icon: 500
    ]
  end

  @doc """
  Defines colors for theme
  """
  def colors() do
    [
      "slate",
      "gray",
      "zinc",
      "neutral",
      "stone",
      "red",
      "orange",
      "amber",
      "yellow",
      "lime",
      "green",
      "emerald",
      "teal",
      "cyan",
      "sky",
      "blue",
      "indigo",
      "violet",
      "purple",
      "fuchsia",
      "pink",
      "rose"
    ]
  end

  @doc """
  Defines sizing for the theme
  """
  def sizing() do
    %{
      none: %{
        height: "h-0",
        width: "w-0"
      },
      three_xs: %{
        height: "h-0.5",
        width: "w-0.5"
      },
      two_xs: %{
        height: "h-1",
        width: "w-1"
      },
      xs: %{
        height: "h-2",
        width: "w-2"
      },
      sm: %{
        height: "h-3",
        width: "w-3"
      },
      md: %{
        height: "h-4",
        width: "w-4"
      },
      lg: %{
        height: "h-5",
        width: "w-5"
      },
      xl: %{
        height: "h-6",
        width: "w-6"
      },
      two_xl: %{
        height: "h-7",
        width: "w-7"
      },
      three_xl: %{
        height: "h-9",
        width: "w-9"
      }
    }
  end

  @doc """
  Defines spacing for the theme
  """
  def spacing() do
    %{
      none: %{
        padding_left: "pl-0",
        padding_top: "pt-0",
        padding_right: "pr-0",
        padding_bottom: "pb-0",
        padding_x: "px-0",
        padding_y: "py-0",
        padding_all: "p-0",
        margin_left: "ml-0",
        margin_top: "mt-0",
        margin_right: "mr-0",
        margin_bottom: "mb-0",
        negative_margin_left: "-ml-0",
        negative_margin_right: "-mr-0",
        negative_margin_top: "-mt-0",
        negative_margin_bottom: "-mb-0",
        left: "left-0",
        right: "right-0",
        top: "top-0",
        bottom: "bottom-0",
        space_x: "space-x-0"
      },
      px: %{
        padding_left: "pl-px",
        padding_top: "pt-px",
        padding_right: "pr-px",
        padding_bottom: "pb-px",
        padding_x: "px-px",
        padding_y: "py-px",
        padding_all: "p-px",
        margin_left: "ml-px",
        margin_top: "mt-px",
        margin_right: "mr-px",
        margin_bottom: "mb-px",
        negative_margin_left: "-ml-px",
        negative_margin_right: "-mr-px",
        negative_margin_top: "-mt-px",
        negative_margin_bottom: "-mb-px",
        left: "left-px",
        right: "right-px",
        top: "top-px",
        bottom: "bottom-px",
        space_x: "space-x-px"
      },
      three_xs: %{
        padding_left: "pl-0.5",
        padding_top: "pt-0.5",
        padding_right: "pr-0.5",
        padding_bottom: "pb-0.5",
        padding_x: "px-0.5",
        padding_y: "py-0.5",
        padding_all: "p-0.5",
        margin_left: "ml-0.5",
        margin_top: "mt-0.5",
        margin_right: "mr-0.5",
        margin_bottom: "mb-0.5",
        negative_margin_left: "-ml-0.5",
        negative_margin_right: "-mr-0.5",
        negative_margin_top: "-mt-0.5",
        negative_margin_bottom: "-mb-0.5",
        left: "left-0.5",
        right: "right-0.5",
        top: "top-0.5",
        bottom: "bottom-0.5",
        space_x: "space-x-0.5"
      },
      two_xs: %{
        padding_left: "pl-1",
        padding_top: "pt-1",
        padding_right: "pr-1",
        padding_bottom: "pb-1",
        padding_x: "px-1",
        padding_y: "py-1",
        padding_all: "p-1",
        margin_left: "ml-1",
        margin_top: "mt-1",
        margin_right: "mr-1",
        margin_bottom: "mb-1",
        negative_margin_left: "-ml-1",
        negative_margin_right: "-mr-1",
        left: "left-1",
        right: "right-1",
        top: "top-1",
        bottom: "bottom-1",
        space_x: "space-x-1"
      },
      xs: %{
        padding_left: "pl-1.5",
        padding_top: "pt-1.5",
        padding_right: "pr-1.5",
        padding_bottom: "pb-1.5",
        padding_x: "px-1.5",
        padding_y: "py-1.5",
        padding_all: "p-1.5",
        margin_left: "ml-1.5",
        margin_top: "mt-1.5",
        margin_right: "mr-1.5",
        margin_bottom: "mb-1.5",
        negative_margin_left: "-ml-1.5",
        negative_margin_right: "-mr-1.5",
        negative_margin_top: "-mt-1.5",
        negative_margin_bottom: "-mb-1.5",
        left: "left-1.5",
        right: "right-1.5",
        top: "top-1.5",
        bottom: "bottom-1.5",
        space_x: "space-x-1.5"
      },
      sm: %{
        padding_left: "pl-2",
        padding_top: "pt-2",
        padding_right: "pr-2",
        padding_bottom: "pb-2",
        padding_x: "px-2",
        padding_y: "py-2",
        padding_all: "p-2",
        margin_left: "ml-2",
        margin_top: "mt-2",
        margin_right: "mr-2",
        margin_bottom: "mb-2",
        negative_margin_left: "-ml-2",
        negative_margin_right: "-mr-2",
        negative_margin_top: "-mt-2",
        negative_margin_bottom: "-mb-2",
        left: "left-2",
        right: "right-2",
        top: "left-2",
        bottom: "bottom-2",
        space_x: "space-x-2"
      },
      md: %{
        padding_left: "pl-2.5",
        padding_top: "pt-2.5",
        padding_right: "pr-2.5",
        padding_bottom: "pb-2.5",
        padding_x: "px-2.5",
        padding_y: "py-2.5",
        padding_all: "p-2.5",
        margin_left: "ml-2.5",
        margin_top: "mt-2.5",
        margin_right: "mr-2.5",
        margin_bottom: "mb-2.5",
        negative_margin_left: "-ml-2.5",
        negative_margin_right: "-mr-2.5",
        negative_margin_top: "-mt-2.5",
        negative_margin_bottom: "-mb-2.5",
        left: "left-2.5",
        right: "right-2.5",
        top: "top-2.5",
        bottom: "bottom-2.5",
        space_x: "space-x-2.5"
      },
      lg: %{
        padding_left: "pl-3",
        padding_top: "pt-3",
        padding_right: "pr-3",
        padding_bottom: "pb-3",
        padding_x: "px-3",
        padding_y: "py-3",
        padding_all: "p-3",
        margin_left: "ml-3",
        margin_top: "mt-3",
        margin_right: "mr-3",
        margin_bottom: "mb-3",
        negative_margin_left: "-ml-3",
        negative_margin_right: "-mr-3",
        negative_margin_top: "-mt-3",
        negative_margin_bottom: "-mb-3",
        left: "left-3",
        right: "right-3",
        top: "top-3",
        bottom: "bottom-3",
        space_x: "space-x-3"
      },
      xl: %{
        padding_left: "pl-3.5",
        padding_top: "pt-3.5",
        padding_right: "pr-3.5",
        padding_bottom: "pb-3.5",
        padding_x: "px-3.5",
        padding_y: "py-3.5",
        padding_all: "p-3.5",
        margin_left: "ml-3.5",
        margin_top: "mt-3.5",
        margin_right: "mr-3.5",
        margin_bottom: "mb-3.5",
        negative_margin_left: "-ml-3.5",
        negative_margin_right: "-mr-3.5",
        negative_margin_top: "-mt-3.5",
        negative_margin_bottom: "-mb-3.5",
        left: "left-3.5",
        right: "right-3.5",
        top: "top-3.5",
        bottom: "bottom-3.5",
        space_x: "space-x-3.5"
      },
      two_xl: %{
        padding_left: "pl-4",
        padding_top: "pt-4",
        padding_right: "pr-4",
        padding_bottom: "pb-4",
        padding_x: "px-4",
        padding_y: "py-4",
        padding_all: "p-4",
        margin_left: "ml-4",
        margin_top: "mt-4",
        margin_right: "mr-4",
        margin_bottom: "mb-4",
        negative_margin_left: "-ml-4",
        negative_margin_right: "-mr-4",
        negative_margin_top: "-mt-4",
        negative_margin_bottom: "-mb-4",
        left: "left-4",
        right: "right-4",
        top: "top-4",
        bottom: "bottom-4",
        space_x: "space-x-4"
      },
      three_xl: %{
        padding_left: "pl-6",
        padding_top: "pt-6",
        padding_right: "pr-6",
        padding_bottom: "pb-6",
        padding_x: "px-6",
        padding_y: "py-6",
        padding_all: "p-6",
        margin_left: "ml-6",
        margin_top: "mt-6",
        margin_right: "mr-6",
        margin_bottom: "mb-6",
        negative_margin_left: "-ml-6",
        negative_margin_right: "-mr-6",
        negative_margin_top: "-mt-6",
        negative_margin_bottom: "-mb-6",
        left: "left-6",
        right: "right-6",
        top: "top-6",
        bottom: "bottom-6",
        space_x: "space-x-6"
      },
      four_xl: %{
        padding_left: "pl-8",
        padding_top: "pt-8",
        padding_right: "pr-8",
        padding_bottom: "pb-8",
        padding_x: "px-8",
        padding_y: "py-8",
        padding_all: "p-8",
        margin_left: "ml-8",
        margin_top: "mt-8",
        margin_right: "mr-8",
        margin_bottom: "mb-8",
        negative_margin_left: "-ml-8",
        negative_margin_right: "-mr-8",
        negative_margin_top: "-mt-8",
        negative_margin_bottom: "-mb-8",
        left: "left-8",
        right: "right-8",
        top: "top-8",
        bottom: "bottom-8",
        space_x: "space-x-8"
      }
    }
  end

  @doc """
  Defines border radius for the theme
  """
  def border_radius() do
    %{
      none: %{
        left: "rounded-l-none",
        top: "rounded-t-none",
        right: "rounded-r-none",
        bottom: "rounded-b-none",
        all: "rounded-none"
      },
      sm: %{
        left: "rounded-l",
        top: "rounded-t",
        right: "rounded-r",
        bottom: "rounded-b",
        all: "rounded"
      },
      md: %{
        left: "rounded-l-md",
        top: "rounded-t-md",
        right: "rounded-r-md",
        bottom: "rounded-b-md",
        all: "rounded-md"
      },
      lg: %{
        left: "rounded-l-lg",
        top: "rounded-t-lg",
        right: "rounded-r-lg",
        bottom: "rounded-b-lg",
        all: "rounded-lg"
      },
      full: %{
        left: "rounded-l-full",
        top: "rounded-t-full",
        right: "rounded-r-full",
        bottom: "rounded-b-full",
        all: "rounded-full"
      }
    }
  end

  @doc """
  Defines box shadow for the theme
  """
  def box_shadow() do
    %{
      none: "shadow-none",
      sm: "shadow-sm",
      md: "shadow",
      lg: "shadow-lg"
    }
  end

  @doc """
  Defines border for the theme
  """
  def border() do
    %{
      none: %{
        left: "border-l-0",
        top: "border-t-0",
        right: "border-r-0",
        bottom: "border-b-0",
        all: "border-0"
      },
      sm: %{
        left: "border-l",
        top: "border-t",
        right: "border-r",
        bottom: "border-b",
        all: "border"
      },
      md: %{
        left: "border-l-2",
        top: "border-t-2",
        right: "border-r-2",
        bottom: "border-b-2",
        all: "border-2"
      },
      lg: %{
        left: "border-l-4",
        top: "border-t-4",
        right: "border-r-4",
        bottom: "border-b-4",
        all: "border-4"
      }
    }
  end

  @doc """
  Defines font_size for the theme
  """
  def font_size() do
    %{
      xs: "text-xs",
      sm: "text-sm",
      md: "text-base",
      lg: "text-lg",
      xl: "text-xl",
      three_xl: "text-3xl"
    }
  end

  @doc """
  Defines font_weight for the theme
  """
  def font_weight() do
    %{
      sm: "font-normal",
      md: "font-medium",
      lg: "font-semibold"
    }
  end
end
