<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.election.i18n.MessageBundle" %>
<%@ page import="com.election.model.*, com.election.dao.*, java.util.List, java.math.BigDecimal" %>
<%
    // Authentication check
    User user = (User) session.getAttribute("user");
    if (user == null || !"user".equals(user.getUserRole())) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }
    
    // Get user's candidates
    CandidateDAO candidateDAO = new CandidateDAO();
    List<Candidate> allCandidates = candidateDAO.getCandidatesByUserId(user.getUserId());
    
    // Pagination parameters
    int pageSize = 5; // Show 5 candidates per page
    int currentPage = 1;
    String pageParam = request.getParameter("page");
    if (pageParam != null) {
        try {
            currentPage = Integer.parseInt(pageParam);
        } catch (NumberFormatException e) {
            currentPage = 1;
        }
    }
    
    // Calculate pagination
    int totalCandidates = allCandidates != null ? allCandidates.size() : 0;
    int totalPages = (int) Math.ceil((double) totalCandidates / pageSize);
    if (currentPage < 1) currentPage = 1;
    if (currentPage > totalPages && totalPages > 0) currentPage = totalPages;
    
    int startIndex = (currentPage - 1) * pageSize;
    int endIndex = Math.min(startIndex + pageSize, totalCandidates);
    
    // Get candidates for current page
    List<Candidate> myCandidates = null;
    if (allCandidates != null && !allCandidates.isEmpty()) {
        myCandidates = allCandidates.subList(startIndex, endIndex);
    }
    
    // Get currently selected candidate (if any)
    Candidate selectedCandidate = (Candidate) session.getAttribute("candidate");
    
    // Calculate statistics based on selected candidate or all candidates
    int activeCandidates = 0;
    int pendingPayments = 0;
    BigDecimal totalExpenses = BigDecimal.ZERO;
    boolean isFilteredByCandidate = (selectedCandidate != null);
    
    if (isFilteredByCandidate) {
        // Show stats for selected candidate only
        ExpenseDAO expenseDAO = new ExpenseDAO();
        totalCandidates = 1; // Only one candidate selected
        
        if (selectedCandidate.isPaymentVerified() && "active".equals(selectedCandidate.getAccountStatus())) {
            activeCandidates = 1;
        } else {
            pendingPayments = 1;
        }
        
        try {
            BigDecimal candidateExpenses = expenseDAO.getTotalExpensesByCandidate(selectedCandidate.getCandidateId());
            if (candidateExpenses != null) {
                totalExpenses = candidateExpenses;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    } else {
        // Show stats for all candidates
        List<Candidate> candidatesForStats = allCandidates;
        
        if (candidatesForStats != null) {
            ExpenseDAO expenseDAO = new ExpenseDAO();
            for (Candidate c : candidatesForStats) {
                if (c.isPaymentVerified() && "active".equals(c.getAccountStatus())) {
                    activeCandidates++;
                    try {
                        BigDecimal candidateExpenses = expenseDAO.getTotalExpensesByCandidate(c.getCandidateId());
                        if (candidateExpenses != null) {
                            totalExpenses = totalExpenses.add(candidateExpenses);
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                } else {
                    pendingPayments++;
                }
            }
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= MessageBundle.getMessage(request, "user.dashboard") %> - <%= MessageBundle.getMessage(request, "app.title") %></title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+Devanagari:wght@400;700&display=swap" rel="stylesheet">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { 
            font-family: 'Inter', 'Noto Sans Devanagari', 'Segoe UI', sans-serif; 
            background: #f5f7fa;
            font-size: 13px;
            color: #2d3748;
            height: 100vh;
            overflow: hidden;
        }
        
        /* Compact Navigation */
        .navbar {
            background: white;
            box-shadow: 0 1px 3px rgba(0,0,0,0.08);
            position: sticky;
            top: 0;
            z-index: 100;
        }
        .navbar-content {
            padding: 8px 15px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 10px;
        }
        .navbar-brand {
            font-size: 1.1rem;
            font-weight: 700;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }
        .navbar-menu {
            display: flex;
            list-style: none;
            gap: 3px;
        }
        .navbar-menu a {
            color: #4a5568;
            text-decoration: none;
            padding: 5px 10px;
            border-radius: 5px;
            transition: all 0.2s;
            font-weight: 500;
            font-size: 12px;
        }
        .navbar-menu a:hover, .navbar-menu a.active {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        .user-info {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 12px;
        }
        .user-avatar {
            width: 28px;
            height: 28px;
            border-radius: 50%;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 600;
            font-size: 11px;
        }
        
        /* Main Container */
        .main-container {
            height: calc(100vh - 45px);
            overflow-y: auto;
            padding: 12px;
        }
        
        /* Compact Grid Layout */
        .dashboard-grid {
            display: grid;
            grid-template-columns: 250px 1fr;
            gap: 12px;
            height: 100%;
        }
        
        /* Left Sidebar */
        .sidebar {
            display: flex;
            flex-direction: column;
            gap: 10px;
        }
        
        /* Stats Compact */
        .stats-compact {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 8px;
        }
        .stat-mini {
            background: white;
            padding: 12px;
            border-radius: 8px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.06);
            border-left: 3px solid;
        }
        .stat-mini:nth-child(1) { border-left-color: #667eea; }
        .stat-mini:nth-child(2) { border-left-color: #48bb78; }
        .stat-mini:nth-child(3) { border-left-color: #ed8936; }
        .stat-mini:nth-child(4) { border-left-color: #f56565; }
        .stat-mini h4 {
            font-size: 10px;
            color: #718096;
            text-transform: uppercase;
            font-weight: 600;
            margin-bottom: 4px;
            letter-spacing: 0.3px;
        }
        .stat-mini .value {
            font-size: 1.4rem;
            font-weight: 700;
            color: #1a202c;
        }
        
        /* Quick Actions */
        .quick-actions-compact {
            background: white;
            padding: 12px;
            border-radius: 8px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.06);
        }
        .quick-actions-compact h3 {
            font-size: 13px;
            font-weight: 700;
            margin-bottom: 10px;
            color: #1a202c;
        }
        .action-btn {
            display: block;
            padding: 8px 12px;
            margin-bottom: 6px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            text-decoration: none;
            border-radius: 6px;
            font-size: 12px;
            font-weight: 600;
            text-align: center;
            transition: all 0.2s;
        }
        .action-btn:hover {
            transform: translateY(-1px);
            box-shadow: 0 4px 8px rgba(102, 126, 234, 0.3);
        }
        .action-btn.secondary {
            background: #48bb78;
        }
        
        /* Toggle Button */
        .toggle-btn {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            border-radius: 6px;
            width: 32px;
            height: 32px;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            font-size: 18px;
            font-weight: 700;
            transition: all 0.3s ease;
            box-shadow: 0 2px 4px rgba(102, 126, 234, 0.2);
        }
        
        .toggle-btn:hover {
            transform: scale(1.1);
            box-shadow: 0 4px 8px rgba(102, 126, 234, 0.4);
        }
        
        .toggle-btn:active {
            transform: scale(0.95);
        }
        
        #quickActionsContent {
            max-height: 1000px;
            overflow: hidden;
            transition: max-height 0.4s ease, opacity 0.3s ease;
            opacity: 1;
        }
        
        #quickActionsContent.collapsed {
            max-height: 0;
            opacity: 0;
        }
        
        /* Main Content Area */
        .main-content {
            background: white;
            border-radius: 8px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.06);
            padding: 15px;
            overflow-y: auto;
            max-height: calc(100vh - 70px);
        }
        .content-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 12px;
            padding-bottom: 10px;
            border-bottom: 2px solid #f0f0f0;
        }
        .content-header h2 {
            font-size: 1.2rem;
            font-weight: 700;
            color: #1a202c;
        }
        
        /* Compact Buttons */
        .btn {
            display: inline-flex;
            align-items: center;
            gap: 5px;
            padding: 6px 12px;
            border-radius: 6px;
            text-decoration: none;
            font-weight: 600;
            transition: all 0.2s;
            border: none;
            cursor: pointer;
            font-size: 12px;
        }
        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        .btn-success {
            background: #48bb78;
            color: white;
        }
        .btn-warning {
            background: #ed8936;
            color: white;
        }
        .btn-danger {
            background: #f56565;
            color: white;
        }
        .btn-outline {
            background: white;
            color: #667eea;
            border: 1px solid #667eea;
        }
        .btn:hover {
            transform: translateY(-1px);
            box-shadow: 0 2px 6px rgba(0,0,0,0.15);
        }
        .btn-sm {
            padding: 4px 8px;
            font-size: 11px;
        }
        
        /* Compact Alerts */
        .alert {
            padding: 8px 12px;
            border-radius: 6px;
            margin-bottom: 10px;
            border-left: 3px solid;
            font-size: 12px;
            line-height: 1.4;
        }
        .alert-success { background: #f0fdf4; color: #22543d; border-left-color: #48bb78; }
        .alert-info { background: #eff6ff; color: #1e3a8a; border-left-color: #3b82f6; }
        .alert-warning { background: #fffbeb; color: #78350f; border-left-color: #f59e0b; }
        .alert-danger { background: #fef2f2; color: #991b1b; border-left-color: #ef4444; }
        .alert-critical { background: #7f1d1d; color: #fff; border-left-color: #dc2626; font-weight: 600; }
        
        /* Fund Alert Box */
        .fund-alert-box {
            padding: 12px;
            border-radius: 8px;
            margin-bottom: 15px;
            display: none;
            animation: slideIn 0.3s ease-out;
        }
        @keyframes slideIn {
            from { opacity: 0; transform: translateY(-10px); }
            to { opacity: 1; transform: translateY(0); }
        }
        @keyframes pulse {
            0%, 100% { opacity: 1; }
            50% { opacity: 0.85; }
        }
        .fund-alert-header {
            display: flex;
            align-items: center;
            gap: 8px;
            margin-bottom: 8px;
            font-weight: 700;
            font-size: 13px;
        }
        .fund-alert-details {
            font-size: 12px;
            line-height: 1.6;
        }
        .fund-stats-row {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 10px;
            margin-top: 8px;
        }
        .fund-stat-item {
            background: rgba(255,255,255,0.5);
            padding: 6px;
            border-radius: 4px;
            text-align: center;
        }
        .fund-stat-label {
            font-size: 10px;
            opacity: 0.8;
            text-transform: uppercase;
        }
        .fund-stat-value {
            font-size: 14px;
            font-weight: 700;
            margin-top: 2px;
        }
        .progress-bar {
            width: 100%;
            height: 20px;
            background: rgba(255,255,255,0.3);
            border-radius: 10px;
            overflow: hidden;
            margin-top: 8px;
            position: relative;
        }
        .progress-fill {
            height: 100%;
            transition: width 0.5s ease;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 11px;
            font-weight: 700;
        }
        
        /* Compact Candidate Cards */
        .candidates-list {
            margin-top: 15px;
        }
        
        /* Table Styles */
        .candidates-table-wrapper {
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.07), 0 1px 3px rgba(0,0,0,0.06);
            overflow: hidden;
            border: 1px solid #e2e8f0;
        }
        
        .candidates-table {
            width: 100%;
            border-collapse: collapse;
            font-size: 13px;
        }
        
        .candidates-table thead {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        
        .candidates-table th {
            padding: 16px 20px;
            text-align: left;
            font-weight: 700;
            font-size: 13px;
            letter-spacing: 0.5px;
            text-transform: uppercase;
            white-space: nowrap;
        }
        
        .candidates-table tbody tr {
            border-bottom: 1px solid #f1f5f9;
            transition: all 0.3s ease;
        }
        
        /* Alternating row colors */
        .candidates-table tbody tr:nth-child(odd) {
            background: linear-gradient(90deg, #ffffff 0%, #f9fafb 100%);
        }
        
        .candidates-table tbody tr:nth-child(even) {
            background: linear-gradient(90deg, #f0f9ff 0%, #e0f2fe 100%);
        }
        
        .candidates-table tbody tr:nth-child(3n) {
            background: linear-gradient(90deg, #fef3c7 0%, #fef9e7 100%);
        }
        
        .candidates-table tbody tr:nth-child(4n) {
            background: linear-gradient(90deg, #fce7f3 0%, #fdf2f8 100%);
        }
        
        .candidates-table tbody tr:nth-child(5n) {
            background: linear-gradient(90deg, #f3e8ff 0%, #faf5ff 100%);
        }
        
        .candidates-table tbody tr:hover {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%) !important;
            transform: scale(1.02);
            box-shadow: 0 4px 12px rgba(102, 126, 234, 0.3);
            color: white;
        }
        
        .candidates-table tbody tr:hover .candidate-name-main,
        .candidates-table tbody tr:hover .candidate-details,
        .candidates-table tbody tr:hover .detail-item {
            color: white !important;
        }
        
        .candidates-table tbody tr:hover .nomination-id {
            background: rgba(255, 255, 255, 0.3);
            color: white;
            border-color: rgba(255, 255, 255, 0.5);
        }
        
        .candidates-table tbody tr:hover .badge {
            background: rgba(255, 255, 255, 0.9) !important;
            border-color: white !important;
        }
        
        .candidates-table tbody tr.selected-row {
            background: linear-gradient(135deg, #10b981 0%, #059669 100%) !important;
            border-left: 4px solid #047857;
            box-shadow: 0 0 0 1px #34d399 inset;
            color: white;
        }
        
        .candidates-table tbody tr.selected-row .candidate-name-main,
        .candidates-table tbody tr.selected-row .candidate-details,
        .candidates-table tbody tr.selected-row .detail-item {
            color: white !important;
        }
        
        .candidates-table tbody tr.selected-row .nomination-id {
            background: rgba(255, 255, 255, 0.3);
            color: white;
            border-color: rgba(255, 255, 255, 0.5);
        }
        
        .candidates-table tbody tr.selected-row .badge {
            background: rgba(255, 255, 255, 0.9) !important;
            color: #047857 !important;
            border-color: white !important;
        }
        
        .candidates-table tbody tr.selected-row:hover {
            background: linear-gradient(135deg, #059669 0%, #047857 100%) !important;
            box-shadow: 0 4px 12px rgba(16, 185, 129, 0.4);
        }
        
        .candidates-table tbody tr:last-child {
            border-bottom: none;
        }
        
        .candidates-table td {
            padding: 16px 20px;
            vertical-align: middle;
        }
        
        .candidate-name-cell {
            color: #1a202c;
        }
        
        .candidate-name-main {
            font-weight: 700;
            font-size: 16px;
            margin-bottom: 8px;
            color: #1e293b;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .candidate-name-cell .nomination-id {
            font-size: 11px;
            color: #6366f1;
            font-weight: 600;
            padding: 4px 10px;
            background: linear-gradient(135deg, #e0e7ff 0%, #ddd6fe 100%);
            border-radius: 12px;
            border: 1px solid #c7d2fe;
            box-shadow: 0 1px 2px rgba(99, 102, 241, 0.1);
            letter-spacing: 0.3px;
        }
        
        .candidate-details {
            font-size: 12px;
            color: #64748b;
            display: flex;
            align-items: center;
            gap: 10px;
            flex-wrap: wrap;
            margin-top: 4px;
        }
        
        .detail-item {
            display: inline-flex;
            align-items: center;
            gap: 4px;
            padding: 2px 0;
        }
        
        .detail-separator {
            color: #cbd5e0;
            font-weight: 300;
        }
        
        .candidate-actions-table {
            display: flex;
            gap: 8px;
            flex-wrap: wrap;
            justify-content: center;
        }
        
        .candidate-actions-table .btn {
            font-size: 12px;
            font-weight: 600;
            padding: 8px 16px;
            border-radius: 8px;
            transition: all 0.2s ease;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
            text-decoration: none;
            display: inline-block;
        }
        
        .candidate-actions-table .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.25);
        }
        
        .candidate-actions-table .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
        }
        
        .candidate-actions-table .btn-primary:hover {
            background: linear-gradient(135deg, #5568d3 0%, #6a4193 100%);
        }
        
        .candidate-actions-table .btn-success {
            background: linear-gradient(135deg, #10b981 0%, #059669 100%);
            color: white;
            border: none;
        }
        
        .candidate-actions-table .btn-success:hover {
            background: linear-gradient(135deg, #059669 0%, #047857 100%);
        }
        
        .candidate-actions-table .btn-warning {
            background: linear-gradient(135deg, #f59e0b 0%, #d97706 100%);
            color: white;
            border: none;
        }
        
        .candidate-actions-table .btn-warning:hover {
            background: linear-gradient(135deg, #d97706 0%, #b45309 100%);
        }
        
        .candidate-actions-table .btn-outline {
            background: white;
            border: 2px solid #e2e8f0;
            color: #64748b;
        }
        
        .candidate-actions-table .btn-outline:hover {
            border-color: #667eea;
            color: white;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }
        
        /* Buttons on hover row */
        .candidates-table tbody tr:hover .candidate-actions-table .btn {
            box-shadow: 0 2px 6px rgba(0,0,0,0.3);
        }
        
        /* Badges */
        .badge {
            display: inline-flex;
            align-items: center;
            padding: 4px 10px;
            border-radius: 14px;
            font-size: 10px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            box-shadow: 0 1px 2px rgba(0,0,0,0.05);
        }
        .badge-success { 
            background: linear-gradient(135deg, #d1fae5 0%, #a7f3d0 100%);
            color: #065f46;
            border: 1px solid #6ee7b7;
        }
        .badge-warning { 
            background: linear-gradient(135deg, #fed7aa 0%, #fcd34d 100%);
            color: #78350f;
            border: 1px solid #fbbf24;
        }
        .badge-danger { 
            background: linear-gradient(135deg, #fecaca 0%, #fca5a5 100%);
            color: #991b1b;
            border: 1px solid #f87171;
        }
        
        /* Empty State */
        .empty-state {
            text-align: center;
            padding: 40px 20px;
            color: #718096;
        }
        .empty-state .icon {
            font-size: 3rem;
            margin-bottom: 12px;
        }
        
        /* Scrollbar */
        ::-webkit-scrollbar { width: 6px; height: 6px; }
        ::-webkit-scrollbar-track { background: #f1f1f1; }
        ::-webkit-scrollbar-thumb { background: #cbd5e0; border-radius: 3px; }
        ::-webkit-scrollbar-thumb:hover { background: #a0aec0; }
        
        /* Responsive */
        @media (max-width: 1024px) {
            .dashboard-grid {
                grid-template-columns: 1fr;
            }
            .sidebar {
                grid-template-columns: repeat(2, 1fr);
                display: grid;
            }
            .stats-compact {
                grid-template-columns: repeat(4, 1fr);
            }
        }
        
        @media (max-width: 768px) {
            body {
                font-size: 14px;
            }
            
            /* Hide menu, show mobile-friendly layout */
            .navbar-menu { display: none; }
            
            /* Navbar adjustments */
            .navbar-content {
                padding: 12px 15px;
            }
            
            .navbar-brand {
                font-size: 1.1rem;
            }
            
            .user-info {
                gap: 8px;
            }
            
            /* Stats grid */
            .stats-compact { 
                grid-template-columns: 1fr 1fr;
                gap: 10px;
            }
            
            .stat-card {
                padding: 15px 12px;
            }
            
            .stat-card .stat-value {
                font-size: 1.5rem;
            }
            
            .stat-card .stat-label {
                font-size: 11px;
            }
            
            /* Sidebar */
            .sidebar { 
                grid-template-columns: 1fr;
                gap: 12px;
            }
            
            /* Container adjustments */
            .main-container {
                padding: 0;
                margin: 0;
            }
            
            .dashboard-content {
                padding: 15px 12px;
                margin: 0;
                border-radius: 0;
                box-shadow: none;
            }
            
            /* Content header */
            .content-header {
                flex-direction: column;
                align-items: stretch;
                gap: 12px;
                margin-bottom: 15px;
            }
            
            .content-header h2 {
                font-size: 1.3rem;
                margin: 0;
            }
            
            .content-header .btn {
                width: 100%;
                text-align: center;
                padding: 12px;
                font-size: 14px;
            }
            
            /* Keep table as table with horizontal scroll */
            .candidates-table-wrapper {
                overflow-x: auto;
                -webkit-overflow-scrolling: touch;
                background: white;
                box-shadow: 0 2px 8px rgba(0,0,0,0.1);
                border-radius: 8px;
                border: 1px solid #e2e8f0;
            }
            
            .candidates-table {
                display: table;
                width: 100%;
                min-width: 800px; /* Minimum width to trigger horizontal scroll */
            }
            
            /* Keep table header visible */
            .candidates-table thead {
                display: table-header-group;
            }
            
            .candidates-table tbody {
                display: table-row-group;
            }
            
            /* Keep rows as table rows */
            .candidates-table tbody tr {
                display: table-row;
            }
            
            /* Keep table cells as table cells */
            .candidates-table td {
                display: table-cell;
                padding: 12px 8px;
                border-bottom: 1px solid #e2e8f0;
                font-size: 12px;
                white-space: nowrap;
            }
            
            /* Selected row styling */
            .candidates-table tbody tr.selected-row {
                background: #d1fae5 !important;
            }
            
            /* Compact candidate name for mobile */
            .candidate-name-main {
                font-size: 13px;
            }
            
            .candidate-name-cell .nomination-id {
                font-size: 10px;
                padding: 2px 6px;
            }
            
            /* Compact candidate details for mobile */
            .candidate-details {
                font-size: 11px;
                gap: 4px;
            }
            
            .detail-item {
                font-size: 11px;
            }
            
            /* Action buttons - compact for mobile */
            .candidate-actions-table {
                display: flex;
                flex-wrap: wrap;
                gap: 4px;
            }
            
            .candidate-actions-table .btn {
                padding: 8px 10px;
                font-size: 11px;
                font-weight: 600;
                white-space: nowrap;
                border-radius: 8px;
            }
            
            .candidate-actions-table .btn:nth-child(3) {
                grid-column: 1 / -1;
            }
            
            /* Badges - larger on mobile */
            .badge {
                font-size: 10px;
                padding: 5px 10px;
            }
            
            /* Pagination - Enhanced for mobile */
            .pagination-container {
                display: block !important;
                padding: 20px 12px;
                background: white;
                margin: 15px 0 0 0;
                border-radius: 8px;
                box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            }
            
            .pagination {
                display: flex !important;
                gap: 8px;
                flex-wrap: wrap;
                justify-content: center;
                align-items: center;
            }
            
            .page-link {
                display: inline-flex !important;
                align-items: center;
                justify-content: center;
                padding: 10px 12px;
                font-size: 13px;
                font-weight: 600;
                min-width: 44px;
                min-height: 44px;
                background: white;
                border: 2px solid #e2e8f0;
                border-radius: 8px;
                color: #4a5568;
                text-decoration: none;
                text-align: center;
                box-sizing: border-box;
            }
            
            .page-link.active {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                border-color: #667eea;
            }
            
            .page-ellipsis {
                display: inline-flex;
                align-items: center;
                justify-content: center;
                padding: 10px 6px;
                font-size: 13px;
                min-height: 44px;
                color: #a0aec0;
                font-weight: 600;
            }
            
            /* Pagination info text */
            .pagination-container > div:last-child {
                margin-top: 12px;
                font-size: 13px !important;
                color: #718096;
                text-align: center;
            }
            
            /* Empty state */
            .empty-state {
                padding: 50px 20px;
            }
            
            .empty-state .icon {
                font-size: 4rem;
            }
            
            .empty-state h3 {
                font-size: 1.1rem;
            }
            
            /* Hover effects disabled on mobile */
            .candidates-table tbody tr:hover {
                transform: none !important;
                box-shadow: 0 2px 8px rgba(0,0,0,0.1) !important;
            }
        }
        
        /* Pagination Styles */
        .pagination-container {
            margin-top: 20px;
            padding: 15px;
        }
        
        .pagination {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 8px;
            flex-wrap: wrap;
        }
        
        .page-link {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            padding: 8px 14px;
            background: white;
            border: 1px solid #e2e8f0;
            border-radius: 6px;
            color: #4a5568;
            text-decoration: none;
            font-size: 13px;
            font-weight: 600;
            transition: all 0.2s;
            min-width: 40px;
            text-align: center;
            box-sizing: border-box;
        }
        
        .page-link:hover {
            background: #f7fafc;
            border-color: #667eea;
            color: #667eea;
            transform: translateY(-1px);
        }
        
        .page-link.active {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-color: #667eea;
        }
        
        .page-link.active:hover {
            background: linear-gradient(135deg, #764ba2 0%, #667eea 100%);
            transform: translateY(-1px);
        }
        
        .page-ellipsis {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            padding: 8px 4px;
            color: #a0aec0;
            font-weight: 600;
            min-width: 30px;
        }
    </style>
</head>
<body>
    <!-- Multi-Language Navigation -->
    <jsp:include page="/includes/user-navbar.jsp" />

    <!-- Main Container -->
    <div class="main-container">
        <div class="dashboard-grid">
            <!-- Left Sidebar -->
            <div class="sidebar">
                <!-- Compact Stats -->
                <div class="stats-compact">
                    <% if (isFilteredByCandidate) { %>
                        <!-- Candidate-specific stats -->
                        <div class="stat-mini" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white;">
                            <h4 style="color: white; font-size: 11px;">📊 Candidate Selected</h4>
                            <div class="value" style="font-size: 0.9rem;"><%= selectedCandidate.getCandidateName() %></div>
                        </div>
                        <div class="stat-mini">
                            <h4>Total Candidates</h4>
                            <div class="value">1</div>
                        </div>
                        <div class="stat-mini">
                            <h4>Active</h4>
                            <div class="value"><%= activeCandidates %></div>
                        </div>
                        <div class="stat-mini">
                            <h4>Payment Pending</h4>
                            <div class="value"><%= pendingPayments %></div>
                        </div>
                        <div class="stat-mini">
                            <h4>Total Expenses</h4>
                            <div class="value" style="font-size: 1rem;">₹<%= String.format("%.0f", totalExpenses) %></div>
                        </div>
                    <% } else { %>
                        <!-- All candidates stats -->
                        <div class="stat-mini">
                            <h4><%= MessageBundle.getMessage(request, "candidate.total") %></h4>
                            <div class="value"><%= totalCandidates %></div>
                        </div>
                        <div class="stat-mini">
                            <h4><%= MessageBundle.getMessage(request, "status.active") %></h4>
                            <div class="value"><%= activeCandidates %></div>
                        </div>
                        <div class="stat-mini">
                            <h4><%= MessageBundle.getMessage(request, "payment.pending") %></h4>
                            <div class="value"><%= pendingPayments %></div>
                        </div>
                        <div class="stat-mini">
                            <h4><%= MessageBundle.getMessage(request, "expense.total") %></h4>
                            <div class="value" style="font-size: 1rem;">₹<%= String.format("%.0f", totalExpenses) %></div>
                        </div>
                    <% } %>
                </div>
                
                <!-- Quick Actions -->
                <div class="quick-actions-compact">
                    <div style="display: flex; align-items: center; justify-content: space-between; margin-bottom: 15px;">
                        <h3 style="margin: 0;">⚡ <%= MessageBundle.getMessage(request, "action.quickactions") %></h3>
                        <button id="toggleQuickActions" class="toggle-btn" onclick="toggleQuickActions()" title="Show/Hide Quick Actions">
                            <span id="toggleIcon">−</span>
                        </button>
                    </div>
                    <div id="quickActionsContent">
                        <a href="add-candidate.jsp" class="action-btn">➕ <%= MessageBundle.getMessage(request, "candidate.add") %></a>
                        <a href="change-password.jsp" class="action-btn" style="background: #f56565;">🔒 <%= MessageBundle.getMessage(request, "user.change.password") %></a>
                        <a href="map-referral-code.jsp" class="action-btn" style="background: #667eea;">🎁 <%= MessageBundle.getMessage(request, "referral.map.title") %></a>
                        <% if (selectedCandidate != null && selectedCandidate.isPaymentVerified()) { %>
                        <a href="javascript:void(0);" onclick="openProforma1Popup(<%= selectedCandidate.getCandidateId() %>)" class="action-btn" style="background: #3182ce;">📅 Proforma-1 (Date-wise)</a>
                        <a href="javascript:void(0);" onclick="openProforma2Popup(<%= selectedCandidate.getCandidateId() %>)" class="action-btn" style="background: #f57c00;">📑 Proforma-2 (Template)</a>
                        <a href="manage-funds.jsp" class="action-btn" style="background: #48bb78;">💰 Manage Funds</a>
                        <a href="add-expense.jsp" class="action-btn secondary">💸 <%= MessageBundle.getMessage(request, "expense.add") %></a>
                        <a href="expenses.jsp" class="action-btn secondary">📊 <%= MessageBundle.getMessage(request, "expense.view") %></a>
                        <% } %>
                    </div>
                </div>
                
                <!-- Social Media Links -->
                <jsp:include page="/includes/social-media-footer.jsp" />
            </div>
            
            <!-- Main Content -->
            <div class="main-content">
                <% if (request.getParameter("success") != null) { %>
                    <div class="alert alert-success">✅ <%= request.getParameter("success") %></div>
                <% } %>
                
                <!-- Expense Limit Warnings for All Candidates -->
                <% 
                if (myCandidates != null && !myCandidates.isEmpty()) {
                    for (Candidate c : myCandidates) {
                        if (c.isPaymentVerified() && "active".equals(c.getAccountStatus())) {
                            boolean needsExpenseLimit = (c.getExpenseLimit() == null || c.getExpenseLimit().compareTo(java.math.BigDecimal.ZERO) <= 0);
                            if (needsExpenseLimit) {
                %>
                    <div class="alert" style="background: #fff3cd; border-left-color: #ffc107; color: #856404; display: flex; align-items: center; justify-content: space-between;">
                        <div>
                            <strong>⚠️ Action Required:</strong> Candidate <strong><%= c.getCandidateName() %></strong> does not have an expense limit set. Please set the expense limit to track expenses properly.
                        </div>
                        <a href="edit-candidate.jsp?candidateId=<%= c.getCandidateId() %>&focusLimit=true" class="btn btn-warning btn-sm" style="white-space: nowrap; margin-left: 10px;">Set Limit</a>
                    </div>
                <%
                            }
                        }
                    }
                }
                %>
                
                <% if (selectedCandidate != null) { %>
                    <div class="alert alert-info">
                        📌 <%= MessageBundle.getMessage(request, "user.managing") %>: <strong><%= selectedCandidate.getCandidateName() %><% if(selectedCandidate.getNominationId() != null && !selectedCandidate.getNominationId().trim().isEmpty()) { %> - <%= selectedCandidate.getNominationId() %><% } %></strong> 
                        <a href="<%=request.getContextPath()%>/select-candidate?action=clear" style="margin-left: 10px; color: #1e3a8a; text-decoration: underline; font-weight: 600;"><%= MessageBundle.getMessage(request, "user.switch.candidate") %></a>
                    </div>
                    
                    <%
                    // Check if selected candidate needs expense limit
                    boolean selectedNeedsLimit = (selectedCandidate.getExpenseLimit() == null || 
                                                  selectedCandidate.getExpenseLimit().compareTo(java.math.BigDecimal.ZERO) <= 0);
                    if (selectedNeedsLimit) {
                    %>
                    <div class="alert" style="background: #fef2f2; border-left-color: #ef4444; color: #991b1b; animation: pulse 2s infinite;">
                        <div style="display: flex; align-items: center; justify-content: space-between;">
                            <div style="flex: 1;">
                                <strong>🚨 Critical:</strong> Expense limit is not set for <strong><%= selectedCandidate.getCandidateName() %></strong>. 
                                You cannot add expenses or track spending without setting an expense limit first.
                            </div>
                            <a href="edit-candidate.jsp?candidateId=<%= selectedCandidate.getCandidateId() %>&focusLimit=true" 
                               class="btn" style="background: #dc2626; color: white; white-space: nowrap; margin-left: 15px; font-weight: 600;">
                                Set Expense Limit Now
                            </a>
                        </div>
                    </div>
                    <% } %>
                    
                    <!-- Fund Alert Notification (Dynamic via AJAX) -->
                    <div id="fundAlertBox" class="fund-alert-box"></div>
                <% } %>
                
                <div class="content-header">
                    <h2><%= MessageBundle.getMessage(request, "user.candidates") %></h2>
                    <a href="add-candidate.jsp" class="btn btn-success btn-sm">➕ <%= MessageBundle.getMessage(request, "candidate.add") %></a>
                </div>
                
                <div class="candidates-list">
                    <% if (myCandidates != null && !myCandidates.isEmpty()) { %>
                        <div class="candidates-table-wrapper">
                            <table class="candidates-table">
                                <thead>
                                    <tr>
                                        <th>👤 Candidate Details</th>
                                        <th style="text-align: center;">⚡ Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% 
                                    for (Candidate c : myCandidates) { 
                                        String rowClass = (selectedCandidate != null && selectedCandidate.getCandidateId() == c.getCandidateId()) ? "selected-row" : "";
                                    %>
                                        <tr class="<%= rowClass %>">
                                            <td class="candidate-name-cell">
                                                <div class="candidate-name-main">
                                                    <%= c.getCandidateName() %>
                                                    <% if(c.getNominationId() != null && !c.getNominationId().trim().isEmpty()) { %>
                                                        <span class="nomination-id">🆔 <%= c.getNominationId() %></span>
                                                    <% } %>
                                                </div>
                                                <div class="candidate-details">
                                                    <span class="detail-item">🎯 <%= c.getPartyName() != null ? c.getPartyName() : "Independent" %></span>
                                                    <span class="detail-separator">•</span>
                                                    <span class="detail-item">🏛️ <%= c.getConstituency() != null ? c.getConstituency() : "N/A" %></span>
                                                    <span class="detail-separator">•</span>
                                                    <% if (c.isPaymentVerified() && "active".equals(c.getAccountStatus())) { %>
                                                        <span class="badge badge-success"><%= MessageBundle.getMessage(request, "status.active") %></span>
                                                    <% } else if ("pending_payment".equals(c.getAccountStatus())) { %>
                                                        <span class="badge badge-warning"><%= MessageBundle.getMessage(request, "payment.pending") %></span>
                                                    <% } else { %>
                                                        <span class="badge badge-danger"><%= MessageBundle.getMessage(request, "status.inactive") %></span>
                                                    <% } %>
                                                </div>
                                            </td>
                                            <td>
                                                <div class="candidate-actions-table">
                                                    <% if (c.isPaymentVerified() && "active".equals(c.getAccountStatus())) { %>
                                                        <a href="<%=request.getContextPath()%>/select-candidate?candidateId=<%= c.getCandidateId() %>" class="btn btn-primary btn-sm"><%= MessageBundle.getMessage(request, "action.select") %></a>
                                                        <a href="manage-funds.jsp?candidateId=<%= c.getCandidateId() %>" class="btn btn-success btn-sm">💰 Funds</a>
                                                    <% } else { %>
                                                        <a href="candidate-payment.jsp?candidateId=<%= c.getCandidateId() %>" class="btn btn-warning btn-sm">💳 Pay</a>
                                                    <% } %>
                                                    <a href="edit-candidate.jsp?candidateId=<%= c.getCandidateId() %>" class="btn btn-outline btn-sm">✏️ Edit</a>
                                                </div>
                                            </td>
                                        </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                        
                        <!-- Pagination -->
                        <% if (totalPages > 1) { %>
                        <div class="pagination-container" style="margin-top: 20px; text-align: center;">
                            <div class="pagination">
                                <% if (currentPage > 1) { %>
                                    <a href="?page=<%= currentPage - 1 %>" class="page-link">← <%= MessageBundle.getMessage(request, "pagination.previous") %></a>
                                <% } %>
                                
                                <% 
                                int startPage = Math.max(1, currentPage - 2);
                                int endPage = Math.min(totalPages, currentPage + 2);
                                
                                if (startPage > 1) { %>
                                    <a href="?page=1" class="page-link">1</a>
                                    <% if (startPage > 2) { %>
                                        <span class="page-ellipsis">...</span>
                                    <% } %>
                                <% }
                                
                                for (int i = startPage; i <= endPage; i++) { %>
                                    <a href="?page=<%= i %>" class="page-link <%= (i == currentPage) ? "active" : "" %>"><%= i %></a>
                                <% }
                                
                                if (endPage < totalPages) { 
                                    if (endPage < totalPages - 1) { %>
                                        <span class="page-ellipsis">...</span>
                                    <% } %>
                                    <a href="?page=<%= totalPages %>" class="page-link"><%= totalPages %></a>
                                <% } %>
                                
                                <% if (currentPage < totalPages) { %>
                                    <a href="?page=<%= currentPage + 1 %>" class="page-link"><%= MessageBundle.getMessage(request, "pagination.next") %> →</a>
                                <% } %>
                            </div>
                            <div style="margin-top: 10px; color: #718096; font-size: 13px;">
                                <%= MessageBundle.getMessage(request, "pagination.showing") %> <%= startIndex + 1 %>-<%= endIndex %> <%= MessageBundle.getMessage(request, "pagination.of") %> <%= totalCandidates %>
                            </div>
                        </div>
                        <% } %>
                    <% } else { %>
                        <div class="empty-state">
                            <div class="icon">🗳️</div>
                            <h3 style="color: #4a5568; margin-bottom: 8px;"><%= MessageBundle.getMessage(request, "message.no.data") %></h3>
                            <p style="margin-bottom: 15px;"><%= MessageBundle.getMessage(request, "candidate.addnew") %></p>
                            <a href="add-candidate.jsp" class="btn btn-success">➕ <%= MessageBundle.getMessage(request, "candidate.add") %></a>
                        </div>
                    <% } %>
                </div>
            </div>
        </div>
        
        <!-- Social Media Footer -->
        <jsp:include page="/includes/social-media-footer.jsp" />
    </div>
    
    <% if (selectedCandidate != null) { %>
    <script>
        // Fetch fund statistics when candidate is selected
        function loadFundStatistics() {
            fetch('<%=request.getContextPath()%>/getFundStatistics')
                .then(response => response.json())
                .then(data => {
                    if (data.error) {
                        console.log('No fund statistics available:', data.error);
                        return;
                    }
                    
                    // Check if expense limit is set
                    if (!data.totalFunds || parseFloat(data.totalFunds) <= 0) {
                        console.log('Expense limit not set for this candidate');
                        return;
                    }
                    
                    // Only show alert if usage >= 50%
                    if (data.hasAlert) {
                        displayFundAlert(data);
                    }
                })
                .catch(error => console.error('Error loading fund statistics:', error));
        }
        
        function displayFundAlert(stats) {
            const alertBox = document.getElementById('fundAlertBox');
            if (!alertBox) return;
            
            let alertClass = 'alert-warning';
            let icon = '⚠️';
            let title = 'Expense Limit Warning';
            let progressColor = '#f59e0b';
            
            if (stats.usagePercentage >= 90) {
                alertClass = 'alert-critical';
                icon = '🚨';
                title = 'CRITICAL: Expense Limit Exceeded';
                progressColor = '#dc2626';
            } else if (stats.usagePercentage >= 75) {
                alertClass = 'alert-danger';
                icon = '⛔';
                title = 'High Expense Usage Alert';
                progressColor = '#ef4444';
            }
            
            const formatCurrency = (amount) => {
                return '₹' + parseFloat(amount).toFixed(2).replace(/\B(?=(\d{3})+(?!\d))/g, ",");
            };
            
            alertBox.className = 'fund-alert-box alert ' + alertClass;
            alertBox.style.display = 'block';
            alertBox.innerHTML = 
                '<div class="fund-alert-header">' +
                    '<span style="font-size: 18px;">' + icon + '</span>' +
                    '<span>' + title + '</span>' +
                '</div>' +
                '<div class="fund-alert-details">' +
                    '<strong>' + stats.candidateName + '</strong> has used <strong>' + stats.usagePercentage.toFixed(2) + '%</strong> of expense limit.' +
                    '<div class="fund-stats-row">' +
                        '<div class="fund-stat-item">' +
                            '<div class="fund-stat-label">Expense Limit</div>' +
                            '<div class="fund-stat-value">' + formatCurrency(stats.totalFunds) + '</div>' +
                        '</div>' +
                        '<div class="fund-stat-item">' +
                            '<div class="fund-stat-label">Used</div>' +
                            '<div class="fund-stat-value">' + formatCurrency(stats.totalExpenses) + '</div>' +
                        '</div>' +
                        '<div class="fund-stat-item">' +
                            '<div class="fund-stat-label">Remaining</div>' +
                            '<div class="fund-stat-value">' + formatCurrency(stats.remainingFunds) + '</div>' +
                        '</div>' +
                    '</div>' +
                    '<div class="progress-bar">' +
                        '<div class="progress-fill" style="width: ' + Math.min(stats.usagePercentage, 100) + '%; background: ' + progressColor + ';">' +
                            stats.usagePercentage.toFixed(1) + '%' +
                        '</div>' +
                    '</div>' +
                '</div>';
        }
        
        // Load statistics on page load
        document.addEventListener('DOMContentLoaded', function() {
            loadFundStatistics();
            // Refresh every 30 seconds
            setInterval(loadFundStatistics, 30000);
        });
    </script>
    <% } %>
    
    <script>
        // Toggle Quick Actions Show/Hide
        function toggleQuickActions() {
            const content = document.getElementById('quickActionsContent');
            const icon = document.getElementById('toggleIcon');
            const isCollapsed = content.classList.contains('collapsed');
            
            if (isCollapsed) {
                // Show
                content.classList.remove('collapsed');
                icon.textContent = '−';
                localStorage.setItem('quickActionsVisible', 'true');
            } else {
                // Hide
                content.classList.add('collapsed');
                icon.textContent = '+';
                localStorage.setItem('quickActionsVisible', 'false');
            }
        }
        
        // Restore state on page load
        document.addEventListener('DOMContentLoaded', function() {
            const isVisible = localStorage.getItem('quickActionsVisible');

            // Default to visible (true), hide only if explicitly set to false
            if (isVisible === 'false') {
                const content = document.getElementById('quickActionsContent');
                const icon = document.getElementById('toggleIcon');
                content.classList.add('collapsed');
                icon.textContent = '+';
            }
        });
        
        // Open Proforma-1 in modal popup
        function openProforma1Popup(candidateId) {
            const url = 'select-date-proforma1.jsp?candidateId=' + candidateId;
            openModalPopup(url, 'Proforma-1 Date Selection');
        }
        
        // Open Proforma-2 in modal popup
        function openProforma2Popup(candidateId) {
            const url = '<%=request.getContextPath()%>/generateProforma2?candidateId=' + candidateId;
            openModalPopup(url, 'Proforma-2 Report');
        }
        
        // Generic modal popup function
        function openModalPopup(url, title) {
            // Create modal overlay
            const modal = document.createElement('div');
            modal.id = 'proformaModal';
            modal.style.cssText = 'position:fixed;top:0;left:0;width:100%;height:100%;background:rgba(0,0,0,0.8);z-index:9999;display:flex;align-items:center;justify-content:center;animation:fadeIn 0.3s;';
            
            // Create modal content container
            const modalContent = document.createElement('div');
            modalContent.style.cssText = 'background:white;width:95%;max-width:1400px;height:90%;border-radius:12px;box-shadow:0 20px 60px rgba(0,0,0,0.5);display:flex;flex-direction:column;animation:slideDown 0.3s;';
            
            // Create modal header
            const modalHeader = document.createElement('div');
            modalHeader.style.cssText = 'display:flex;justify-content:space-between;align-items:center;padding:20px 30px;border-bottom:2px solid #e2e8f0;background:linear-gradient(135deg,#667eea 0%,#764ba2 100%);border-radius:12px 12px 0 0;';
            
            const modalTitle = document.createElement('h2');
            modalTitle.textContent = title;
            modalTitle.style.cssText = 'margin:0;color:white;font-size:22px;font-weight:600;';
            
            const closeBtn = document.createElement('button');
            closeBtn.innerHTML = '✕';
            closeBtn.style.cssText = 'background:rgba(255,255,255,0.2);border:none;color:white;font-size:28px;font-weight:bold;cursor:pointer;width:40px;height:40px;border-radius:50%;transition:all 0.3s;display:flex;align-items:center;justify-content:center;';
            closeBtn.onmouseover = function() { this.style.background = 'rgba(255,255,255,0.3)'; };
            closeBtn.onmouseout = function() { this.style.background = 'rgba(255,255,255,0.2)'; };
            closeBtn.onclick = function() { closeModalPopup(); };
            
            modalHeader.appendChild(modalTitle);
            modalHeader.appendChild(closeBtn);
            
            // Create iframe for content
            const iframe = document.createElement('iframe');
            iframe.src = url;
            iframe.style.cssText = 'width:100%;flex:1;border:none;border-radius:0 0 12px 12px;';
            
            // Assemble modal
            modalContent.appendChild(modalHeader);
            modalContent.appendChild(iframe);
            modal.appendChild(modalContent);
            document.body.appendChild(modal);
            
            // Close on overlay click
            modal.onclick = function(e) {
                if (e.target === modal) closeModalPopup();
            };
            
            // Close on ESC key
            document.addEventListener('keydown', function escHandler(e) {
                if (e.key === 'Escape') {
                    closeModalPopup();
                    document.removeEventListener('keydown', escHandler);
                }
            });
            
            // Prevent body scroll
            document.body.style.overflow = 'hidden';
        }
        
        // Close modal popup
        function closeModalPopup() {
            const modal = document.getElementById('proformaModal');
            if (modal) {
                modal.style.animation = 'fadeOut 0.3s';
                setTimeout(() => {
                    modal.remove();
                    document.body.style.overflow = 'auto';
                }, 300);
            }
        }
        
        // Add CSS animations
        const style = document.createElement('style');
        style.textContent = `
            @keyframes fadeIn {
                from { opacity: 0; }
                to { opacity: 1; }
            }
            @keyframes fadeOut {
                from { opacity: 1; }
                to { opacity: 0; }
            }
            @keyframes slideDown {
                from { transform: translateY(-50px); opacity: 0; }
                to { transform: translateY(0); opacity: 1; }
            }
        `;
        document.head.appendChild(style);
        
        // Listen for messages from iframe to open nested modals
        window.addEventListener('message', function(event) {
            if (event.data && event.data.action === 'openProforma') {
                // Close existing modal first
                closeModalPopup();
                // Open new modal with report
                setTimeout(() => {
                    openModalPopup(event.data.url, event.data.title);
                }, 350);
            }
        });
    </script>
    
    <!-- Include Share Button -->
    <jsp:include page="/includes/share-button.jsp" />
</body>
</html>
