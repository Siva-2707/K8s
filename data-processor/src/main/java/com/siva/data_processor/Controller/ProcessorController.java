package com.siva.data_processor.Controller;

import com.siva.data_processor.Service.ProcessorService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

@RestController
public class ProcessorController {

    @Autowired
    ProcessorService processorService;

    @PostMapping("/calculateSum")
    public Map<String, Object> processSum(@RequestBody  Map<String, Object> input){
        System.out.println("In controller");
        return processorService.processSum(input);
    }

}
