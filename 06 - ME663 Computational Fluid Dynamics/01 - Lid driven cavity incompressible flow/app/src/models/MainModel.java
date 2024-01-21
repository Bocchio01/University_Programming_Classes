package models;

import models.data.DataHandler;
import models.data.DataStorage;
import models.logic.ExampleLogic;

/**
 * The MainModel class represents the core model of the application.
 * It encapsulates various components for handling files, data storage, and logic operations.
 */
public class MainModel {
    

    public DataStorage dataStorage;
    public DataHandler data;

    public ExampleLogic exampleLogic;


    public MainModel() {

        data = new DataHandler();

        exampleLogic = new ExampleLogic(data);

    }
}
