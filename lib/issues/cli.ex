defmodule Issues.CLI do
    @default_count 4

    @moduledoc"""
    Handles command line parsing and dispatches to other functions that
    end up generating a table of the last issues in a github project
    """

    def run(argv) do
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


    def process({user, project, _count}) do
        Issues.GithubIssues.fetch(user, project)
    end

end
