package com.siva.data_validator.service;

import com.siva.data_validator.model.FileInput;
import org.springframework.stereotype.Service;

import java.io.File;
import java.io.FileWriter;
import java.util.HashMap;
import java.util.Map;

@Service
public class FileService {

    public Map<String,Object> storeFile(FileInput fileInput){
        Map<String,Object> response = new HashMap<>();

        //Checking if the directory exists.
        File dir = new File("/sivarajesh_PV_dir/");
        if(!dir.exists()){
            dir.mkdir();
        }
        String fileName = fileInput.getFile();
        if(fileName == null || fileName.compareTo("") == 0){
            response.put("file",null);
            response.put("error","Invalid JSON input.");
            return response;
        }
        String data = fileInput.getData();
        //Creating new file with the data.
        File file = new File("/sivarajesh_PV_dir/"+fileName);
        try(FileWriter writer = new FileWriter(file)){
           writer.write(data);
        }
        catch (Exception e){
            e.printStackTrace();
            response.put("file",fileName);
            response.put("error","Error while storing the file to the storage.");
            return response;
        }
        response.put("file",fileName);
        response.put("message","Success.");
        return response;
    }

}
