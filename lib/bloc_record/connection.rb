require 'sqlite3'

module Connection
  def connection
    @connection ||= SQLite3::Database.new(BlocRecord.databese_filename)
  end
end
