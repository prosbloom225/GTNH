package com.prosbloom.gtnh.control.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.persistence.Entity;
import javax.persistence.Id;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Entity
public class Item {
    private double damage;
    private boolean hasTag;
    @Id
    private String label;
    private double maxDamage;
    private double maxSize;
    private String name;
    private double size;
}
