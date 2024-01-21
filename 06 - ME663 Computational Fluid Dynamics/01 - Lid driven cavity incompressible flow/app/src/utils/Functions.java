package utils;

import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.Date;

public class Functions {

    public static final String datePattern = "dd/MM/yyyy";

    public static String getCurrentDateString() {
        LocalDate currentDate = LocalDate.now();
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern(datePattern);

        return currentDate.format(formatter);
    }

    public static boolean isDateValid(String dateString) {
        try {
            DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern(datePattern);
            LocalDate date = LocalDate.parse(dateString, dateFormatter);

            return !date.isAfter(LocalDate.now());
        } catch (DateTimeParseException e) {
            return false;
        }
    }

    public static String getCurrentTimeDateString() {
        SimpleDateFormat dateFormat = new SimpleDateFormat("HH:mm:ss dd/MM/yyyy");
        return dateFormat.format(new Date());
    }
}
