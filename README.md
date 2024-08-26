# Tremorx

An Elixir Phoenix component library inspired by [Tremor](https://www.tremor.so/) - The react library to build dashboards fast.

**This project is still in development.**

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `tremorx` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    #{:tremorx, "~> 0.1.0"}
    {:tremorx, git: "https://github.com/briankariuki/tremorx.git"}
  ]
end
```
Add tremorx to the dependecies section in `*_web/assets/package.json` like this:
```
{
  "dependencies": {
    //Add this line
    "tremorx": "file:../deps/tremorx"
    // If in umbrella project
    "tremorx": "file:../../../deps/tremorx"
  } 
}
```
Then import the tremorx hooks in your `assets/js/app.js` file like this:
```
// Import the hooks
import { TremorHooks } from "tremorx";

// Add the hooks to the LiveSocket hooks option
let liveSocket = new LiveSocket("/live", Socket, {
  hooks: {...MyHooks, ...TremorxHooks},
});
```

Configure your `tailwind.config.js` file with the follwing:

Allow tailwind to find css classes defined in this library by adding the following lines to the `content` section in `tailwind.config.js`
```
content: [
  //Add these two lines. The deps path may be different for umbrella projects
  "../deps/tremorx/lib/components/**/*.ex",
  "../deps/tremorx/lib/js/*.js",
]
```

Configure the tremorx theme tokens by adding these theme extensions in `theme` section in `tailwind.config.js`. You can read more about theming [Here](https://www.tremor.so/docs/getting-started/theming)

```
theme: {
  //Extend your theme with tremor's default config
  extend: {
    colors: {
      tremor: {
        brand: {
          faint: "#eff6ff",
          muted: "#bfdbfe",
          subtle: "#60a5fa",
          DEFAULT: "#3b82f6",
          emphasis: "#1d4ed8",
          inverted: "#ffffff",
        },
        background: {
          muted: "#f9fafb",
          subtle: "#f3f4f6",
          DEFAULT: "#ffffff",
          emphasis: "#374151",
        },
        border: {
          DEFAULT: "#e5e7eb",
        },
        ring: {
          DEFAULT: "#e5e7eb",
        },
        content: {
          subtle: "#9ca3af",
          DEFAULT: "#6b7280",
          emphasis: "#374151",
          strong: "#111827",
          inverted: "#ffffff",
        },
      },

      "dark-tremor": {
        brand: {
          faint: "#0B1229",
          muted: "#172554",
          subtle: "#1e40af",
          DEFAULT: "#3b82f6",
          emphasis: "#60a5fa",
          inverted: "#030712",
        },
        background: {
          muted: "#131A2B",
          subtle: "#1f2937",
          DEFAULT: "#111827",
          emphasis: "#d1d5db",
        },
        border: {
          DEFAULT: "#374151",
        },
        ring: {
          DEFAULT: "#1f2937",
        },
        content: {
          subtle: "#4b5563",
          DEFAULT: "#6b7280",
          emphasis: "#e5e7eb",
          strong: "#f9fafb",
          inverted: "#000000",
        },
      },
    },
    boxShadow: {
      // light
      "tremor-input": "0 1px 2px 0 rgb(0 0 0 / 0.05)",
      "tremor-card":
        "0 1px 3px 0 rgb(0 0 0 / 0.1), 0 1px 2px -1px rgb(0 0 0 / 0.1)",
      "tremor-dropdown":
        "0 4px 6px -1px rgb(0 0 0 / 0.1), 0 2px 4px -2px rgb(0 0 0 / 0.1)",
      // dark
      "dark-tremor-input": "0 1px 2px 0 rgb(0 0 0 / 0.05)",
      "dark-tremor-card":
        "0 1px 3px 0 rgb(0 0 0 / 0.1), 0 1px 2px -1px rgb(0 0 0 / 0.1)",
      "dark-tremor-dropdown":
        "0 4px 6px -1px rgb(0 0 0 / 0.1), 0 2px 4px -2px rgb(0 0 0 / 0.1)",
    },
    borderRadius: {
      "tremor-small": "0.375rem",
      "tremor-default": "0.5rem",
      "tremor-full": "9999px",
    },
    fontSize: {
      "tremor-label": ["0.75rem"],
      "tremor-default": ["0.875rem", { lineHeight: "1.25rem" }],
      "tremor-title": ["1.125rem", { lineHeight: "1.75rem" }],
      "tremor-metric": ["1.875rem", { lineHeight: "2.25rem" }],
    },
  },
}

```

Also safelist some css classes to prevent tailwind from purging them. To do this add the following to the `safelist` section in `tailwind.config.js`

```
safelist: [
  {
    pattern:
      /^(bg-(?:slate|gray|zinc|neutral|stone|red|orange|amber|yellow|lime|green|emerald|teal|cyan|sky|blue|indigo|violet|purple|fuchsia|pink|rose)-(?:50|100|200|300|400|500|600|700|800|900|950))$/,
    variants: ["hover", "ui-selected"],
  },
  {
    pattern:
      /^(text-(?:slate|gray|zinc|neutral|stone|red|orange|amber|yellow|lime|green|emerald|teal|cyan|sky|blue|indigo|violet|purple|fuchsia|pink|rose)-(?:50|100|200|300|400|500|600|700|800|900|950))$/,
    variants: ["hover", "ui-selected"],
  },
  {
    pattern:
      /^(border-(?:slate|gray|zinc|neutral|stone|red|orange|amber|yellow|lime|green|emerald|teal|cyan|sky|blue|indigo|violet|purple|fuchsia|pink|rose)-(?:50|100|200|300|400|500|600|700|800|900|950))$/,
    variants: ["hover", "ui-selected"],
  },
  {
    pattern:
      /^(ring-(?:slate|gray|zinc|neutral|stone|red|orange|amber|yellow|lime|green|emerald|teal|cyan|sky|blue|indigo|violet|purple|fuchsia|pink|rose)-(?:50|100|200|300|400|500|600|700|800|900|950))$/,
  },
  {
    pattern:
      /^(stroke-(?:slate|gray|zinc|neutral|stone|red|orange|amber|yellow|lime|green|emerald|teal|cyan|sky|blue|indigo|violet|purple|fuchsia|pink|rose)-(?:50|100|200|300|400|500|600|700|800|900|950))$/,
  },
  {
    pattern:
      /^(fill-(?:slate|gray|zinc|neutral|stone|red|orange|amber|yellow|lime|green|emerald|teal|cyan|sky|blue|indigo|violet|purple|fuchsia|pink|rose)-(?:50|100|200|300|400|500|600|700|800|900|950))$/,
  },
  { pattern: /^\-?m(\w?)-/ },
  { pattern: /^p(\w?)-/ },
  { pattern: /^text-/ },
  { pattern: /^bg-/ },
  { pattern: /^w-/ },
  { pattern: /^h-/ },
  { pattern: /^h(\w?)-/ },
  { pattern: /^grid-/ },
  { pattern: /^col-/ },
  { pattern: /^border-/ },
  { pattern: /^gap-/ },
  { pattern: /^min-/ },
],

```

## Components

#### UI Components
  - [ ] Accordion
  - [x] Badges
  - [x] Button
  - [x] Callout
  - [x] Card
  - [ ] Date range picker
  - [ ] Dialog
  - [x] Divider
  - [x] Icons
  - [x] Legend
  - [x] List
  - [ ] Number Input
  - [x] Select
  - [ ] Switch
  - [x] Table
  - [x] Tabs
  - [x] Text Input
  - [x] Textarea

#### Visualization Components
  - [x] Area Chart
  - [x] Bar Chart
  - [ ] Donut Chart
  - [x] Line Chart
  - [ ] Scatter Chart
  - [ ] Funnel Chart
  - [ ] Bar List
  - [x] Progress Bar
  - [ ] Marker Bar
  - [ ] Delta Bar
  - [ ] Category Bar
  - [ ] Progress Circle
  - [ ] Spark Charts
  - [ ] Tracker
  

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/tremorx>.
