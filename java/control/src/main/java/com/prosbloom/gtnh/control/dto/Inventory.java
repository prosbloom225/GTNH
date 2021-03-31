package com.prosbloom.gtnh.control.dto;

import lombok.Data;

@Data
public class Inventory {
    private Item[] items;

    @Override
    public String toString() {
        String ret = "";
        for (Item item : items)
            ret += item.getName();
        return ret;
    }
}
