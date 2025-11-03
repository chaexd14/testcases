<#import "layout.ftlh" as ui>
<@ui.page title="checkmate" showSidebar=false>
  <div class="auth">
    <div class="login-card card">
      <div class="h1">checkmate</div>
      <p class="subtitle mt-12">Sign in to manage Test Cases and Runs</p>

      <form class="form mt-24" action="/dashboard" method="get">
        <input class="input" type="text" placeholder="Username" />
        <input class="input" type="password" placeholder="Password" />
        <div class="actions">
          <button type="submit" class="btn w-100">Log in</button>
        </div>
      </form>
      <p class="footer-note mt-12">Don't have an account? <a class="link" href="/dashboard">Continue as guest</a></p>
    </div>
  </div>
</@ui.page>
