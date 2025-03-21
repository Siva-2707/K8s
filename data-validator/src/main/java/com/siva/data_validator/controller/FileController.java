package com.siva.data_validator.controller;

import com.siva.data_validator.model.FileInput;
import com.siva.data_validator.service.FileService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

@RestController
public class FileController {

    @Autowired
    private FileService fileService;

    @PostMapping("/store-file")
    public Map<String,Object> storeFile(@RequestBody FileInput fileInput){
        return  fileService.storeFile(fileInput);
    }

}
