defmodule DatastoreWeb.ErrorViewTest do
  use DatastoreWeb.ConnCase, async: true

  # Bring render/3 and render_to_string/3 for testing custom views
  import Phoenix.View

  test "renders 404.json" do
    assert render(DatastoreWeb.ErrorView, "404.json", []) == %{errors: %{message: "Not Found"}}
  end

  test "renders 500.json" do
    assert render(DatastoreWeb.ErrorView, "500.json", []) ==
             %{errors: %{message: "Internal Server Error"}}
  end
end
