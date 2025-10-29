package com.election.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;

public class DatabaseConnection {
    // Updated URL with UTF-8 encoding support for multi-language input
    private static final String URL = "jdbc:mysql://localhost:3306/election_expense_db" +
            "?allowPublicKeyRetrieval=true" +
            "&useSSL=false" +
            "&serverTimezone=UTC" +
            "&useUnicode=true" +
            "&characterEncoding=UTF-8";
    private static final String USERNAME = "root";
    private static final String PASSWORD = "root"; // Change this to your MySQL password
    private static final String DRIVER = "com.mysql.cj.jdbc.Driver";

    // Get database connection with UTF-8 encoding
    public static Connection getConnection() throws SQLException {
        Connection connection = null;
        try {
            Class.forName(DRIVER);
            connection = DriverManager.getConnection(URL, USERNAME, PASSWORD);
            
            // Set connection character set to UTF-8 for multi-language support
            Statement stmt = connection.createStatement();
            stmt.execute("SET NAMES 'utf8mb4'");
            stmt.execute("SET CHARACTER SET utf8mb4");
            stmt.execute("SET character_set_results = 'utf8mb4'");
            stmt.close();
        } catch (ClassNotFoundException e) {
            System.out.println("MySQL JDBC Driver not found!");
            e.printStackTrace();
            throw new SQLException("Driver not found", e);
        }
        return connection;
    }

    // Close connection
    public static void closeConnection(Connection connection) {
        if (connection != null) {
            try {
                connection.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    // Test connection
    public static boolean testConnection() {
        try (Connection conn = getConnection()) {
            return conn != null && !conn.isClosed();
        } catch (SQLException e) {
            System.out.println("Database connection failed!");
            e.printStackTrace();
            return false;
        }
    }
}
