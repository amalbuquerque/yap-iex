defmodule YapIEx.TerminalApp do
  @behaviour Ratatouille.App

  import Ratatouille.View

  alias YapIEx.Components.MultiModalText

  def init(_context) do
    %{multimodal_text: MultiModalText.init([])}
  end

  def update(model, msg) do
    new_multimodal_text = MultiModalText.update(model, msg)

    %{model | multimodal_text: new_multimodal_text}
  end

  def render(model) do
    view do
      MultiModalText.render(model.multimodal_text)
    end
  end
end
