<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.election.util.PaginationUtil" %>
<%
    // Get pagination object from request attribute
    PaginationUtil paginationObj = (PaginationUtil) request.getAttribute("pagination");
    String paginationUrl = (String) request.getAttribute("paginationBaseUrl");
    
    if (paginationObj == null || paginationUrl == null) {
        return; // Don't render if pagination not set
    }
    
    // Check if paginationUrl already has parameters
    String separator = paginationUrl.contains("?") ? "&" : "?";
%>

<div class="pagination-container">
    <div class="pagination-info">
        Showing <strong><%= paginationObj.getStartRecord() %></strong> to 
        <strong><%= paginationObj.getEndRecord() %></strong> of 
        <strong><%= paginationObj.getTotalRecords() %></strong> records
    </div>
    
    <% if (paginationObj.getTotalPages() > 1) { %>
    <div class="pagination">
        <!-- First Page -->
        <% if (paginationObj.showFirstPage()) { %>
            <a href="<%= paginationUrl %><%= separator %>page=1" class="first-last" title="First Page">⟨⟨</a>
        <% } %>
        
        <!-- Previous Page -->
        <% if (paginationObj.hasPrevious()) { %>
            <a href="<%= paginationUrl %><%= separator %>page=<%= paginationObj.getPreviousPage() %>" title="Previous Page">‹</a>
        <% } else { %>
            <span class="disabled">‹</span>
        <% } %>
        
        <!-- Page Numbers -->
        <% 
        int[] pageNumbers = paginationObj.getPageNumbers();
        int prevPage = 0;
        for (int pageNum : pageNumbers) { 
            // Show ellipsis if there's a gap
            if (prevPage > 0 && pageNum > prevPage + 1) {
        %>
                <span class="ellipsis">...</span>
        <% 
            }
            
            if (pageNum == paginationObj.getCurrentPage()) { 
        %>
                <span class="current"><%= pageNum %></span>
        <% 
            } else { 
        %>
                <a href="<%= paginationUrl %><%= separator %>page=<%= pageNum %>"><%= pageNum %></a>
        <% 
            }
            prevPage = pageNum;
        } 
        %>
        
        <!-- Next Page -->
        <% if (paginationObj.hasNext()) { %>
            <a href="<%= paginationUrl %><%= separator %>page=<%= paginationObj.getNextPage() %>" title="Next Page">›</a>
        <% } else { %>
            <span class="disabled">›</span>
        <% } %>
        
        <!-- Last Page -->
        <% if (paginationObj.showLastPage()) { %>
            <a href="<%= paginationUrl %><%= separator %>page=<%= paginationObj.getLastPage() %>" class="first-last" title="Last Page">⟩⟩</a>
        <% } %>
    </div>
    <% } %>
    
    <!-- Page Size Selector -->
    <div class="page-size-selector">
        <label for="pageSize">Show:</label>
        <select id="pageSize" onchange="changePageSize(this.value)">
            <option value="10" <%= paginationObj.getPageSize() == 10 ? "selected" : "" %>>10</option>
            <option value="25" <%= paginationObj.getPageSize() == 25 ? "selected" : "" %>>25</option>
            <option value="50" <%= paginationObj.getPageSize() == 50 ? "selected" : "" %>>50</option>
            <option value="100" <%= paginationObj.getPageSize() == 100 ? "selected" : "" %>>100</option>
        </select>
    </div>
</div>

<script>
function changePageSize(newSize) {
    var currentUrl = window.location.href;
    var url = new URL(currentUrl);
    
    // Update or add pageSize parameter
    url.searchParams.set('pageSize', newSize);
    
    // Reset to page 1 when changing page size
    url.searchParams.set('page', '1');
    
    // Navigate to new URL
    window.location.href = url.toString();
}
</script>
