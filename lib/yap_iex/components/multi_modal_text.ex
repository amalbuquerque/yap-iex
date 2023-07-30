defmodule YapIEx.Components.MultiModalText do
  @moduledoc """
  This component handles the text content, cursor position and eventually it will also handle the operators applied to text objects.

  The component starts with empty `content` (`content == ""`) and the cursor on position 0 (`cursor == 0`).

  The diagram below shows the cursor (`^`) and the empty contents.

  ```
   0123456789
  *-----------------------
  |
  *-----------------------
   ^
  ```

  When a new character is added ('a'), the content becomes `"a"` and the cursor becomes 1.

  ```
   0123456789
  *-----------------------
  |a
  *-----------------------
    ^
  ```

  At any time the cursor can go from 0 (first position) to `String.length(content)`. The cursor can be moved with the `left` and `right` keys.
  """

  @behaviour Ratatouille.App

  import Ratatouille.Constants, only: [key: 1]
  import Ratatouille.View

  require Logger

  @k_left key(:arrow_left)
  @k_right key(:arrow_right)
  @k_delete key(:delete)
  @k_backspaces [key(:backspace), key(:backspace2)]
  @k_spacebar key(:space)
  @k_enter key(:enter)

  def init(_context) do
    # TODO: get default keys, submit_fn from context

    %{
      cursor: 0,
      content: "",
      submit_fn: fn content -> Logger.info("Submitting: #{inspect(content)}") end
    }
  end

  def update(%{cursor: cursor} = model, {:event, %{key: @k_left}}) do
    %{model | cursor: move_cursor_left(cursor)}
  end

  def update(%{cursor: cursor, content: content} = model, {:event, %{key: @k_right}}) do
    new_cursor = move_cursor_right(content, cursor)

    %{model | cursor: new_cursor}
  end

  def update(%{cursor: cursor, content: content} = model, {:event, %{key: key}})
      when key in @k_backspaces do
    {until_cursor, after_cursor} = split_content_before_cursor(content, cursor)

    content = String.slice(until_cursor, 0..-2) <> after_cursor
    new_cursor = move_cursor_left(cursor)

    %{model | content: content, cursor: new_cursor}
  end

  def update(%{cursor: cursor, content: content} = model, {:event, %{key: @k_delete}}) do
    {until_cursor, after_cursor} = split_content_before_cursor(content, cursor)

    content = until_cursor <> String.slice(after_cursor, 1..String.length(after_cursor))

    %{model | content: content, cursor: cursor}
  end

  def update(%{cursor: cursor, content: content} = model, {:event, %{key: @k_spacebar}}) do
    {until_cursor, after_cursor} = split_content_at_cursor(content, cursor)

    content = until_cursor <> " " <> after_cursor
    cursor = move_cursor_right(content, cursor)

    %{model | content: content, cursor: cursor}
  end

  def update(%{cursor: cursor, content: content} = model, {:event, %{ch: ch}}) when ch > 0 do
    {until_cursor, after_cursor} = split_content_before_cursor(content, cursor)

    content = until_cursor <> <<ch::utf8>> <> after_cursor
    cursor = move_cursor_right(content, cursor)

    %{model | content: content, cursor: cursor}
  end

  def update(%{content: content, submit_fn: submit_fn} = model, {:event, %{key: @k_enter}}) do
    submit_fn.(content)

    %{model | content: "", cursor: 0}
  end

  # if we don't expect it, we keep the model
  # the same
  def update(model, _msg), do: model

  def render(%{content: content, cursor: cursor}) do
    view do
      if cursor >= String.length(content) do
        label do
          text(content: content <> "█")
        end
      else
        {before_cursor, after_cursor} = split_content_at_cursor(content, cursor)

        cursor_character = String.last(before_cursor)

        label do
          text(content: String.slice(before_cursor, 0..-2))
          text(content: cursor_character, color: :black, background: :white)
          text(content: after_cursor)
        end
      end
    end
  end

  defp move_cursor_left(cursor), do: max(cursor - 1, 0)

  defp move_cursor_right(content, cursor), do: min(cursor + 1, String.length(content))

  # it returns two strings splitting the content,
  # the first string goes from the beginning until the cursor (including it),
  # the second string starts with the character after the cursor, and goes until the end
  #
  #  0123456789
  # *-----------
  # |abc
  # *-----------
  # |  ^
  #
  # split_content_at_cursor("abc", 2) returns {"abc", ""}
  defp split_content_at_cursor(content, cursor) do
    # cursor + 1 because the cursor index is 0-based
    String.split_at(content, cursor + 1)
  end

  #  0123456789
  # *-----------
  # |abc
  # *-----------
  # |  ^
  #
  # split_content_before_cursor("abc", 2) returns {"ab", "c"}
  defp split_content_before_cursor(content, cursor) do
    # cursor because the cursor index is 0-based
    String.split_at(content, cursor)
  end
end
