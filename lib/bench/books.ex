defmodule Bench.Books do
  import Ecto.Query
  alias Bench.Repo
  alias Bench.Books.Book
  alias Bench.Filter

  def get_book!(id), do: Repo.get!(Book, id)

  def list_books do
    Repo.all(from b in Book, order_by: [desc: b.id])
  end

  def list_books_with_author do
    list_books()
    |> Repo.preload(:author)
  end

  def list_books_with_author(filters) when is_map(filters) do
    from(Book)
    |> Filter.paginate(filters)
    |> Filter.sort(filters)
    |> Repo.all()
    |> Repo.preload(:author)
  end

  def create_book(attrs \\ %{}) do
    %Book{}
    |> Book.changeset(attrs)
    |> Repo.insert()
  end

  def update_book(%Book{} = book, attrs \\ %{}) do
    book
    |> Book.changeset(attrs)
    |> Repo.update()
  end

  def delete_book(%Book{} = book) do
    Repo.delete(book)
  end

  def change_book(%Book{} = book, attrs \\ %{}) do
    Book.changeset(book, attrs)
  end

  def books_count do
    Repo.aggregate(Book, :count, :id)
  end
end
