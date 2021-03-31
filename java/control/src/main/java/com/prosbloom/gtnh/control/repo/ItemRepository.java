package com.prosbloom.gtnh.control.repo;

import com.prosbloom.gtnh.control.dto.Item;
import org.springframework.data.repository.CrudRepository;

public interface ItemRepository extends CrudRepository<Item, String> {
}
