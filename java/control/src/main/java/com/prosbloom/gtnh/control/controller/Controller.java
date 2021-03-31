package com.prosbloom.gtnh.control.controller;
import com.fasterxml.jackson.core.JsonParser;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.prosbloom.gtnh.control.dto.Item;
import com.prosbloom.gtnh.control.dto.Battery;
import com.prosbloom.gtnh.control.repo.ItemRepository;
import com.prosbloom.gtnh.control.repo.PowerRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;


@RestController
public class Controller {
    private static Logger log = LoggerFactory.getLogger(Controller.class);
    private final ObjectMapper mapper = new ObjectMapper()
            .configure(JsonParser.Feature.ALLOW_TRAILING_COMMA, true);

    @Autowired
    private ItemRepository itemRepository;

    @Autowired
    private PowerRepository powerRepository;

    @PostMapping(path = "/item", consumes="application/x-www-form-urlencoded;charset=UTF-8")
    public String item(@RequestParam Map<String, String> body) throws Exception {
        body.keySet().forEach(log::debug);
        body.values().forEach(log::debug);

        Item[] items = mapper.readValue(body.get("Items"), Item[].class);
        for (Item i : items) {
            itemRepository.save(i);
            log.debug("parsed item: {}", i.getLabel());
        }
        log.info("parsed inventory successfully");
        return "";
    }

    @PostMapping(path = "/battery", consumes="application/x-www-form-urlencoded;charset=UTF-8")
    public String power(@RequestParam Map<String, String> body) throws Exception {
        body.keySet().forEach(log::debug);
        body.values().forEach(log::debug);

        Battery[] batteries = mapper.readValue(body.get("Battery"), Battery[].class);
        for (Battery b : batteries) {
            log.debug("parsed battery: {}", b.getLabel());
            powerRepository.save(b);
        }
        log.info("parsed battery successfully");
        return "";
    }
}
