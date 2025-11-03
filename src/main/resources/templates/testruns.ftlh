<#import "layout.ftlh" as ui>
<@ui.page title="Test Runs" active="testruns">
<link rel="stylesheet" href="/css/testruns.css">

  <div class="toolbar">
    <div class="h1">Run Test Case</div>
    <a class="btn secondary" href="/testcases">View Test Cases</a>
  </div>

  <div class="grid cols-2">
<div>
   <form class="form form-container wide-form" action="/testruns" method="post">


        <div>
          <label class="subtitle">Select Test Case</label>
          <select class="select" name="testCaseId">
            <#list testcases as tc>
              <option value="${tc.id}">${tc.name}</option>
            </#list>
          </select>
        </div>
        <div>
          <label class="subtitle">Result</label>
          <select class="select" name="status">
            <#list statuses as st>
              <#assign lbl = (st=="NOT_TESTED")?then("Not yet tested", st?capitalize)>
              <option value="${st}" <#if st == "NOT_TESTED">selected</#if>>${lbl}</option>
            </#list>
          </select>
        </div>
        <div class="actions">
          <button class="btn" type="submit">Save Result</button>
        </div>
      </form>
    </div>

    <div>
      <table class="table">
        <thead>
          <tr>
            <th>ID</th>
            <th>Test Case</th>
            <th>Status</th>
          </tr>
        </thead>
        <tbody>
          <#list testruns as run>
            <tr>
              <td>${run.id}</td>
              <td>${run.testCase.name}</td>
              <td>
                <#assign slabel = (run.status?string=="NOT_TESTED")?then("Not yet tested", run.status?string?capitalize)>
                <span class="badge <#if run.status?string=="PASSED">success<#elseif run.status?string=="FAILED">danger<#elseif run.status?string=="SKIPPED">warn</#if>">
                  ${slabel}
                </span>
              </td>
            </tr>
          </#list>
        </tbody>
      </table>
    </div>
  </div>
</@ui.page>
