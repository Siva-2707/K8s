package com.siva.data_validator.service;

import com.siva.data_validator.model.Input;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.net.URI;
import java.util.HashMap;
import java.util.Map;

@Service
public class CalculateService {

    @Autowired
    ValidatorService validatorService;

//    @Value("${server.port}")
//    int port;

    RestTemplate restTemplate = new RestTemplate();

    public Map<String, Object> calculate(Input input){
        Map<String,Object> response = new HashMap<>();
        boolean isValid = validatorService.validateFileName(input.getFile());
        if(!isValid){
            response= new HashMap<>();
            response.put("file", input.getFile());
            response.put("error","Invalid JSON input.");
        }
        else{
//            if(port == 8080)
//                response =  restTemplate.postForObject("http://localhost:6060/calculateSum",input,response.getClass());
//            else
                response =  restTemplate.postForObject("http://data-processor:6060/calculateSum",input,response.getClass());
        }
        return response;
    }
}
