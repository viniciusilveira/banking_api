defmodule BankingApi.UserFactory do
  alias BankingApi.Accounts.User

  alias Faker.Internet

  defmacro __using__(_opts) do
    quote do
      def user_factory do
        %User{
          name: Internet.user_name(),
          email: Internet.email(),
          password: "passwd1234",
          password_confirmation: "passwd1234"
        }
      end
    end
  end
end
