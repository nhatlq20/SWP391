package utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBContext {

    // JDBC URL used to create new connections on demand
    private final String url = "jdbc:sqlserver://localhost:1433;"
            + "databaseName=SWP391_Test7;"
            + "user=sa;"
            + "password=ndc2022005;"
            + "encrypt=true;"
            + "trustServerCertificate=true;";

    public DBContext() {
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        } catch (ClassNotFoundException ex) {
            System.out.println("JDBC Driver not found: " + ex);
        }
    }

    // Return a new connection each time to avoid sharing/closing the same Connection instance
    public Connection getConnection() throws SQLException {
        return DriverManager.getConnection(url);
    }

    public static void main(String[] args) {
        try {
            DBContext dbContext = new DBContext();
            Connection connection = dbContext.getConnection();
            if (connection != null && !connection.isClosed()) {
                System.out.println("Connection successful!");
                connection.close();
            } else {
                System.out.println("Failed to make connection.");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
