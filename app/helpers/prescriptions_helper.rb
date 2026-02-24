module PrescriptionsHelper
  def better_pluralize(word, amount)
    amount = amount.to_f
    count = amount % 1 == 0 ? amount.to_i : amount
    word.pluralize(count)
  end
end
