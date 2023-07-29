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

  def clean_all_logs! do
    File.ls!()
    |> Enum.filter(&String.contains?(&1, ".log"))
    |> Enum.each(&File.rm/1)
  end
end
