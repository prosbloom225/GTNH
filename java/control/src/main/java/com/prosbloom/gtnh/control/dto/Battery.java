package com.prosbloom.gtnh.control.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.persistence.*;
import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Entity
@IdClass(BatteryID.class)
public class Battery implements Serializable {

    @Id
    @Column(name="timestamp", nullable = false, updatable = false, insertable = false)
    @Temporal(TemporalType.TIMESTAMP)
    private Date createDateTime;
    @Id
    private String label;

    private BigDecimal currPower;
    private BigDecimal maxPower;
    private Double amps;
    private Double volts;
    private BigDecimal input;
    private BigDecimal output;

    @PrePersist
    protected void onCreate() {
        createDateTime = new Date();
    }

    @Override
    public String toString() {
        return String.format("%s - %s/%s", this.label, this.currPower, this.maxPower);
    }

}
