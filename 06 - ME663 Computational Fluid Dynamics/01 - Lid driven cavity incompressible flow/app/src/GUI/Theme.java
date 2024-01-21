package GUI;

import java.awt.Color;
import java.util.ArrayList;
import java.util.List;

import javax.swing.JLabel;
import javax.swing.JPanel;

/**
 * The Theme class manages the visual theme of the application, including dark and light modes.
 * It allows toggling between themes and applying the selected theme to registered labels and panels.
 */
public class Theme {

    private boolean darkMode = true;
    private final static Color LIGHT_BLUE = new Color(153, 255, 255);
    private final static Color DARK_GRAY = new Color(49, 51, 56);

    private List<JLabel> labels = new ArrayList<>();
    private List<JPanel> panels = new ArrayList<>();

    /**
     * Toggles the application's theme between dark and light modes and applies the selected theme.
     */
    public void toggleTheme() {
        darkMode = !darkMode;
        applyTheme();
    }

    /**
     * Checks if the dark theme is currently enabled.
     *
     * @return True if dark mode is enabled, false if not.
     */
    public boolean isDarkTheme() {
        return darkMode;
    }

    /**
     * Registers a JLabel with the theme for theme-specific styling.
     *
     * @param label The JLabel to register.
     */
    public void registerLabel(JLabel label) {
        labels.add(label);
    }

    /**
     * Registers a JPanel with the theme for theme-specific styling.
     *
     * @param panel The JPanel to register.
     */
    public void registerPanel(JPanel panel) {
        panels.add(panel);
    }

    /**
     * Applies the current theme to all registered labels and panels.
     */
    public void applyTheme() {
        for (JLabel label : labels) {
            applyThemeToLabel(label);
        }
        for (JPanel panel : panels) {
            applyThemeToPanel(panel);
        }
    }

    /**
     * Applies the current theme to a JPanel by setting its background color.
     *
     * @param panel The JPanel to apply the theme to.
     */
    public void applyThemeToPanel(JPanel panel) {
        if (isDarkTheme()) {
            panel.setBackground(DARK_GRAY);
        } else {
            panel.setBackground(LIGHT_BLUE);
        }
    }

    /**
     * Applies the current theme to a JLabel by setting its foreground (text) color.
     *
     * @param label The JLabel to apply the theme to.
     */
    public void applyThemeToLabel(JLabel label) {
        if (isDarkTheme()) {
            label.setForeground(Color.WHITE);
        } else {
            label.setForeground(Color.BLACK);
        }
    }
}
