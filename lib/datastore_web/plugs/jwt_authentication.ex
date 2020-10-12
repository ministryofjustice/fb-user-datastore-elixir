defmodule DatastoreWeb.Plugs.JWTAuthentication do
  import Plug.Conn

  def init(_params) do
  end

  def call(conn, _params) do
    conn
  end
end
