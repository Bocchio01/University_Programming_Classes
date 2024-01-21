package GUI.panels;

import javax.swing.*;

import GUI.GUI;
import GUI.Widget;
import GUI.layouts.TwoRows;
import models.MainModel;
import utils.Interfaces;

public class Home extends TwoRows implements Interfaces.UIPanel {

    public static String ID = "Home";
    private GUI gui;
    private MainModel mainModel;

    private JButton buttonToSimLauncher = new Widget.Button("Setup or launch simulation");
    private JButton buttonToSimResults = new Widget.Button("View past simulations results");

    public Home(MainModel mainModel) {
        this.mainModel = mainModel;
    }

    private void addActionEvent() {
    }

    @Override
    public Home createPanel(GUI gui) {
        this.gui = gui;

        addTop(new Widget.LogoLabel());
        addBottom(buttonToSimLauncher);
        addBottom(buttonToSimResults);

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
            Home home = new Home(mainModel);

            gui.addPanel(home.createPanel(gui));
            home.onOpen(args);
        });
    }
}
