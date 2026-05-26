package com.it.stock.controller;

import com.it.stock.common.Result;
import com.it.stock.dto.LoginRequest;
import com.it.stock.dto.LoginResponse;
import com.it.stock.dto.RegisterRequest;
import com.it.stock.entity.SysUser;
import com.it.stock.service.UserService;
import com.it.stock.util.JwtUtil;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

@RestController
@RequestMapping("/api/auth")
@RequiredArgsConstructor
public class AuthController {

    private final UserService userService;
    private final PasswordEncoder passwordEncoder;
    private final JwtUtil jwtUtil;

    @PostMapping("/register")
    public Result<?> register(@Valid @RequestBody RegisterRequest request) {
        // 检查用户名是否已存在
        SysUser existingUser = userService.findByUsername(request.getUsername());
        if (existingUser != null) {
            return Result.error("用户名已存在");
        }

        // 计算过期时间
        LocalDateTime expireTime = LocalDateTime.now().plusMonths(request.getDurationMonths());

        // 注册用户
        SysUser user = userService.register(request.getUsername(), request.getPassword(), expireTime);

        return Result.success("注册成功，请等待管理员审批", user.getUsername());
    }

    @PostMapping("/login")
    public Result<?> login(@Valid @RequestBody LoginRequest request) {
        // 查找用户
        SysUser user = userService.findByUsername(request.getUsername());
        if (user == null) {
            return Result.error("用户名或密码错误");
        }

        // 验证密码
        if (!passwordEncoder.matches(request.getPassword(), user.getPassword())) {
            return Result.error("用户名或密码错误");
        }

        // 检查审批状态
        if (user.getApproved() == null || user.getApproved() == 0) {
            return Result.error(403, "账号待审批，请等待管理员审核");
        }
        if (user.getApproved() == 2) {
            return Result.error(403, "账号已被拒绝，请联系管理员");
        }

        // 检查账号是否过期
        if (user.getExpireTime() != null && LocalDateTime.now().isAfter(user.getExpireTime())) {
            return Result.error(403, "账号已过期，请联系管理员");
        }

        // 生成JWT Token
        String token = jwtUtil.generateToken(user.getUsername(), user.getRole());

        // 格式化过期时间
        String expireTimeStr = user.getExpireTime() != null
                ? user.getExpireTime().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"))
                : "永久";

        LoginResponse response = new LoginResponse(token, user.getUsername(), user.getRole(), expireTimeStr);

        return Result.success(response);
    }
}
