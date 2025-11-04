<#-- Base layout macro for pages (.ftlh) -->
<#macro page title active="dashboard" showSidebar=true>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>${title}</title>
  <link rel="stylesheet" href="/css/app.css" />
  <link rel="stylesheet" href="/css/layout.css" />
  <link rel="stylesheet" href="/css/dashboard.css" />
  <link rel="stylesheet" href="/css/testcase_form.css" />

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
        <div class="brand brand-dark"><span class="dot"></span> checkmate</div>
        <nav class="nav">
          <a href="/dashboard" class="${(active=="dashboard")?then("active","")}">Dashboard</a>
          <a href="/testcases" class="${(active=="testcases")?then("active","")}">Test Cases</a>
          <a href="/testruns" class="${(active=="testruns")?then("active","")}">Test Runs</a>
          <a href="/testcases/new" class="${(active=="addcase")?then("active","")}">Add Test Case</a>
          <a href="#" class="${(active=="settings")?then("active","")}">Settings</a>

          <a href="/auth/signout/new">Sign Out</a>
        </nav>
  <div class="footer-note push-bottom">v0.1 • FreeMarker/Spring Boot</div>
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
