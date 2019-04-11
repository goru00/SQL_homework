package com.jdbc.database;

//import com.mysql.fabric.jdbc.FabricMySQLDriver;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.Driver;
import java.sql.SQLException;

public class Main {

    private static final String URL = "jdbc:mysql://188.191.166.97:3306/tretyakov?useUnicode=true&useSSL=true&useJDBCCompliantTimezoneShift=true" +
            "&useLegacyDatetimeCode=false&serverTimezone=UTC";
    private static final String USERNAME = "id140346916";
    private static final String PASSWORD = "123";

    public static void main(String[] args) {
        Connection connection;
        try {
            //Driver driver = new FabricMySQLDriver();
            //DriverManager.registerDriver(driver);
            connection = DriverManager.getConnection(URL, USERNAME, PASSWORD);
            if (!connection.isClosed()) {
                System.out.println("STARTED!");
            }
        } catch (SQLException e) {
            System.err.println("ERROR DRIVER!");
        }
    }
}