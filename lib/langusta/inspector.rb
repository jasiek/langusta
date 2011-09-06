module Langusta
  module Inspector
    def object_ptr
      (object_id * 2).to_s(16)
    end
  end
end
