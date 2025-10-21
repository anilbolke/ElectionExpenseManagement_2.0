package com.election.util;

import java.util.List;
import java.util.ArrayList;

/**
 * Utility class for handling pagination
 */
public class PaginationUtil {
    
    private int currentPage;
    private int pageSize;
    private int totalRecords;
    private int totalPages;
    private int startRecord;
    private int endRecord;
    
    /**
     * Constructor
     * @param currentPage Current page number (1-based)
     * @param pageSize Number of records per page
     * @param totalRecords Total number of records
     */
    public PaginationUtil(int currentPage, int pageSize, int totalRecords) {
        this.pageSize = pageSize;
        this.totalRecords = totalRecords;
        this.totalPages = (int) Math.ceil((double) totalRecords / pageSize);
        
        // Validate and set current page
        if (currentPage < 1) {
            this.currentPage = 1;
        } else if (currentPage > this.totalPages && this.totalPages > 0) {
            this.currentPage = this.totalPages;
        } else {
            this.currentPage = currentPage;
        }
        
        // Calculate start and end record indices
        this.startRecord = (this.currentPage - 1) * pageSize;
        this.endRecord = Math.min(this.startRecord + pageSize, totalRecords);
    }
    
    /**
     * Get paginated sublist from a list
     * @param list Full list of items
     * @return Sublist for current page
     */
    public <T> List<T> getPaginatedList(List<T> list) {
        if (list == null || list.isEmpty()) {
            return new ArrayList<>();
        }
        
        int fromIndex = startRecord;
        int toIndex = endRecord;
        
        if (fromIndex >= list.size()) {
            return new ArrayList<>();
        }
        
        if (toIndex > list.size()) {
            toIndex = list.size();
        }
        
        return list.subList(fromIndex, toIndex);
    }
    
    // Getters
    public int getCurrentPage() {
        return currentPage;
    }
    
    public int getPageSize() {
        return pageSize;
    }
    
    public int getTotalRecords() {
        return totalRecords;
    }
    
    public int getTotalPages() {
        return totalPages;
    }
    
    public int getStartRecord() {
        return startRecord + 1; // Return 1-based index for display
    }
    
    public int getEndRecord() {
        return endRecord;
    }
    
    public boolean hasPrevious() {
        return currentPage > 1;
    }
    
    public boolean hasNext() {
        return currentPage < totalPages;
    }
    
    public int getPreviousPage() {
        return currentPage > 1 ? currentPage - 1 : 1;
    }
    
    public int getNextPage() {
        return currentPage < totalPages ? currentPage + 1 : totalPages;
    }
    
    /**
     * Get page numbers to display in pagination
     * Shows max 5 page numbers with current page in middle when possible
     * @return Array of page numbers
     */
    public int[] getPageNumbers() {
        if (totalPages <= 5) {
            // Show all pages if 5 or less
            int[] pages = new int[totalPages];
            for (int i = 0; i < totalPages; i++) {
                pages[i] = i + 1;
            }
            return pages;
        }
        
        // Show 5 pages with current page in middle
        int[] pages = new int[5];
        int start;
        
        if (currentPage <= 3) {
            // Near start
            start = 1;
        } else if (currentPage >= totalPages - 2) {
            // Near end
            start = totalPages - 4;
        } else {
            // Middle
            start = currentPage - 2;
        }
        
        for (int i = 0; i < 5; i++) {
            pages[i] = start + i;
        }
        
        return pages;
    }
    
    /**
     * Get first page number in pagination
     */
    public int getFirstPage() {
        return 1;
    }
    
    /**
     * Get last page number in pagination
     */
    public int getLastPage() {
        return totalPages;
    }
    
    /**
     * Check if showing first page number is needed
     */
    public boolean showFirstPage() {
        int[] pages = getPageNumbers();
        return pages.length > 0 && pages[0] > 1;
    }
    
    /**
     * Check if showing last page number is needed
     */
    public boolean showLastPage() {
        int[] pages = getPageNumbers();
        return pages.length > 0 && pages[pages.length - 1] < totalPages;
    }
}
