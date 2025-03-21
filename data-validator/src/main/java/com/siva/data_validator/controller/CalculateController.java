package com.siva.data_validator.controller;

import com.siva.data_validator.model.Input;
import com.siva.data_validator.service.CalculateService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

@RestController
public class CalculateController {

    @Autowired
    CalculateService calculateService;

    @PostMapping("/calculate")
    public Map<String, Object> calculate(@RequestBody Input input){
        return calculateService.calculate(input);
    }

}
