package com.it.stock.controller;

import com.it.stock.common.Result;
import com.it.stock.dto.CreateUserRequest;
import com.it.stock.dto.ResetPasswordRequest;
import com.it.stock.dto.UpdateExpireRequest;
import com.it.stock.entity.SysUser;
import com.it.stock.service.UserService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.List;

@RestController
@RequestMapping("/api/admin")
@RequiredArgsConstructor
public class AdminController {

    private final UserService userService;

    @GetMapping("/users")
    public Result<List<SysUser>> getAllUsers() {
        List<SysUser> users = userService.getAllUsers();
        return Result.success(users);
    }

    @PostMapping("/users")
    public Result<?> createUser(@Valid @RequestBody CreateUserRequest request) {
        // 检查用户名是否已存在
        SysUser existingUser = userService.findByUsername(request.getUsername());
        if (existingUser != null) {
            return Result.error("用户名已存在");
        }

        // 计算过期时间
        LocalDateTime expireTime = LocalDateTime.now().plusMonths(request.getDurationMonths());

        // 创建用户
        SysUser user = userService.createUser(
                request.getUsername(),
                request.getPassword(),
                request.getRole(),
                expireTime
        );

        return Result.success("用户创建成功", user);
    }

    @PutMapping("/users/{id}/expire")
    public Result<?> updateExpireTime(@PathVariable Long id, @Valid @RequestBody UpdateExpireRequest request) {
        SysUser user = userService.getUserById(id);
        if (user == null) {
            return Result.error("用户不存在");
        }

        // 从当前过期时间延长，如果没有过期时间则从现在开始
        LocalDateTime newExpireTime = user.getExpireTime() != null
                ? user.getExpireTime().plusMonths(request.getDurationMonths())
                : LocalDateTime.now().plusMonths(request.getDurationMonths());

        userService.updateExpireTime(id, newExpireTime);

        return Result.success("续期成功");
    }

    @PutMapping("/users/{id}/password")
    public Result<?> resetPassword(@PathVariable Long id, @Valid @RequestBody ResetPasswordRequest request) {
        SysUser user = userService.getUserById(id);
        if (user == null) {
            return Result.error("用户不存在");
        }

        userService.updatePassword(id, request.getNewPassword());

        return Result.success("密码重置成功");
    }

    @DeleteMapping("/users/{id}")
    public Result<?> deleteUser(@PathVariable Long id) {
        SysUser user = userService.getUserById(id);
        if (user == null) {
            return Result.error("用户不存在");
        }

        userService.deleteUser(id);

        return Result.success("用户删除成功");
    }

    @PutMapping("/users/{id}/approve")
    public Result<?> approveUser(@PathVariable Long id) {
        SysUser user = userService.getUserById(id);
        if (user == null) {
            return Result.error("用户不存在");
        }

        userService.updateApprovalStatus(id, 1);
        return Result.success("用户审批通过");
    }

    @PutMapping("/users/{id}/reject")
    public Result<?> rejectUser(@PathVariable Long id) {
        SysUser user = userService.getUserById(id);
        if (user == null) {
            return Result.error("用户不存在");
        }

        userService.updateApprovalStatus(id, 2);
        return Result.success("用户已拒绝");
    }
}
