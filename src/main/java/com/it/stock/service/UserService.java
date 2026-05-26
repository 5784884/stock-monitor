package com.it.stock.service;

import com.it.stock.entity.SysUser;

import java.time.LocalDateTime;
import java.util.List;

public interface UserService {

    SysUser findByUsername(String username);

    SysUser register(String username, String password, LocalDateTime expireTime);

    List<SysUser> getAllUsers();

    SysUser getUserById(Long id);

    void updateExpireTime(Long id, LocalDateTime expireTime);

    void updatePassword(Long id, String newPassword);

    void deleteUser(Long id);

    SysUser createUser(String username, String password, String role, LocalDateTime expireTime);

    void updateApprovalStatus(Long id, Integer approved);
}
