class Result
  attr_reader :data, :status, :meta

  def initialize(data, status: 200, meta: {})
    @data = data
    @status = status
    @meta = meta
  end

  def valid?
    status == 200
  end
end
