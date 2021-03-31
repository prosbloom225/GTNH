package com.prosbloom.gtnh.control.dto;

import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;

import java.io.Serializable;
import java.util.Date;

@Data
@NoArgsConstructor
public class BatteryID implements Serializable {

    private Date createDateTime;
    private String label;
}
