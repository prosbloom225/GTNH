package com.prosbloom.gtnh.control.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.persistence.Entity;
import javax.persistence.Id;
import java.math.BigDecimal;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Entity
public class Fluid {
    private BigDecimal amount;
    private boolean hasTag;
    private String label;
    @Id
    private String name;
}
