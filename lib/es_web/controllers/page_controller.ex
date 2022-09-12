defmodule EsWeb.PageController do
  use EsWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
