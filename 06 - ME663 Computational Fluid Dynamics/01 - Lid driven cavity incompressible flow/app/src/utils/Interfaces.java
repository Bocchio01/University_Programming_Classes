package utils;

import javax.swing.JPanel;
import javax.swing.JScrollPane;

import GUI.GUI;

public class Interfaces {

    public interface ExampleRecord {
        Integer getID();
    }

    public interface UIWindows {
        JPanel getMainPanel();
    
        JScrollPane getScrollPane();
    
        JPanel getContentPanel();
    
        void setAppInfo(String text);
    }

    public interface UIPanel {
        JPanel createPanel(GUI gui);
    
        void onOpen(Object[] args);
    
        String getID();
    }
}
