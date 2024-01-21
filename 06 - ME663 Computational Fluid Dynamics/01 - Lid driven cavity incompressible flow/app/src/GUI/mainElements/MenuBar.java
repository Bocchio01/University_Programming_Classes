package GUI.mainElements;

import java.awt.Cursor;
import java.awt.FlowLayout;

import javax.swing.JCheckBoxMenuItem;
import javax.swing.JMenuBar;
import javax.swing.JMenuItem;
import GUI.GUI;
import GUI.panels.Home;
import GUI.panels.SimLauncher;
import GUI.panels.SimResults;

/**
 * The MenuBar class represents a custom menu bar for the graphical user interface.
 * It includes menu items for navigating across the application.
 */
public class MenuBar extends JMenuBar {

    public MenuBar(GUI gui) {
        setLayout(new FlowLayout(FlowLayout.LEFT));

        JMenuItem itemHome = new JMenuItem("Home");
        JMenuItem itemSimLauncher = new JMenuItem("SimLauncher");
        JMenuItem itemSimResults = new JMenuItem("SimResults");
        JCheckBoxMenuItem itemToggleTheme = new JCheckBoxMenuItem("Dark theme");
        itemToggleTheme.setSelected(gui.appTheme.isDarkTheme());

        JMenuItem[] jMenuItems = new JMenuItem[] {
                itemHome,
                itemSimLauncher,
                itemSimResults,
                itemToggleTheme };

        itemHome.addActionListener(e -> {
            gui.goToPanel(Home.ID, null);
        });

        itemSimLauncher.addActionListener(e -> {
            gui.goToPanel(SimLauncher.ID, null);
        });

        itemSimResults.addActionListener(e -> {
            gui.goToPanel(SimResults.ID, null);
        });

        itemToggleTheme.addActionListener(e -> {
            gui.appTheme.toggleTheme();
        });

        add(itemHome);
        add(itemSimLauncher);
        add(itemSimResults);
        add(itemToggleTheme);

        for (JMenuItem jMenuItem : jMenuItems) {
            jMenuItem.setCursor(Cursor.getPredefinedCursor(Cursor.HAND_CURSOR));
        }
    }
}