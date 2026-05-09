class ScheduleController < ApplicationController
  def index
    @technicians = Technician.includes(work_orders: :location).order(:name)
    @day_start   = 5 * 60 + 30  # 330 min — 5:30 AM to show everything
    @day_end     = 17 * 60 + 30   # 1020 min — 5:30 PM to show everything
    @day_span    = @day_end - @day_start  # 660 min
    @hours       = (5..17).to_a
  end
end
