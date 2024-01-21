package GUI.panels;

import javax.swing.*;

import GUI.GUI;
import GUI.Widget;
import GUI.layouts.TwoRows;
import models.MainModel;
import utils.Interfaces;

public class ExamplePanel extends TwoRows implements Interfaces.UIPanel {

    public static String ID = "ExamplePanel";
    private GUI gui;
    private MainModel mainModel;

    private JLabel labelWelcome = new JLabel("Benvenuto!");

    public ExamplePanel(MainModel mainModel) {
        this.mainModel = mainModel;
    }

    private void addActionEvent() {
    }

    @Override
    public ExamplePanel createPanel(GUI gui) {
        this.gui = gui;

        addTop(new Widget.LogoLabel());
        addBottom(labelWelcome);

        gui.appTheme.registerPanel(topPanel);
        gui.appTheme.registerPanel(bottomPanel);

        addActionEvent();

        return this;
    }

    @Override
    public String getID() {
        return ID;
    }

    @Override
    public void onOpen(Object[] args) {
    }

    public static void main(String[] args) {
        SwingUtilities.invokeLater(() -> {
            MainModel mainModel = new MainModel();
            GUI gui = new GUI(mainModel);
            ExamplePanel home = new ExamplePanel(mainModel);

            gui.addPanel(home.createPanel(gui));
            home.onOpen(args);
        });
    }
}
