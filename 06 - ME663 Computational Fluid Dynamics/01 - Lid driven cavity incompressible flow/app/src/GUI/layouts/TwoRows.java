package GUI.layouts;

import javax.swing.*;

import java.awt.*;

/**
 * The TwoRows class represents a JPanel with two sub-panels, one on the top and
 * one on the bottom.
 * It provides methods for adding components to the top and bottom sub-panels.
 */
public abstract class TwoRows extends JPanel {

    public JPanel topPanel;
    public JPanel bottomPanel;

    protected GridBagConstraints mainPanelConstrains = new GridBagConstraints() {
        {
            gridx = 0;
            gridy = GridBagConstraints.RELATIVE;
            weightx = 1;
            weighty = 1;
            anchor = GridBagConstraints.CENTER;
            fill = GridBagConstraints.BOTH;
        }
    };

    protected GridBagConstraints subPanelConstrains = new GridBagConstraints() {
        {
            gridx = 0;
            gridy = GridBagConstraints.RELATIVE;
            weightx = 1;
            weighty = 1;
            anchor = GridBagConstraints.CENTER;
        }
    };

    public TwoRows() {
        setLayout(new GridBagLayout());
        topPanel = new JPanel(new GridBagLayout());
        bottomPanel = new JPanel(new GridBagLayout());

        add(topPanel, mainPanelConstrains);
        add(bottomPanel, mainPanelConstrains);

    }

    /**
     * Adds a component to the top sub-panel.
     *
     * @param component The component to be added to the top sub-panel.
     */
    protected void addTop(Component component) {
        topPanel.add(component, subPanelConstrains);
    }

    /**
     * Adds a component to the bottom sub-panel.
     *
     * @param component The component to be added to the bottom sub-panel.
     */
    protected void addBottom(Component component) {
        bottomPanel.add(component, subPanelConstrains);
    }
}
