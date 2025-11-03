<#import "layout.ftlh" as ui>
<link rel="stylesheet" href="/css/testcases.css">
<@ui.page title="Test Cases" active="testcases">
  <div class="toolbar">
    <div class="h1">Test Cases</div>
    <a class="btn" href="/testcases/new">Add Test Case</a>
  </div>

  <div class="grid cols-2">
    <div>
      <table class="table">
        <thead>
          <tr>
            <th>ID</th>
            <th>Title</th>
            <th>Description</th>
            <th>Status</th>
            <th class="text-right">Actions</th>
          </tr>
        </thead>
        <tbody>
          <#list testcases as tc>
            <tr>
              <td>${tc.id}</td>
              <td>${tc.name}</td>
              <td>${tc.description!""}</td>
              <td>
                <#-- Safely read latest status (map may be missing) -->
                <#assign statusMap = lastStatusByCaseId!{}>
                <#assign s = statusMap[tc.id?string]!"NOT_TESTED">
                <#assign label = (s=="NOT_TESTED")?then("Not yet tested", s?string?capitalize)>
                <span class="badge <#if s=="PASSED">success<#elseif s=="FAILED">danger<#elseif s=="SKIPPED">warn</#if>">
                  ${label}
                </span>
              </td>
              <td class="text-right">
                <div class="action-icons">
  <a href="/testcases/edit/${tc.id}" class="icon-btn">
    <img src="/images/edit_button.png" alt="Edit" class="icon edit-icon">
  </a>
  <a href="/testcases/delete/${tc.id}" class="icon-btn">
    <img src="/images/delete_button.png" alt="Delete" class="icon delete-icon">
  </a>
</div>

              </td>
            </tr>
          </#list>
        </tbody>
      </table>
    </div>

    <div class="card">
      <div class="h1">Test Case Statistics</div>
      <div class="grid mt-12">
        <div class="stat">
          <div class="label">Total</div>
          <div class="value">${testcases?size}</div>
        </div>
        <div class="stat">
          <div class="label">Passed</div>
          <div class="value">${runsPassed!0}</div>
        </div>
        <div class="stat">
          <div class="label">Failed</div>
          <div class="value text-danger">${runsFailed!0}</div>
        </div>
        <div class="stat">
          <div class="label">Not yet tested</div>
          <div class="value">${runsNotTested!0}</div>
        </div>
      </div>
    </div>
  </div>
</@ui.page>
