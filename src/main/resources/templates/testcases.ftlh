<#import "layout.ftlh" as ui>
<#import "searchbar.ftlh" as sb>

<link rel="stylesheet" href="/css/testcases.css">
<@ui.page title="Test Cases" active="testcases">
  <div class="toolbar">
  <div class="h1">Test Cases</div>
  <@sb.searchBar actionUrl="/testcases" />
  <div class="toolbar-actions">
    <a class="btn secondary" href="/testcases/export/csv<#if q??>?q=${q?url}</#if>">Export CSV</a>
    <a class="btn" href="/testcases/new">Add Test Case</a>
  </div>
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
  <button type="button" class="icon-btn edit-btn"
          data-id="${tc.id}"
          data-module="${tc.module!""}"
          data-title="${tc.name!""}"
          data-description="${tc.description!""}"
          data-steps="${(tc.testSteps!"")?replace('\r\n','\n')?replace('\n','\\n')}"
          data-expected="${(tc.expectedResults!"")?replace('\r\n','\n')?replace('\n','\\n')}">
    <img src="/images/edit_button.png" alt="Edit" class="icon edit-icon">
  </button>
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
      function encode(text){
        try { return (text || '').replace(/\n/g, '\\n'); } catch(e){ return text || ''; }
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

      function renderEditForm(data){
        const p = document.getElementById('details-body');
        if(!p) return;
        var html = ''
          + '<form id="edit-form" class="form">'
          +   '<div class="row"><span class="label">Module</span><input id="edit-module" class="input" type="text"></div>'
          +   '<div class="row"><span class="label">Title</span><input id="edit-title" class="input" type="text"></div>'
          +   '<div class="row block"><span class="label">Description</span><textarea id="edit-description" class="textarea"></textarea></div>'
          +   '<div class="row block"><span class="label">Steps</span><textarea id="edit-steps" class="textarea"></textarea></div>'
          +   '<div class="row block"><span class="label">Expected Result</span><textarea id="edit-expected" class="textarea"></textarea></div>'
          +   '<div class="form actions">'
          +     '<button type="button" id="btn-cancel" class="btn secondary">Cancel</button>'
          +     '<button type="submit" id="btn-save" class="btn">Save</button>'
          +   '</div>'
          + '</form>';
        p.innerHTML = html;
        // populate values safely via JS
        var m = document.getElementById('edit-module');
        var t = document.getElementById('edit-title');
        var d = document.getElementById('edit-description');
        var s = document.getElementById('edit-steps');
        var e = document.getElementById('edit-expected');
        if(m) m.value = data.module || '';
        if(t) t.value = data.title || '';
        if(d) d.value = data.description || '';
        if(s) s.value = decode(data.steps || '');
        if(e) e.value = decode(data.expected || '');

        var form = document.getElementById('edit-form');
        if(form){
          form.addEventListener('submit', function(evt){
            evt.preventDefault();
            var payload = {
              id: data.id ? parseInt(data.id, 10) : null,
              name: (t && t.value) || '',
              module: (m && m.value) || '',
              description: (d && d.value) || '',
              testSteps: (s && s.value) || '',
              expectedResults: (e && e.value) || ''
            };
            if(!payload.id){ return; }
            fetch('/api/testcases/' + payload.id, {
              method: 'PUT',
              headers: { 'Content-Type': 'application/json' },
              body: JSON.stringify(payload)
            }).then(function(res){
              if(!res.ok) throw new Error('Failed to save');
              return res.json();
            }).then(function(saved){
              // update row dataset and cells
              var row = document.querySelector('tr.tc-row[data-id="' + payload.id + '"]');
              if(row){
                row.setAttribute('data-module', saved.module || '');
                row.setAttribute('data-title', saved.name || '');
                row.setAttribute('data-description', saved.description || '');
                row.setAttribute('data-steps', encode(saved.testSteps || ''));
                row.setAttribute('data-expected', encode(saved.expectedResults || ''));
                var cells = row.querySelectorAll('td');
                if(cells && cells.length >= 3){
                  cells[1].textContent = saved.name || '';
                  cells[2].textContent = saved.description || '';
                }
              }
              // render detail view with updated values
              renderDetails({
                id: String(saved.id),
                module: saved.module || '',
                title: saved.name || '',
                description: saved.description || '',
                steps: encode(saved.testSteps || ''),
                expected: encode(saved.expectedResults || '')
              });
            }).catch(function(err){
              alert('Save failed. Please try again.');
              console.error(err);
            });
          });
        }
        var cancel = document.getElementById('btn-cancel');
        if(cancel){
          cancel.addEventListener('click', function(){ renderDetails(data); });
        }
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

      // Edit button click
      document.querySelectorAll('.edit-btn').forEach(function(btn){
        btn.addEventListener('click', function(e){
          e.preventDefault();
          e.stopPropagation();
          var data = dataFrom(btn);
          if(!data.id){ return; }
          renderEditForm(data);
        });
      });
    })();
  </script>
</@ui.page>
