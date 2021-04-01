package com.prosbloom.gtnh.control.repo;

import com.prosbloom.gtnh.control.dto.Battery;
import com.prosbloom.gtnh.control.dto.BatteryID;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;

import java.util.List;

public interface BatteryRepository extends CrudRepository<Battery, BatteryID> {

   @Query(value = "select b.* from (SELECT max(timestamp) as tmst, label from battery group by label) " +
           "a inner join battery b on a.tmst = b.timestamp and a.label = b.label", nativeQuery = true)
   public List<Battery> getLatestBatteries();
}
