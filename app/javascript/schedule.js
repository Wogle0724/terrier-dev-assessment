document.querySelectorAll(".tech-column").forEach(function(col) {
  var orders   = JSON.parse(col.dataset.orders);
  var dayStart = parseInt(col.dataset.dayStart);
  var daySpan  = parseInt(col.dataset.daySpan);

  col.addEventListener("click", function(e) {
    if (e.target.closest(".work-order-block")) return;

    var rect     = col.getBoundingClientRect();
    var clickY   = e.clientY - rect.top;
    var clickMin = dayStart + (clickY / rect.height) * daySpan;

    var sorted = orders.slice().sort(function(a, b) { return a.start_min - b.start_min; });
    var prev   = null;
    var next   = null;

    for (var i = 0; i < sorted.length; i++) {
      if (sorted[i].end_min <= clickMin) prev = sorted[i];
      else if (sorted[i].start_min > clickMin && !next) next = sorted[i];
    }

    var gapStart  = prev ? prev.end_min : dayStart;
    var gapEnd    = next ? next.start_min : (dayStart + daySpan);
    var available = Math.round(gapEnd - gapStart);
    var h         = Math.floor(available / 60);
    var m         = available % 60;

    var msg = h > 0 ? h + "h " + m + "m available" : m + "m available";
    alert(msg);
  });
});
