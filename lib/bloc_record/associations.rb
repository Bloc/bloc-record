require 'sqlite3'
require 'active_support/inflector'

module Associations
  def has_many(association)
    define_method(association) do
      rows = self.class.connection.execute <<-SQL
        SELECT * FROM #{association.to_s.singularize}
        WHERE #{self.class.table}_id = #{self.id}
      SQL

      class_name = association.to_s.classify.constantize
      collection = BlocRecord::Collection.new

      rows.each do |row|
        collection << class_name.new(Hash[class_name.columns.zip(row)])
      end

      collection
    end
  end
end
