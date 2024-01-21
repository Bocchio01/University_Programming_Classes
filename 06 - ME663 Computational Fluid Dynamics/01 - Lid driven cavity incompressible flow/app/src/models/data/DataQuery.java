package models.data;

import java.util.List;

public class DataQuery {

    private DataStorage dataStorage;

    public DataQuery(DataStorage dataStorage) {
        this.dataStorage = dataStorage;
    }

    public static class QueryCondition {
        private String key;
        private Object value;

        public QueryCondition(String key, Object value) {
            this.key = key;
            this.value = value;
        }

        public String getKey() {
            return key;
        }

        public Object getValue() {
            return value;
        }

        public boolean hasMultipleValues() {
            return value instanceof List;
        }
    }

}
