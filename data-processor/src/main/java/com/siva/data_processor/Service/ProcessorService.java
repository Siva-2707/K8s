package com.siva.data_processor.Service;

import com.opencsv.CSVReader;
import com.opencsv.exceptions.CsvException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.io.*;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class ProcessorService {

    public Map<String,Object> processSum(Map<String,Object> input){
        Map<String,Object> response = new HashMap<>();
        String fileName = (String) input.get("file");
        response.put("file",fileName);
        try(FileReader reader = new FileReader("./files/"+fileName)){
            List<String[]> records = new CSVReader(reader).readAll();

            if(!validateCSV(records)){
                response.put("error","Input file not in CSV format.");
                return response;
            }

            String product = (String) input.get("product");
            Integer sum = records
                    .stream()
                    .map(Arrays::asList)
                    .filter(e -> e.get(0).compareTo(product) == 0)
                    .mapToInt(e -> Integer.parseInt(e.get(1)))
                    .sum();
            response.put("sum",sum);
        }
        catch (FileNotFoundException e){
            response.put("error","File not found.");
        }
        catch (CsvException e){
            response.put("error","Input file not in CSV format.");
        }
        catch (IOException e){
            e.printStackTrace();
        }
        return  response;
    }

    public boolean validateCSV(List<String[]> records){
        if(!records.isEmpty() && records.get(0)[0] != null){
            long count = records.stream()
                    .map(Arrays::asList)
                    .filter(e -> e.size() != 2)
                    .count();
            return count == 0;
        }
        return false;
    }

}
