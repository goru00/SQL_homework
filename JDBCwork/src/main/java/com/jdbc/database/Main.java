package com.jdbc.database;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.Driver;
import java.sql.SQLException;

public class Main {

    private static final String URL = "jdbc:mysql://localhost:3306/lab2?useUnicode=true&useSSL=true&useJDBCCompliantTimezoneShift=true" +
            "&useLegacyDatetimeCode=false&serverTimezone=UTC";
    private static final String USERNAME = "visitor";
    private static final String PASSWORD = "";

    public static void main(String[] args) {
        Connection connection;
        try {
            connection = DriverManager.getConnection(URL, USERNAME, PASSWORD);
            if (!connection.isClosed()) {
                System.out.println("STARTED!");
            }
        } catch (SQLException e) {
            System.err.println("ERROR DRIVER!");
        }
    }
}
