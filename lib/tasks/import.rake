require "csv"

namespace :import do
  desc "Import all CSV files into the database (idempotent)"
  task all: %i[technicians locations work_orders]

  desc "Import technicians from TerrierRailsAssessment/technicians.csv"
  task technicians: :environment do
    CSV.foreach(Rails.root.join("TerrierRailsAssessment/technicians.csv"), headers: true, encoding: "bom|utf-8") do |row|
      Technician.find_or_create_by!(id: row["id"].to_i) { |t| t.name = row["name"].strip }
    end
    puts "Technicians imported."
  end

  desc "Import locations from TerrierRailsAssessment/locations.csv"
  task locations: :environment do
    CSV.foreach(Rails.root.join("TerrierRailsAssessment/locations.csv"), headers: true, encoding: "bom|utf-8") do |row|
      Location.find_or_create_by!(id: row["id"].to_i) do |l|
        l.name = row["name"].strip
        l.city = row["city"].strip
      end
    end
    puts "Locations imported."
  end

  desc "Import work orders from TerrierRailsAssessment/work_orders.csv"
  task work_orders: :environment do
    CSV.foreach(Rails.root.join("TerrierRailsAssessment/work_orders.csv"), headers: true, encoding: "bom|utf-8") do |row|
      WorkOrder.find_or_create_by!(id: row["id"].to_i) do |w|
        w.technician_id = row["technician_id"].to_i
        w.location_id   = row["location_id"].to_i
        w.time          = DateTime.strptime(row["time"].strip, "%m/%d/%y %H:%M")
        w.duration      = row["duration"].to_i
        w.price         = row["price"].to_d
      end
    end
    puts "Work orders imported."
  end
end
