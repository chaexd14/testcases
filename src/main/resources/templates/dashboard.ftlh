<#import "layout.ftlh" as ui>
<@ui.page title="Dashboard" active="dashboard">
  <div class="toolbar">
    <div class="h1">Dashboard</div>
  </div>


  <div class="grid cols-2">
    <!-- Left: Pie chart card only -->
    <div class="card">
      <div class="h1">Status distribution</div>
      <div class="pie-box">
        <canvas id="statusPie" width="360" height="360" class="pie-canvas"></canvas>
        <div id="legend-container" class="legend-col"></div>
      </div>

    </div>

    <!-- Right: three stacked cards -->
    <div class="stack">
      <div class="card">
        <div class="h1">Total test cases</div>
        <div class="stat mt-12">
          <div class="value">${totalCases!0}</div>
          <div class="label">Across all modules</div>
        </div>
      </div>

      <div class="card">
        <div class="h1">Most failed test modules</div>
        <#if topFailedModules?size == 0>
          <p class="subtitle">No failures recorded yet.</p>
        <#else>
          <table class="table mt-12">
            <thead>
              <tr>
                <th>Module</th>
                <th class="text-right">Failed</th>
              </tr>
            </thead>
            <tbody>
              <#list topFailedModules as entry>
                <tr>
                  <td>${entry.key}</td>
                  <td class="text-right">${entry.value}</td>
                </tr>
              </#list>
            </tbody>
          </table>
        </#if>
      </div>

      <div class="card">
        <div class="h1">Last run date</div>
        <div class="stat mt-12">
          <div class="value">${(lastRun)!"—"}</div>
          <div class="label">Most recent Test Run</div>
        </div>
      </div>
    </div>
  </div>

  <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.1/dist/chart.umd.min.js"></script>
  <script>
    const ctx = document.getElementById('statusPie').getContext('2d');
    const data = {
      labels: ['Passed', 'Failed', 'Not yet tested', 'Skipped'],
      datasets: [{
        data: [${runsPassed!0}, ${runsFailed!0}, ${runsNotTested!0}, ${runsSkipped!0}],
        backgroundColor: ['#7DAE95', '#ef4444', '#DAEED7', '#f59e0b'],
        hoverOffset: 8,
      }]
    };
    const chart = new Chart(ctx, {
      type: 'pie',
      data,
      options: {
        maintainAspectRatio: false,

        plugins: {
          legend: {
  position: 'bottom',
  labels: { boxWidth: 16, padding: 12 }
},

          tooltip: {
            callbacks: {
              // Avoid FreeMarker interpreting JS template literals
              label: (p) => p.label + ': ' + p.formattedValue
            }
          }
        }
      }
    });
  </script>
</@ui.page>
