package com.prosbloom.gtnh.control.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.persistence.*;
import java.io.Serializable;
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

    private Double currPower;
    private Double maxPower;
    private Double amps;
    private Double volts;

    @PrePersist
    protected void onCreate() {
        createDateTime = new Date();
    }

}
