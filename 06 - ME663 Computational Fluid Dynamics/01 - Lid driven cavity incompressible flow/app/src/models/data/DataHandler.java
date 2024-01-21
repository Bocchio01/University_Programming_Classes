package models.data;

public class DataHandler extends DataQuery {

    private static DataStorage dataStorage = new DataStorage();

    public DataHandler() {
        super(dataStorage);
    }


    public static void main(String[] args) {

        DataHandler dat = new DataHandler();
    }
}
