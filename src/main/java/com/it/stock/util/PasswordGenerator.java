package com.it.stock.util;

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

public class PasswordGenerator {
    public static void main(String[] args) {
        BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();
        String password = "admin123";
        String encoded = encoder.encode(password);
        System.out.println("原始密码: " + password);
        System.out.println("加密后的密码: " + encoded);
        System.out.println("\nSQL语句:");
        System.out.println("INSERT INTO `sys_user` (`username`, `password`, `role`, `expire_time`)");
        System.out.println("VALUES ('admin', '" + encoded + "', 'ADMIN', '2099-12-31 23:59:59');");
    }
}
