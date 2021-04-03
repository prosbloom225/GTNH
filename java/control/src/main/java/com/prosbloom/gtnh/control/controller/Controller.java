package com.prosbloom.gtnh.control.controller;
import com.fasterxml.jackson.core.JsonParser;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.prosbloom.gtnh.control.dto.Fluid;
import com.prosbloom.gtnh.control.dto.Item;
import com.prosbloom.gtnh.control.dto.Battery;
import com.prosbloom.gtnh.control.dto.Power;
import com.prosbloom.gtnh.control.repo.FluidRepository;
import com.prosbloom.gtnh.control.repo.ItemRepository;
import com.prosbloom.gtnh.control.repo.BatteryRepository;
import com.prosbloom.gtnh.control.repo.PowerRepository;
import com.prosbloom.gtnh.control.service.BatteryService;
import com.prosbloom.gtnh.control.service.PowerService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
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
    private FluidRepository fluidRepository;

    @Autowired
    private BatteryRepository batteryRepository;

    @Autowired
    private PowerRepository powerRepository;

    @Autowired
    private BatteryService batteryService;

    @Autowired
    private PowerService powerService;

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

    @PostMapping(path = "/fluid", consumes="application/x-www-form-urlencoded;charset=UTF-8")
    public String fluid(@RequestParam Map<String, String> body) throws Exception {
        body.keySet().forEach(log::debug);
        body.values().forEach(log::debug);

        Fluid[] fluids= mapper.readValue(body.get("Fluids"), Fluid[].class);
        for (Fluid f : fluids) {
            fluidRepository.save(f);
            log.debug("parsed item: {}", f.getLabel());
        }
        log.info("parsed fluids successfully");
        return "";
    }

    @PostMapping(path = "/battery", consumes="application/x-www-form-urlencoded;charset=UTF-8")
    public String battery(@RequestParam Map<String, String> body) throws Exception {
        body.keySet().forEach(log::debug);
        body.values().forEach(log::debug);

        Battery[] batteries = mapper.readValue(body.get("Battery"), Battery[].class);
        for (Battery b : batteries) {
            log.debug("parsed battery: {} - {}/{}", b.getLabel(), b.getCurrPower(), b.getMaxPower());
            batteryRepository.save(b);
        }
        log.info("parsed battery successfully");
        return "";
    }
    @PostMapping(path = "/power", consumes="application/x-www-form-urlencoded;charset=UTF-8")
    public String power(@RequestParam Map<String, String> body) throws Exception {
        body.keySet().forEach(log::debug);
        body.values().forEach(log::debug);

        Power[] powers= mapper.readValue(body.get("Power"), Power[].class);
        for (Power p : powers) {
            log.debug("parsed power: {}", p.getLabel());
            Power prev = powerRepository.findFirstByLabelOrderByTimestampDesc(p.getLabel());
            // TODO - move to compare operator .. account for all relevant fields
            if (prev == null || prev.getEnabled() != p.getEnabled() || prev.getMaintenance() != p.getMaintenance())
                powerRepository.save(p);
        }
        log.info("parsed power successfully");
        return "";
    }

    @GetMapping(path = "/getBatteryTotal")
    public String getBatteryTotal() throws Exception {
        return batteryService.getBatteryLevels();
    }

    @GetMapping(path = "/getPowers")
    public String getPowers() throws Exception {
        return powerService.getPowerStatus();
    }
}
