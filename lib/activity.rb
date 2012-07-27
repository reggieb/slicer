class Activity
  attr_accessor :start_at, :end_at, :weight
  def weight
    @weight || 1
  end
end
