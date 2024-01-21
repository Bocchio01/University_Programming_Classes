package models.record;

import utils.ENV;

public record ExampleRecord(
        Integer ID) {

    @Override
    public String toString() {
        String[] dataStrings = new String[] {
                ID.toString(),
        };

        return String.join(ENV.SEPARATOR, dataStrings);
    }
}
