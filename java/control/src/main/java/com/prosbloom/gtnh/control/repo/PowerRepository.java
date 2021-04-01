package com.prosbloom.gtnh.control.repo;

import com.prosbloom.gtnh.control.dto.Power;
import com.prosbloom.gtnh.control.dto.PowerID;
import org.springframework.data.repository.CrudRepository;

public interface PowerRepository extends CrudRepository<Power, PowerID> {
    public Power findFirstByLabelOrderByTimestampDesc(String label);
}
