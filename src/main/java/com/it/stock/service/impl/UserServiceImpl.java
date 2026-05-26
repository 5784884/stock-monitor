package com.it.stock.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.it.stock.entity.SysUser;
import com.it.stock.mapper.SysUserMapper;
import com.it.stock.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;

@Service
@RequiredArgsConstructor
public class UserServiceImpl implements UserService {

    private final SysUserMapper userMapper;
    private final PasswordEncoder passwordEncoder;

    @Override
    public SysUser findByUsername(String username) {
        LambdaQueryWrapper<SysUser> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(SysUser::getUsername, username);
        return userMapper.selectOne(wrapper);
    }

    @Override
    public SysUser register(String username, String password, LocalDateTime expireTime) {
        SysUser user = new SysUser();
        user.setUsername(username);
        user.setPassword(passwordEncoder.encode(password));
        user.setRole("USER");
        user.setApproved(0); // 默认待审批
        user.setExpireTime(expireTime);
        user.setCreateTime(LocalDateTime.now());
        userMapper.insert(user);
        return user;
    }

    @Override
    public List<SysUser> getAllUsers() {
        return userMapper.selectList(null);
    }

    @Override
    public SysUser getUserById(Long id) {
        return userMapper.selectById(id);
    }

    @Override
    public void updateExpireTime(Long id, LocalDateTime expireTime) {
        SysUser user = new SysUser();
        user.setId(id);
        user.setExpireTime(expireTime);
        userMapper.updateById(user);
    }

    @Override
    public void updatePassword(Long id, String newPassword) {
        SysUser user = new SysUser();
        user.setId(id);
        user.setPassword(passwordEncoder.encode(newPassword));
        userMapper.updateById(user);
    }

    @Override
    public void deleteUser(Long id) {
        userMapper.deleteById(id);
    }

    @Override
    public SysUser createUser(String username, String password, String role, LocalDateTime expireTime) {
        SysUser user = new SysUser();
        user.setUsername(username);
        user.setPassword(passwordEncoder.encode(password));
        user.setRole(role);
        user.setApproved(1); // 管理员创建的用户直接审批通过
        user.setExpireTime(expireTime);
        user.setCreateTime(LocalDateTime.now());
        userMapper.insert(user);
        return user;
    }

    @Override
    public void updateApprovalStatus(Long id, Integer approved) {
        SysUser user = new SysUser();
        user.setId(id);
        user.setApproved(approved);
        userMapper.updateById(user);
    }
}
