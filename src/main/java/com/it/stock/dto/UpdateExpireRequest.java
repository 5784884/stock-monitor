package com.it.stock.dto;

import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class UpdateExpireRequest {

    @NotNull(message = "续期时长不能为空")
    private Integer durationMonths;
}
