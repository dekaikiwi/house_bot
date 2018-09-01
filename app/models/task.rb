class Task < ApplicationRecord
  def formatted_description
    return '詳細なし' if description.empty?

    description
  end
end
