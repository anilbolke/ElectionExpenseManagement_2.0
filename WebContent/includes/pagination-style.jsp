<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<style>
/* Pagination Styles */
.pagination-container {
    margin: 20px 0;
    display: flex;
    justify-content: space-between;
    align-items: center;
    flex-wrap: wrap;
    gap: 15px;
}

.pagination-info {
    color: #4a5568;
    font-size: 13px;
    font-weight: 500;
}

.pagination-info strong {
    color: #2d3748;
    font-weight: 600;
}

.pagination {
    display: flex;
    gap: 5px;
    align-items: center;
    flex-wrap: wrap;
}

.pagination a,
.pagination span {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    min-width: 36px;
    height: 36px;
    padding: 0 10px;
    font-size: 13px;
    font-weight: 500;
    text-decoration: none;
    border: 1px solid #e2e8f0;
    border-radius: 6px;
    transition: all 0.2s ease;
    background: white;
    color: #4a5568;
}

.pagination a:hover:not(.disabled) {
    background: #667eea;
    color: white;
    border-color: #667eea;
    transform: translateY(-1px);
    box-shadow: 0 2px 4px rgba(102, 126, 234, 0.3);
}

.pagination .current {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    color: white;
    border-color: #667eea;
    font-weight: 600;
    box-shadow: 0 2px 4px rgba(102, 126, 234, 0.3);
}

.pagination .disabled {
    opacity: 0.5;
    cursor: not-allowed;
    background: #f7fafc;
}

.pagination .ellipsis {
    border: none;
    background: transparent;
    cursor: default;
    font-weight: bold;
    color: #a0aec0;
}

.pagination .first-last {
    font-weight: 600;
    color: #667eea;
}

.page-size-selector {
    display: flex;
    align-items: center;
    gap: 10px;
    font-size: 13px;
}

.page-size-selector label {
    color: #4a5568;
    font-weight: 500;
}

.page-size-selector select {
    padding: 6px 10px;
    border: 1px solid #e2e8f0;
    border-radius: 6px;
    font-size: 13px;
    color: #2d3748;
    background: white;
    cursor: pointer;
    transition: all 0.2s ease;
}

.page-size-selector select:hover {
    border-color: #667eea;
}

.page-size-selector select:focus {
    outline: none;
    border-color: #667eea;
    box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
}

/* Mobile Responsive */
@media (max-width: 768px) {
    .pagination-container {
        flex-direction: column;
        align-items: flex-start;
    }
    
    .pagination a,
    .pagination span {
        min-width: 32px;
        height: 32px;
        padding: 0 8px;
        font-size: 12px;
    }
    
    .pagination-info {
        font-size: 12px;
    }
    
    .page-size-selector {
        width: 100%;
    }
}

/* No records message */
.no-records {
    text-align: center;
    padding: 40px 20px;
    background: white;
    border-radius: 8px;
    color: #718096;
    font-size: 14px;
}

.no-records-icon {
    font-size: 48px;
    margin-bottom: 15px;
    opacity: 0.3;
}
</style>
