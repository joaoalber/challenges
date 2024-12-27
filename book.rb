class Book
  $BOOKS = []
  STATUSES = ["checked_out", "reserved", "available"]

  class << self
    def create(params)
      errors = []

      errors << "title cannot be empty" unless params["title"]
      errors << "author cannot be empty" unless params["author"]
      errors << "publication_date cannot be empty" unless params["publication_date"]
      errors << "invalid status" if params["status"] && !STATUSES.include?(params["status"])

      return { success: false, errors: } if !errors.empty?

      $BOOKS << build(params)

      { success: true, errors: }
    end

    def all
      { books: $BOOKS }
    end

    def find(id)
      book = $BOOKS.find { |book| book[:id] == id.to_i }

      { book: } if book
    end

    def delete(id)
      $BOOKS.delete_if { |book| book[:id] == id.to_i } 
    end

    def update(book, params)
      if book
        book[:rating] = params["rating"] if params["rating"]
        book[:status] = params["status"] if params["status"] && STATUSES.include?(params["status"])

        { book: }
      end
    end

    def build(params)
      { 
        id: $BOOKS.size + 1,
        title: params["title"],
        author: params["author"],
        publication_date: params["publication_date"],
        rating: params["rating"],
        status: params["status"] || "available",
      }.compact
    end
  end
end