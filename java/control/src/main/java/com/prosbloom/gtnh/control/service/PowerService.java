package com.prosbloom.gtnh.control.service;

import com.prosbloom.gtnh.control.dto.Battery;
import com.prosbloom.gtnh.control.dto.Power;
import com.prosbloom.gtnh.control.repo.BatteryRepository;
import com.prosbloom.gtnh.control.repo.PowerRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class PowerService {
    @Autowired
    private PowerRepository powerRepository;

    public String getPowerStatus() {
        List<Power> powers = powerRepository.getCurrentPower();
        return powers.stream().map(Power::toString).collect(Collectors.joining(","));
    }
}
