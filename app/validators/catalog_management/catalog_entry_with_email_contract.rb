module CatalogManagement
  class CatalogEntryWithEmailContract < ::CatalogManagement::CatalogEntryContract
    params do
      required(:email).filled(:string)
    end

    rule(:email) do
      unless /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i.match?(value)
        key.failure(:email?)
      end

      unless User.where(email: value).present?
        key.failure(:no_user)
      end
    end
  end
end