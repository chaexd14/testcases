<#import "layout.ftlh" as ui>
<@ui.page title="Test Case" active="testcases">
<link rel="stylesheet" href="/css/testcase_form.css">

  <div class="toolbar">
    <div class="h1">${(testcase.id)?has_content?then('Edit Test Case','Add Test Case')}</div>
    <a class="btn secondary" href="/testcases">Back</a>
  </div>

  <div class="card">
    <form class="form" action="/testcases" method="post">
      <input type="hidden" name="id" value="${testcase.id?if_exists}">
      <div>
        <label class="subtitle">Module</label>
        <input class="input" type="text" name="module" value="${testcase.module?if_exists}" placeholder="e.g. Authentication, Billing" />
      </div>
      <div>
        <label class="subtitle">Title</label>
        <input class="input" type="text" name="name" value="${testcase.name?if_exists}" required />
      </div>
      <div>
        <label class="subtitle">Description</label>
        <input class="input" type="text" name="description" value="${testcase.description?if_exists}" />
      </div>
      <div>
        <label class="subtitle">Steps</label>
        <textarea class="textarea" name="testSteps">${testcase.testSteps?if_exists}</textarea>
      </div>
      <div>
        <label class="subtitle">Expected Result</label>
        <textarea class="textarea" name="expectedResults">${testcase.expectedResults?if_exists}</textarea>
      </div>
      <div class="actions">
        <button class="btn" type="submit">Save</button>
      </div>
    </form>
  </div>
</@ui.page>
