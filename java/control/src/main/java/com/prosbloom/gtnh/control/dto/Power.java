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
@IdClass(PowerID.class)
public class Power implements Serializable {

    @Id
    @Column(name="timestamp", nullable = false, updatable = false, insertable = false)
    @Temporal(TemporalType.TIMESTAMP)
    private Date timestamp;
    @Id
    private String label;

    private Boolean enabled;
    private Boolean maintenance;

    @PrePersist
    protected void onCreate() {
        timestamp = new Date();
    }


    @Override
    public String toString() {
        return String.format("%s-%s;%s", label, enabled, maintenance);
    }
}
