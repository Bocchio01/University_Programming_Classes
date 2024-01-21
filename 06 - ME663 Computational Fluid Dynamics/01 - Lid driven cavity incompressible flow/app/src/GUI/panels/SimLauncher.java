package GUI.panels;

import javax.swing.*;

import GUI.GUI;
import GUI.Widget;
import GUI.layouts.TwoRows;
import models.MainModel;
import utils.Interfaces;

public class SimLauncher extends TwoRows implements Interfaces.UIPanel {

    public static String ID = "SimLauncher";
    private GUI gui;
    private MainModel mainModel;

    private JLabel labelWelcome = new JLabel("Benvenuto!");
    private JButton buttonLaunch = new Widget.Button("Launch the simulation");

    public SimLauncher(MainModel mainModel) {
        this.mainModel = mainModel;
    }

    private void addActionEvent() {
    }

    @Override
    public SimLauncher createPanel(GUI gui) {
        this.gui = gui;

        addTop(new Widget.LogoLabel());
        addBottom(buttonLaunch);

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
            SimLauncher home = new SimLauncher(mainModel);

            gui.addPanel(home.createPanel(gui));
            home.onOpen(args);
        });
    }
}
