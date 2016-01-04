module BlocRecord
  class Collection < Array
    def update_all(updates)
      ids = self.map(&:id)
      self.any? ? self.first.class.update(ids, updates) : false
    end

    def group(*args)
      ids = self.map(&:id)
      self.any? ? self.first.class.group_by_ids(ids, args) : false
    end
  end
end
