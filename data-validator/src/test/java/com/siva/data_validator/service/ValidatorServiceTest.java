package com.siva.data_validator.service;


import org.junit.jupiter.api.Test;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.ValueSource;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import static org.assertj.core.api.Assertions.assertThat;

@SpringBootTest
public class ValidatorServiceTest {

    @Autowired
    public ValidatorService validatorService;

    @ParameterizedTest
    @ValueSource(strings = {"","null"})
    public void invalidFileNameTest(String fileName){
        fileName = fileName.equals("null") ? null : fileName;
        boolean validation = validatorService.validateFileName(fileName);
        assertThat(validation).isFalse();
    }

    @Test
    public void validFileNameTest(){
        String fileName = "data.dat";
        boolean validation = validatorService.validateFileName(fileName);
        assertThat(validation).isTrue();
    }

}
