package com.siva.data_validator.service;

import com.siva.data_validator.model.Input;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import static org.assertj.core.api.Assertions.assertThat;

import java.util.HashMap;
import java.util.Map;

@SpringBootTest
public class CalculateServiceTest {

    @Autowired
    CalculateService calculateService;

    @Test
    public void invalidFileNameTest(){
        Input input = new Input(null, "wheat");
        Map<String, Object> response = new HashMap<>();
        response.put("file", input.getFile());
        response.put("error","Invalid JSON input.");

        Map<String,Object> result = calculateService.calculate(input);

        assertThat(result).isEqualTo(response);

    }

}
