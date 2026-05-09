# Terrier Scheduler

A Ruby on Rails scheduling application for pest control work orders. Displays technicians and their daily work orders on a visual scheduling grid, and allows users to click open time slots to see available time.

## Requirements

- Ruby 3.4.3
- Rails 8.0.5
- SQLite3

## Setup

```bash
bundle install
bin/rails db:migrate
bin/rake import:all
bin/rails server
```

Then visit `http://localhost:3000`.

## Importing Data

The app ships with CSV files in `TerrierRailsAssessment/`. The import rake task loads all three into the database:

```bash
bin/rake import:all
```

This is **idempotent** — running it multiple times will not create duplicates. Individual tables can also be imported separately:

```bash
bin/rake import:technicians
bin/rake import:locations
bin/rake import:work_orders
```

## Design

### Approach

The three data models — `Technician`, `Location`, and `WorkOrder` — pulled directly from the provided CSV files. `WorkOrder` is a join table between `Technician` and `Location`, with `time` (datetime), `duration` (integer, in minutes), and `price` (decimal) columns.

The scheduling grid is rendered as a single page. Each technician gets a column rendered with `position: relative`, and work order blocks are positioned inside it using `position: absolute` with `top` and `height` calculated as percentages of the total day span (1 pixel per minute). This approach was necessary because a standard HTML table layout cannot represent arbitrary time durations and positions accurately.

Overlapping work orders within a technician's column are detected server-side in `ScheduleHelper#compute_layout`, which sorts orders by start time and determines each order's horizontal slot index and the total number of concurrent overlaps. Overlapping blocks are then rendered side-by-side using proportional `left` and `width` values.

The click interaction is handled entirely client-side in `app/javascript/schedule.js`. Each technician column carries its work order schedule as a JSON data attribute. On click, the script converts the click's Y position within the column into a time value, finds the surrounding work orders, and alerts the user with the available gap duration.

### Problems Faced

- **Grid line alignment**: The day view starts at 5:30 AM (to give breathing room above the first 6:00 AM order), which means hourly grid lines can't simply repeat from the top. This was solved with `background-position` offset on the repeating CSS gradient.
- **Overlapping blocks**: The assessment data includes work orders that overlap within the same technician column. A layout pass was added server-side to detect overlaps and assign each block a proportional horizontal slice.

### Possible Future Improvements

- Drag-and-drop rescheduling of work orders directly on the grid
- Support for multi-day views with a date picker
- Ability to create, edit, and delete work orders and technicians from the UI
- Color-coding work orders by status, technician, or service type

## Hosted

Deployed via [Railway](https://railway.app). Render was considered but no longer offers a free tier for Rails applications.

[Coming soon]
