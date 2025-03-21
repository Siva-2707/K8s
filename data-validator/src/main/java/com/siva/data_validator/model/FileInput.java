package com.siva.data_validator.model;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class FileInput {
    private String file;
    private String data;
}
