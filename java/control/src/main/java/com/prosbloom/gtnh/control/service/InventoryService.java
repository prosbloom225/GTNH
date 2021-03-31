package com.prosbloom.gtnh.control.service;

import com.prosbloom.gtnh.control.dto.Inventory;
import org.springframework.stereotype.Service;

@Service
public class InventoryService {

    private Inventory[] inventories;

    public Inventory[] getInventories() {
        return inventories;
    }

}
