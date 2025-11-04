<#import "layout.ftlh" as ui>
<#import "searchbar.ftlh" as sb>

<link rel="stylesheet" href="/css/testcases.css">
<@ui.page title="Test Cases" active="testcases">
  <div class="toolbar">
    <div class="h1">Test Cases</div>
    <@sb.searchBar actionUrl="/testcases" />
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
      <tr class="tc-row"
        data-id="${tc.id}"
        data-module="${tc.module!""}"
        data-title="${tc.name!""}"
        data-description="${tc.description!""}"
        data-steps="${(tc.testSteps!"")?replace('\r\n','\n')?replace('\n','\\n')}"
        data-expected="${(tc.expectedResults!"")?replace('\r\n','\n')?replace('\n','\\n')}">
              <td>${tc.id}</td>
              <td>${tc.name}</td>
              <td>${tc.description!""}</td>
              <td>
                <#-- Safely read latest status (map may be missing) -->
                <#assign statusMap = lastStatusByCaseId!{}>
                <#assign s = statusMap[tc.id?string]!'NOT_TESTED'>
                <#assign label = (s=='NOT_TESTED')?then('Not yet tested', s?string?capitalize)>
                <span class="badge <#if s=='PASSED'>success<#elseif s=='FAILED'>danger<#elseif s=='SKIPPED'>warn</#if>">
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
  <button type="button" class="icon-btn info-btn"
    data-id="${tc.id}"
    data-module="${tc.module!""}"
    data-title="${tc.name!""}"
    data-description="${tc.description!""}"
    data-steps="${(tc.testSteps!"")?replace('\r\n','\n')?replace('\n','\\n')}"
    data-expected="${(tc.expectedResults!"")?replace('\r\n','\n')?replace('\n','\\n')}">
    <img src="/images/info_button.png" alt="Info" class="icon info-icon">
  </button>
</div>

              </td>
            </tr>
          </#list>
        </tbody>
      </table>
    </div>

    <div class="card details-panel" id="details-panel">
      <div class="h1">Test Case Details</div>
      <div class="details-body mt-12" id="details-body">
        <div class="empty-note">Select a test case to see its full details.</div>
      </div>
    </div>
  </div>

  <script>
    (function(){
      function decode(text){
        try { return (text || '').replace(/\\n/g, '\n'); } catch(e){ return text || ''; }
      }
      function renderDetails(data){
        const p = document.getElementById('details-body');
        if(!p) return;
        const module = data.module || '—';
        const title = data.title || '—';
        const desc = data.description || '—';
        const steps = decode(data.steps || '—');
        const expected = decode(data.expected || '—');
        var html = ''
          + '<div class="details">'
          +   '<div class="row"><span class="label">Module</span><span class="value">' + module + '</span></div>'
          +   '<div class="row"><span class="label">Title</span><span class="value">' + title + '</span></div>'
          +   '<div class="row block"><span class="label">Description</span><p class="block-text">' + desc + '</p></div>'
          +   '<div class="row block"><span class="label">Steps</span><pre class="block-pre">' + steps + '</pre></div>'
          +   '<div class="row block"><span class="label">Expected Result</span><pre class="block-pre">' + expected + '</pre></div>'
          + '</div>';
        p.innerHTML = html;
      }

      function dataFrom(el){
        return {
          id: el.getAttribute('data-id'),
          module: el.getAttribute('data-module') || '',
          title: el.getAttribute('data-title') || '',
          description: el.getAttribute('data-description') || '',
          steps: el.getAttribute('data-steps') || '',
          expected: el.getAttribute('data-expected') || ''
        };
      }

      // Row click
      document.querySelectorAll('tr.tc-row').forEach(function(row){
        row.addEventListener('click', function(e){
          // Ignore if clicking on a link or button inside actions
          const t = e.target;
          if(t.closest && t.closest('.action-icons')) return;
          renderDetails(dataFrom(row));
        });
      });

      // Info button click
      document.querySelectorAll('.info-btn').forEach(function(btn){
        btn.addEventListener('click', function(e){
          e.preventDefault();
          e.stopPropagation();
          renderDetails(dataFrom(btn));
        });
      });
    })();
  </script>
</@ui.page>
