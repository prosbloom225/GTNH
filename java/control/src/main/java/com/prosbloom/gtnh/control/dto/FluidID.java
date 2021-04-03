package com.prosbloom.gtnh.control.dto;

import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;
import java.util.Date;

@Data
@NoArgsConstructor
public class FluidID implements Serializable {

    private Date createDateTime;
    private String name;
}
