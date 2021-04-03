package com.prosbloom.gtnh.control.repo;

import com.prosbloom.gtnh.control.dto.Fluid;
import com.prosbloom.gtnh.control.dto.Item;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;

import java.util.List;

public interface FluidRepository extends CrudRepository<Fluid, String> {

    @Query(value = "SELECT b.* FROM gtnh.fluid b\n" +
            "INNER JOIN (SELECT MAX(timestamp) AS tmst, name FROM gtnh.fluid GROUP BY name) a\n" +
            "ON a.tmst = b.timestamp AND a.name = b.name\n" +
            "ORDER BY b.amount DESC", nativeQuery = true)
    public List<Fluid> getLatestFluids();
}
