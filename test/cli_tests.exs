defmodule CliTest do
  use ExUnit.Case
  doctest Issues

  "This imports our `cli.ex` file, and specifies the function to bring with it"
  import Issues.CLI, only: [parse_args: 1, sort_response: 1]

  test ":help returned by option parsing with -h and --help options" do
    assert parse_args(["-h", "anything"]) == :help
    assert parse_args(["--help", "anything"]) == :help
  end

  test "three values returned if three are given" do
    assert parse_args(["user", "project", "99"]) == {"user", "project", 99}
  end

  test "count is default if two values are given" do
    assert parse_args(["user", "project"]) == {"user", "project", 4}
  end

  test "sort list into descending order" do
    result = sort_response(testing_list(["c", "a", "b"]))
    issues = for issue <- result, do: Map.get(issue, "created_at")
    assert issues == ~w{c b a}
  end

  defp testing_list(values) do
    for value <- values,
    do: %{"created_at" => value, "other_data" => "xxx"}
  end
end
