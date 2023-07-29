# YapIEx

vim-inspired IEx wrapper.

## Development

1. Do magic 🛠️
2. Run it with `mix run --no-halt`

Note: ❌ It messes up with the IO, hence if you run with `iex -S mix` the YapIEx terminal application appears "on top" of IEx standard prompt.

Also note that if run within an IEx shell (e.g. `iex -S mix` first and then `Ratatouille.run/2`) it has a bad lag and misses key presses.

I haven't noticed this problem if running it without IEx (only `mix run --no-halt`) 🤔

## Installation

**TODO: Add description**

## Docs

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/yap_iex>.

