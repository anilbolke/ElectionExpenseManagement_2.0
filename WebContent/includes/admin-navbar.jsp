<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.election.i18n.MessageBundle" %>
<%@ page import="com.election.model.User" %>
<%
    User navUser = (User) session.getAttribute("user");
    String currentPage = request.getRequestURI();
%>

<style>
.multilang-navbar {
    background: white;
    box-shadow: 0 1px 3px rgba(0,0,0,0.08);
    position: sticky;
    top: 0;
    z-index: 100;
}

.multilang-navbar-content {
    padding: 8px 15px;
    display: flex;
    justify-content: space-between;
    align-items: center;
    gap: 10px;
    flex-wrap: wrap;
}

.multilang-navbar-brand {
    font-size: 1.1rem;
    font-weight: 700;
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    font-family: 'Inter', 'Noto Sans Devanagari', sans-serif;
}

.multilang-navbar-menu {
    display: flex;
    list-style: none;
    gap: 3px;
    flex-wrap: wrap;
}

.multilang-navbar-menu a {
    color: #4a5568;
    text-decoration: none;
    padding: 5px 10px;
    border-radius: 5px;
    transition: all 0.2s;
    font-weight: 500;
    font-size: 12px;
    font-family: 'Inter', 'Noto Sans Devanagari', sans-serif;
}

.multilang-navbar-menu a:hover,
.multilang-navbar-menu a.active {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    color: white;
}

.multilang-user-section {
    display: flex;
    align-items: center;
    gap: 10px;
}

.multilang-user-info {
    display: flex;
    align-items: center;
    gap: 8px;
    padding: 5px 12px;
    background: #f7fafc;
    border-radius: 6px;
    font-family: 'Inter', 'Noto Sans Devanagari', sans-serif;
}

.multilang-user-avatar {
    width: 28px;
    height: 28px;
    border-radius: 50%;
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    color: white;
    display: flex;
    align-items: center;
    justify-content: center;
    font-weight: 700;
    font-size: 12px;
}

.multilang-user-info span {
    font-weight: 500;
    font-size: 12px;
    color: #2d3748;
}

.btn-logout {
    padding: 5px 12px;
    background: #e53e3e;
    color: white;
    border: none;
    border-radius: 5px;
    cursor: pointer;
    font-weight: 500;
    font-size: 12px;
    text-decoration: none;
    transition: background 0.2s;
    font-family: 'Inter', 'Noto Sans Devanagari', sans-serif;
}

.btn-logout:hover {
    background: #c53030;
}

@media (max-width: 768px) {
    .multilang-navbar-content {
        flex-direction: column;
        align-items: flex-start;
    }
    
    .multilang-navbar-menu {
        width: 100%;
    }
}
</style>

<nav class="multilang-navbar">
    <div class="multilang-navbar-content">
        <div class="multilang-navbar-brand">
            🗳️ <%= MessageBundle.getMessage(request, "app.title") %>
        </div>
        
        <ul class="multilang-navbar-menu">
            <li><a href="<%= request.getContextPath() %>/admin/dashboard.jsp" 
                   class="<%= currentPage.contains("dashboard") ? "active" : "" %>">
                <%= MessageBundle.getMessage(request, "nav.dashboard") %>
            </a></li>
            <li><a href="<%= request.getContextPath() %>/admin/view-users.jsp"
                   class="<%= currentPage.contains("user") ? "active" : "" %>">
                <%= MessageBundle.getMessage(request, "admin.users") %>
            </a></li>
            <li><a href="<%= request.getContextPath() %>/admin/view-candidates.jsp"
                   class="<%= currentPage.contains("candidate") ? "active" : "" %>">
                <%= MessageBundle.getMessage(request, "admin.candidates") %>
            </a></li>
            <li><a href="<%= request.getContextPath() %>/admin/view-brokers.jsp"
                   class="<%= currentPage.contains("broker") ? "active" : "" %>">
                <%= MessageBundle.getMessage(request, "admin.brokers") %>
            </a></li>
            <li><a href="<%= request.getContextPath() %>/admin/manage-payments.jsp"
                   class="<%= currentPage.contains("payment") ? "active" : "" %>">
                <%= MessageBundle.getMessage(request, "nav.payments") %>
            </a></li>
        </ul>
        
        <div class="multilang-user-section">
            <!-- Language Selector -->
            <jsp:include page="/includes/language-selector.jsp" />
            
            <!-- User Info -->
            <% if (navUser != null) { %>
            <div class="multilang-user-info">
                <div class="multilang-user-avatar">
                    <%= navUser.getFullName().substring(0, 1).toUpperCase() %>
                </div>
                <span><%= navUser.getFullName() %></span>
            </div>
            <a href="<%= request.getContextPath() %>/logout" class="btn-logout">
                <%= MessageBundle.getMessage(request, "app.logout") %>
            </a>
            <% } %>
        </div>
    </div>
</nav>
