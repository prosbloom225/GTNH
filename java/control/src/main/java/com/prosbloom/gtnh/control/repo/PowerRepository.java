package com.prosbloom.gtnh.control.repo;

import com.prosbloom.gtnh.control.dto.Power;
import com.prosbloom.gtnh.control.dto.PowerID;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;

import java.util.List;

public interface PowerRepository extends CrudRepository<Power, PowerID> {
    public Power findFirstByLabelOrderByTimestampDesc(String label);

    @Query(value = "select b.* from (select max(timestamp) as tmst, label from POWER group by label) a " +
            "inner join POWER b on a.tmst = b.timestamp and a.label = b.label", nativeQuery = true)
    public List<Power> getCurrentPower();
}
