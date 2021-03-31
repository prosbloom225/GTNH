package com.prosbloom.gtnh.control.repo;

import com.prosbloom.gtnh.control.dto.Battery;
import com.prosbloom.gtnh.control.dto.BatteryID;
import org.springframework.data.repository.CrudRepository;

public interface PowerRepository extends CrudRepository<Battery, BatteryID> {
}
