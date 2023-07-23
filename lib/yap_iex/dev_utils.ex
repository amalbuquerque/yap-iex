defmodule YapIEx.DevUtils do
  def start_multimodal_text do
    Ratatouille.run(
      YapIEx.Components.MultiModalText,
      quit_events: [
        {:key, Ratatouille.Constants.key(:ctrl_c)},
        {:key, Ratatouille.Constants.key(:ctrl_d)}
      ]
    )
  end
end
