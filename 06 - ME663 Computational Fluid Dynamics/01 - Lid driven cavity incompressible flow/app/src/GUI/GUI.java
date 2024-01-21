package GUI;

import java.awt.BorderLayout;
import java.awt.CardLayout;
import java.awt.Component;
import java.util.HashMap;
import java.util.Map;

import javax.swing.JFrame;
import javax.swing.JPanel;

import GUI.mainElements.MainFrame;
import GUI.mainElements.MainWindows;
import GUI.mainElements.MenuBar;
import GUI.panels.Home;
import GUI.panels.SimLauncher;
import GUI.panels.SimResults;
import models.MainModel;
import utils.Interfaces;

/**
 * The GUI class manages the graphical user interface of the application.
 * It handles the creation and navigation of panels, manages the application's
 * theme, and provides methods
 * for interacting with the user interface components.
 */
public class GUI {

    public Theme appTheme = new Theme();

    private CardLayout cardLayout = new CardLayout();
    private JFrame mainFrame = new MainFrame();
    private Interfaces.UIWindows mainWindowsArea = new MainWindows(cardLayout);
    private Map<String, Interfaces.UIPanel> Panels = new HashMap<>();
    private String currentID;

    private Home homePanel;
    private SimLauncher simLauncherPanel;
    private SimResults simResultsPanel;

    /**
     * Constructs a GUI instance for managing the application's user interface.
     *
     * @param mainModel The main model of the application.
     */
    public GUI(MainModel mainModel) {

        mainFrame.setJMenuBar(new MenuBar(this));
        mainFrame.add(mainWindowsArea.getMainPanel(), BorderLayout.CENTER);

        mainWindowsArea.getMainPanel().revalidate();
        mainWindowsArea.getMainPanel().repaint();

        homePanel = new Home(mainModel);
        simLauncherPanel = new SimLauncher(mainModel);
        simResultsPanel = new SimResults(mainModel);

    }

    /**
     * Adds the panels to the user interface.
     */
    public void addPanels() {
        addPanel(homePanel.createPanel(this));
        addPanel(simLauncherPanel.createPanel(this));
        addPanel(simResultsPanel.createPanel(this));
    }

    /**
     * Adds a panel to the user interface and registers it with the application's
     * theme.
     *
     * @param panel The panel to add.
     */
    public void addPanel(Interfaces.UIPanel Panel) {
        Panels.put(Panel.getID(), Panel);
        mainWindowsArea.getContentPanel().add((Component) Panel, Panel.getID());

        appTheme.registerPanel((JPanel) Panel);
        appTheme.applyTheme();
    }

    /**
     * Retrieves a UI panel by its unique ID.
     *
     * @param ID The ID of the panel to retrieve.
     * @return The UI panel with the specified ID, or null if not found.
     */
    public Interfaces.UIPanel getUIPanel(String ID) {
        return Panels.get(ID);
    }

    public Interfaces.UIWindows getMainWindowsArea() {
        return mainWindowsArea;
    }

    public CardLayout getCardLayout() {
        return cardLayout;
    }

    public String getCurrentID() {
        return currentID;
    }

    /**
     * Navigates to a specified panel by ID and triggers its onOpen method.
     *
     * @param ID   The ID of the panel to navigate to.
     * @param args An array of arguments to pass to the panel's onOpen method.
     */
    public void goToPanel(String ID, Object[] args) {
        try {
            cardLayout.show(mainWindowsArea.getContentPanel(), ID);
            getUIPanel(ID).onOpen(args);
            currentID = ID;
        } catch (Exception e) {
            // TODO: handle exception
            System.out.println("Errore: Panel non trovato.");
        }
    }

}
