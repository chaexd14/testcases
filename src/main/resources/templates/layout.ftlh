<#-- Base layout macro for pages (.ftlh) -->
<#macro page title active="dashboard" showSidebar=true>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>${title}</title>
  <link rel="stylesheet" href="/css/app.css" />
  <style>
    /* Unified header + sidebar behavior */
    .navbar{position:fixed;top:0;left:0;right:0;display:flex;align-items:center;gap:12px;justify-content:space-between;background:#A1AEC9;border-bottom:1px solid var(--border);box-shadow:var(--shadow);padding:12px 16px;z-index:90}
    .brand-name{display:flex;align-items:center;gap:10px;font-weight:800;text-transform:lowercase}
    .burger{appearance:none;background:transparent;border:1px solid var(--border);border-radius:10px;padding:8px 10px;cursor:pointer}

    /* Fixed sidebar, closed by default */
    .sidebar{position:fixed;top:56px;left:-260px;bottom:0;width:260px;background:#A1AEC9;border-right:1px solid var(--border);box-shadow:var(--shadow);padding:16px 12px;display:flex;flex-direction:column;gap:12px;transition:left .3s ease;z-index:95}
    body.sidebar-open .sidebar{left:0}

    /* Content shifts when sidebar is open */
    .content{margin-top:76px;transition:margin-left .3s ease}
    body.sidebar-open .content{margin-left:260px}

    /* Make header visually connected to sidebar when open */
    body.sidebar-open .navbar{padding-left:276px;transition:padding-left .3s ease}

    @media (max-width:980px){
      body.sidebar-open .navbar{padding-left:16px}
      body.sidebar-open .content{margin-left:0}
    }
  </style>
</head>
<body>
  <#if showSidebar>
    <div class="app">
      <div class="navbar">
        <button class="burger" id="burger">☰</button>
        <div class="brand-name">checkmate</div>
        <div></div>
      </div>

      <aside class="sidebar" id="sidebar">
        <div class="brand" style="color:#1f2937"><span class="dot"></span> checkmate</div>
        <nav class="nav">
          <a href="/dashboard" class="${(active=="dashboard")?then("active","")}">Dashboard</a>
          <a href="/testcases" class="${(active=="testcases")?then("active","")}">Test Cases</a>
          <a href="/testruns" class="${(active=="testruns")?then("active","")}">Test Runs</a>
          <a href="/testcases/new" class="${(active=="addcase")?then("active","")}">Add Test Case</a>
          <a href="#" class="${(active=="settings")?then("active","")}">Settings</a>
        </nav>
        <div style="margin-top:auto" class="footer-note">v0.1 • FreeMarker/Spring Boot</div>
      </aside>

      <main class="content">
        <#-- flash messages -->
        <#if toastSuccess??>
          <div class="alert success">${toastSuccess}</div>
        </#if>
        <#if toastError??>
          <div class="alert danger">${toastError}</div>
        </#if>
        <#nested>
      </main>
    </div>
    <script>
      // Sidebar closed by default; toggle adds a class on body to unify behavior
      const burger = document.getElementById('burger');
      burger?.addEventListener('click', () => {
        document.body.classList.toggle('sidebar-open');
      });
    </script>
  <#else>
    <#nested>
  </#if>
</body>
</html>
</#macro>
