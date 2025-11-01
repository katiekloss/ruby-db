class DB

  class << self
    attr_accessor(:dir, :next_id)
  end

  include Client

end
