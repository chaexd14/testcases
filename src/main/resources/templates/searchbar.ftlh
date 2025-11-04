<#macro searchBar actionUrl placeholder="Search test cases..." queryParam="q">
  <form class="search-bar" method="get" action="${actionUrl}">
    <input
      type="text"
      name="${queryParam}"
      value="${q!""}"
      placeholder="${placeholder}"
      class="search-input"
    >
    <button type="submit" class="btn search-btn">Search</button>
  </form>
</#macro>
