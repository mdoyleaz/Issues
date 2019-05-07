defmodule Issues.CLI do
    import Issues.TableFormatter, only: [print_table_for_columns: 2]

    @default_count 4

    @moduledoc"""
    Handles command line parsing and dispatches to other functions that
    end up generating a table of the last issues in a github project
    """

    def main(argv) do
        argv
        |> parse_args
        |> process
    end

    @doc"""
    handles github user name and project
    """
    def parse_args(argv) do
        OptionParser.parse(argv, switches: [help: :boolean], aliases: [h: :help])
        |> elem(1)
        |> cli_args()
    end

    @doc"""
    This is the magic pattern matching of elixir,
    Functions in Elixir are meant to be short and sweet, so limiting the use of
    long conditionals can be done by matching parameters in the functions.

    The function will be selected based on the numer of command line arguements that are supplied

    `_` is the default field, if no arguments are supllied, it will return "Help"


    """

    def cli_args([user, project, count]) do
        {user, project, String.to_integer(count)}
    end

    def cli_args([user, project]) do
        {user, project, @default_count}
    end

    def cli_args(_) do
        :help
    end


    @doc"""
    Process functions are used to handled command line arguments

    First: 'process(:help)' - This is handled when the :help pattern is matched.

    Second: 'process({user, project, _count})' - This is matched when at least 2 values are recieved.
            `_count` is an optional field, which allows the default value to be accepted.
    """

    def process(:help) do
        IO.puts """
        Usage: issues <user> <project> [count | #{@default_count}]
        """

        System.halt(0)
    end


    def process({user, project, count}) do
        Issues.GithubIssues.fetch(user, project)
        |> decode_response()
        |> sort_response()
        |> last(count)
        |> print_table_for_columns(["#", "created_at", "title"])
    end

    def decode_response({:ok, body}), do: body
    def decode_response({_, error}) do
        IO.puts "Error fetching data from GitHub: #{error["message"]}"

        System.halt(2)
    end

    @doc"""
    'sort_response', this function we are using to return a sorted list of issues, these are sorted by creation date.

    An anonymous function is used here to determine where the date value is stored in the map.
    """

    def sort_response(issue_list) do
        issue_list
        |> Enum.sort(fn i1, i2 ->
           i1["created_at"] >= i2["created_at"]
        end)
    end

    def last(list, count) do
        list
        |> Enum.take(count)
        |> Enum.reverse
    end
end
