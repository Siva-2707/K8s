package com.siva.data_validator.service;

import com.siva.data_validator.model.Input;
import org.springframework.stereotype.Service;

@Service
public class ValidatorService {

    public boolean validateFileName(String fileName){
        return fileName != null && !fileName.isEmpty();
    }

}
