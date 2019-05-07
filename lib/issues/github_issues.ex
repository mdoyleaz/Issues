defmodule Issues.GithubIssues do
  require Logger

  @user_agent [{"User-agent", "Elixir mdoyleazz@gmail.com"}]
  @github_url Application.get_env(:issues, :github_url)

  @doc"""
  Function requires 2 parameteres, the GitHub Username, and the project that we are checking for issues.

  This function takes advantage of the HTTPoison libray to send a 'GET' request to the GitHub API, it
  first builds the URL by calling the 'issues_url' function and passing the username and project.
  We then pipe this url into the HTTPoison librabry and finally pipe the response into our parser.
  """

  def fetch(user, project) do
    Logger.info("Fetching #{project}, From User: #{user}")

    issues_url(user, project)
    |> HTTPoison.get(@user_agent)
    |> handle_response
  end

  def issues_url(user, project) do
    "#{@github_url}/repos/#{user}/#{project}/issues"
  end

  def handle_response({_, %{status_code: status_code, body: body}}) do
    Logger.info("Received response, Status Code: #{status_code}")
    Logger.debug(fn -> inspect(body) end)
    {
      status_code |> check_for_error(),
      body |> Poison.Parser.parse!()
    }
  end

  @doc"""
  We used a pair of functions to handle different status codes, if the status matches '200', then we return ':ok'

  If any other status code is returned we will return ':error' to and this will be handled from within our 'handle_response'
  function.
  """
  def check_for_error(200), do: :ok
  def check_for_error(_), do: :error
end
