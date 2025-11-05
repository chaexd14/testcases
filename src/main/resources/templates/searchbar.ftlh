<#macro searchBar actionUrl placeholder="Search test cases..." queryParam="q">
  <form class="search-bar" method="get" action="${actionUrl}">
    <input
      type="text"
      name="${queryParam}"
      value="${q!""}"
      placeholder="${placeholder}"
      class="search-input"
    >
    <button type="submit" class="btn search-btn icon-only" aria-label="Search">
      <img src="/images/search_button.png" alt="" class="icon" />
    </button>
  </form>
</#macro>
