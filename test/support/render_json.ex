defmodule BankingApi.RenderJson do
  def render_json(view, template, assigns) do
    assigns = Map.new(assigns)
    output = view.render(template, assigns)

    output
    |> Poison.encode!()
    |> Poison.decode!()
  end
end
