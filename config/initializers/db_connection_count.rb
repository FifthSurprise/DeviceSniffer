class DbConnectionCounter
  attr_accessor :connection_count

  def initialize
    @connection_count = 0
  end
end

DB_COUNTER = DbConnectionCounter.new