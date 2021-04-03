package com.prosbloom.gtnh.control.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.persistence.*;
import java.math.BigDecimal;
import java.util.Date;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Entity
@IdClass(FluidID.class)
public class Fluid {
    private BigDecimal amount;
    private boolean hasTag;
    private String label;
    @Id
    private String name;
    @Id
    @Column(name="timestamp", nullable = false, updatable = false, insertable = false)
    @Temporal(TemporalType.TIMESTAMP)
    private Date createDateTime;

    @PrePersist
    protected void onCreate() {
        createDateTime = new Date();
    }

    @Override
    public String toString() {
        return String.format("%s: %s - %s", this.name, this.amount, this.createDateTime);
    }
}
