require 'sqlite3'

module Selection
  def find(*ids)
    if ids.length == 1
      find_one(ids.first)
    else
      objs = []
      ids.each do |id|
        objs << find_one(id)
      end
      objs
    end
  end

  def find_one(id)
    row = connection.get_first_row <<-SQL
      SELECT #{columns.join ","} FROM #{table}
      WHERE id = #{id};
    SQL

    data = Hash[columns.zip(row)]
    new(data)
  end

  def take(num=1)
    if num > 1
      objs = []
      num.times { objs << take_one }
      objs
    else
      take_one
    end
  end

  def take_one
    row = connection.get_first_row <<-SQL
      SELECT #{columns.join ","} FROM #{table}
      ORDER BY random()
      LIMIT 1;
    SQL

    data = Hash[columns.zip(row)]
    new(data)
  end

  def first
    row = connection.get_first_row <<-SQL
      SELECT #{columns.join ","} FROM #{table}
      ORDER BY id
      ASC LIMIT 1;
    SQL

    data = Hash[columns.zip(row)]
    new(data)
  end

  def last
    row = connection.get_first_row <<-SQL
      SELECT #{columns.join ","} FROM #{table}
      ORDER BY id
      DESC LIMIT 1;
    SQL

    data = Hash[columns.zip(row)]
    new(data)
  end

  def all
    rows = connection.execute <<-SQL
      SELECT #{columns.join ","} FROM #{table};
    SQL

    rows_to_array(rows)
  end

  def where(*args)
    if args.count > 1
      sql = <<-SQL
        SELECT #{columns.join ","} FROM #{table}
        WHERE #{args.shift};
      SQL
      rows = connection.execute(sql, args)
    else
      case args.first
      when String
        expression = args.first
        rows = connection.execute <<-SQL
          SELECT #{columns.join ","} FROM #{table}
          WHERE #{expression};
        SQL
      when Hash
        expression_hash = args.first
        expression_hash = BlocRecord::Utility.convert_keys(expression_hash)
        expression = expression_hash.keys.map {|key| "#{key}=:#{key}"}.join(" and ")
        sql = <<-SQL
          SELECT #{columns.join ","} FROM #{table}
          WHERE #{expression};
        SQL
        rows = connection.execute(sql, expression_hash)
      end
    end

    rows_to_array(rows)
  end


  private
  def rows_to_array(rows)
    rows.map {|row| new(Hash[columns.zip(rows)]) }
  end
end
