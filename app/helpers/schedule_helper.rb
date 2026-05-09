module ScheduleHelper
  # Returns a hash keyed by work_order id with { slot:, total: } for horizontal overlap layout.
  # slot  = which column index this order occupies (0-based)
  # total = how many orders overlap at the same time (determines width fraction)
  def compute_layout(work_orders)
    sorted = work_orders.sort_by { |wo| wo.time.hour * 60 + wo.time.min }
    layout = {}

    sorted.each do |wo|
      start_min = wo.time.hour * 60 + wo.time.min
      end_min   = start_min + wo.duration

      overlapping = sorted.select do |other|
        other_start = other.time.hour * 60 + other.time.min
        other_end   = other_start + other.duration
        other_start < end_min && other_end > start_min
      end

      layout[wo.id] = { slot: overlapping.index(wo), total: overlapping.length }
    end

    layout
  end
end
