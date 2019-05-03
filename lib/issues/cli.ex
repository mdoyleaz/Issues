defmodule Issues.CLI do
    @default_count 4

    @moduledoc"""
    Handles command line parsing and dispatches to other functions that
    end up generating a table of the last issues in a github project
    """

    def run(argv) do
        parse_args(argv)
    end

    @doc"""
    handles github user name and project
    """
    def parse_args(argv) do
        parse = OptionParser.parse(argv, switches: [help: :boolean], aliases: [h: :help])
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



end
