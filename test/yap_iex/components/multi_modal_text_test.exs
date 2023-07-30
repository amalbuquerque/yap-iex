defmodule YapIEx.Components.MultiModalTextTest do
  use ExUnit.Case, async: true

  import Ratatouille.Constants, only: [key: 1]

  alias YapIEx.Components.MultiModalText

  @context []
  @cursor "█"

  describe "init/1" do
    test "it starts without contents and the cursor starts at 0" do
      assert %{cursor: 0, content: ""} = MultiModalText.init(@context)
    end
  end

  describe "update and render, adding a character" do
    test "initially it renders nothing" do
      empty_model = MultiModalText.init(@context)

      # the unknown event ensures no update clause is called
      {model, rendered} = update_and_render(empty_model, :unknown_event)

      assert %{cursor: 0, content: ""} = model
      assert rendered == @cursor
    end

    test "when empty, adding a character updates the contents and renders it" do
      model =
        init_model("""
        |0123456789
        *-----------------------
        |
        *-----------------------
        |^
        """)

      {model, rendered} = update_and_render(model, event(?a))

      assert_model_render(model, rendered, """
      |0123456789
      *-----------------------
      |a
      *-----------------------
      | ^
      """)
    end

    test "with contents, adding a character updates the contents and renders it" do
      model =
        init_model("""
        |0123456789
        *-----------------------
        |abc
        *-----------------------
        |   ^
        """)

      {model, rendered} = update_and_render(model, event(?x))

      assert_model_render(model, rendered, """
      |0123456789
      *-----------------------
      |abcx
      *-----------------------
      |    ^
      """)
    end

    test "with contents, cursor on the last character, pressing a character adds it before the cursor" do
      model =
        init_model("""
        |0123456789
        *-----------------------
        |abc
        *-----------------------
        |  ^
        """)

      {model, rendered} = update_and_render(model, event(?x))

      assert_model_render(model, rendered, """
      |0123456789
      *-----------------------
      |abxc
      *-----------------------
      |   ^
      """)
    end

    test "with contents, cursor on the first character, pressing a character adds it before the cursor" do
      model =
        init_model("""
        |0123456789
        *-----------------------
        |abc
        *-----------------------
        |^
        """)

      {model, rendered} = update_and_render(model, event(?x))

      assert_model_render(model, rendered, """
      |0123456789
      *-----------------------
      |xabc
      *-----------------------
      | ^
      """)
    end
  end

  describe "update and render, deleting contents" do
    for backspace_or_delete <- [:backspace, :backspace2, :delete] do
      test "pressing #{backspace_or_delete} without contents doesn't change anything" do
        model =
          init_model("""
          |0123456789
          *-----------------------
          |
          *-----------------------
          |^
          """)

        {model, rendered} = update_and_render(model, event(unquote(backspace_or_delete)))

        assert_model_render(model, rendered, """
        |0123456789
        *-----------------------
        |
        *-----------------------
        |^
        """)
      end
    end

    for backspace <- [:backspace, :backspace2] do
      test "with contents, cursor on the first character, #{backspace} doesn't change anything" do
        model =
          init_model("""
          |0123456789
          *-----------------------
          |abc
          *-----------------------
          |^
          """)

        {model, rendered} = update_and_render(model, event(unquote(backspace)))

        assert_model_render(model, rendered, """
        |0123456789
        *-----------------------
        |abc
        *-----------------------
        |^
        """)
      end

      test "with contents, cursor after the last character, #{backspace} deletes it" do
        model =
          init_model("""
          |0123456789
          *-----------------------
          |abc
          *-----------------------
          |   ^
          """)

        {model, rendered} = update_and_render(model, event(unquote(backspace)))

        assert_model_render(model, rendered, """
        |0123456789
        *-----------------------
        |ab
        *-----------------------
        |  ^
        """)
      end

      test "with contents, cursor on the last character, #{backspace} deletes previous character" do
        model =
          init_model("""
          |0123456789
          *-----------------------
          |abc
          *-----------------------
          |  ^
          """)

        {model, rendered} = update_and_render(model, event(unquote(backspace)))

        assert_model_render(model, rendered, """
        |0123456789
        *-----------------------
        |ac
        *-----------------------
        | ^
        """)
      end
    end

    test "with contents, cursor on the first character, delete removes first character" do
      model =
        init_model("""
        |0123456789
        *-----------------------
        |abc
        *-----------------------
        |^
        """)

      {model, rendered} = update_and_render(model, event(:delete))

      assert_model_render(model, rendered, """
      |0123456789
      *-----------------------
      |bc
      *-----------------------
      |^
      """)
    end

    test "with contents, cursor after the last character, delete doesn't change anything" do
      model =
        init_model("""
        |0123456789
        *-----------------------
        |abc
        *-----------------------
        |   ^
        """)

      {model, rendered} = update_and_render(model, event(:delete))

      assert_model_render(model, rendered, """
      |0123456789
      *-----------------------
      |abc
      *-----------------------
      |   ^
      """)
    end

    test "with contents, cursor on the last character, delete deletes it" do
      model =
        init_model("""
        |0123456789
        *-----------------------
        |abc
        *-----------------------
        |  ^
        """)

      {model, rendered} = update_and_render(model, event(:delete))

      assert_model_render(model, rendered, """
      |0123456789
      *-----------------------
      |ab
      *-----------------------
      |  ^
      """)
    end
  end

  describe "update and render, pressing horizontal arrows" do
    for arrow <- [:arrow_left, :arrow_right] do
      test "when empty, pressing #{arrow} doesn't change anything" do
        model =
          init_model("""
          |0123456789
          *-----------------------
          |
          *-----------------------
          |^
          """)

        {model, rendered} = update_and_render(model, event(unquote(arrow)))

        assert_model_render(model, rendered, """
        |0123456789
        *-----------------------
        |
        *-----------------------
        |^
        """)
      end
    end

    test "with contents, pressing right doesn't change anything" do
      model =
        init_model("""
        |0123456789
        *-----------------------
        |abc
        *-----------------------
        |   ^
        """)

      {model, rendered} = update_and_render(model, event(:arrow_right))

      assert_model_render(model, rendered, """
      |0123456789
      *-----------------------
      |abc
      *-----------------------
      |   ^
      """)
    end

    test "with contents, pressing left moves the cursor left" do
      model =
        init_model("""
        |0123456789
        *-----------------------
        |abc
        *-----------------------
        |   ^
        """)

      {model, rendered} = update_and_render(model, event(:arrow_left))

      assert_model_render(model, rendered, """
      |0123456789
      *-----------------------
      |abc
      *-----------------------
      |  ^
      """)
    end

    test "with contents, cursor on the last character, pressing right moves the cursor to the end" do
      model =
        init_model("""
        |0123456789
        *-----------------------
        |abc
        *-----------------------
        |  ^
        """)

      {model, rendered} = update_and_render(model, event(:arrow_right))

      assert_model_render(model, rendered, """
      |0123456789
      *-----------------------
      |abc
      *-----------------------
      |   ^
      """)
    end

    test "with contents, cursor on the last character, pressing left moves the cursor to the previous character" do
      model =
        init_model("""
        |0123456789
        *-----------------------
        |abc
        *-----------------------
        |  ^
        """)

      {model, rendered} = update_and_render(model, event(:arrow_left))

      assert_model_render(model, rendered, """
      |0123456789
      *-----------------------
      |abc
      *-----------------------
      | ^
      """)
    end
  end

  describe "(only for tests) init_model/1" do
    test "initializes an empty model" do
      model =
        init_model("""
        |0123456789
        *-----------------------
        |
        *-----------------------
        |^
        """)

      assert model.content == ""
      assert model.cursor == 0
    end

    test "it returns the expected contents and cursor" do
      model =
        init_model("""
        |0123456789
        *-----------------------
        |hello fam
        *-----------------------
        |      ^
        """)

      assert model.content == "hello fam"
      assert String.slice(model.content, model.cursor, 1) == "f"
    end
  end

  defp update_and_render(model, message) do
    updated_model = MultiModalText.update(model, message)

    result = MultiModalText.render(updated_model)

    # inside the `label` we have >=1 `text` elements
    label = hd(result.children)

    rendered = label.children |> Enum.map(& &1.attributes.content) |> Enum.join("")

    {updated_model, rendered}
  end

  # |0123456789
  # *-----------------------
  # |
  # *-----------------------
  # |^
  defp init_model(contents_cursor_representation) do
    [_positions, separator, model_content, separator, cursor_ruler] =
      String.split(contents_cursor_representation, "\n") |> Enum.reject(&(&1 == ""))

    "|" <> model_content = model_content
    "|" <> cursor_ruler = cursor_ruler

    assert cursor_position = cursor_ruler |> String.to_charlist() |> Enum.find_index(&(&1 == ?^))

    %{content: model_content, cursor: cursor_position}
  end

  defp assert_model_render(model, rendered, expected_representation) do
    # using the init_model/1 to parse the representation
    expected_model = init_model(expected_representation)

    assert model.content == expected_model.content
    assert model.cursor == expected_model.cursor

    if String.length(model.content) == model.cursor do
      assert rendered == model.content <> @cursor
    else
      assert rendered == model.content
    end
  end

  defp event(key) when key in [:arrow_left, :arrow_right, :backspace, :backspace2, :delete],
    do: {:event, %{key: key(key)}}

  defp event(key) when key > 0, do: {:event, %{ch: key}}
end
