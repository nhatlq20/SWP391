/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Utils;

import java.sql.Connection;
import java.sql.DriverManager;

/**
 *
 * @author PC
 */
public class DBContext {

    public Connection connection;

    public DBContext() {

        try {

            String url = "jdbc:sqlserver://localhost:1433;"
                    + "databaseName=SWP391_Test7;"
                    + "user=sa;"
                    + "password=123;"
                    + "encrypt=true;"
                    + "trustServerCertificate=true;";

            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            connection = DriverManager.getConnection(url);

        } catch (Exception e) {
            System.out.println("Database connection failed: " + e);
        }

    }

}
