<#import "layout.ftlh" as ui>
<@ui.page title="checkmate" showSidebar=false>
  <div class="auth">
    <div class="login-card card">
      <div class="h1">checkmate</div>
      <p class="subtitle mt-12">Sign in to manage Test Cases and Runs</p>

        <#if errorMessage??>
          <p class="error" style="color: red; margin-bottom: 10px;">${errorMessage}</p>
        </#if>

        <form class="form mt-24" action="/auth/signin" method="post">
          <input class="input" type="text" name="username" placeholder="Username" required />
          <input class="input" type="password" name="password" placeholder="Password" required />
          <div class="actions">
            <button type="submit" class="btn w-100">Log in</button>
          </div>
        </form>

      <p class="footer-note mt-12">Don't have an account? <a class="link" href="/dashboard">Continue as guest</a></p>
    </div>
  </div>
</@ui.page>
