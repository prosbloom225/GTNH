package com.prosbloom.gtnh.control.service;

import com.prosbloom.gtnh.control.dto.Battery;
import com.prosbloom.gtnh.control.repo.BatteryRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class BatteryService {
    @Autowired
    private BatteryRepository batteryRepository;

    public String getBatteryLevels() {
        List<Battery> batteries = batteryRepository.getLatestBatteries();
        BigDecimal currPower = batteries.stream().map(Battery::getCurrPower).reduce(BigDecimal.ZERO, BigDecimal::add);
        BigDecimal maxPower = batteries.stream().map(Battery::getMaxPower).reduce(BigDecimal.ZERO, BigDecimal::add);
        return String.format("%s/%s", currPower, maxPower);
    }
}
