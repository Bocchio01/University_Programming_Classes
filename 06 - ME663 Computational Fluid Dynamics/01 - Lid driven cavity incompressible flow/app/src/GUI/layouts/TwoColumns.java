package GUI.layouts;

import javax.swing.*;

import java.awt.*;

/**
 * The TwoColumns class represents a JPanel with two sub-panels, one on the left
 * and one on the right.
 * It provides methods for adding components to the left and right sub-panels.
 */
public abstract class TwoColumns extends JPanel {

    public JPanel leftPanel;
    public JPanel rightPanel;

    protected GridBagConstraints mainPanelConstrains = new GridBagConstraints() {
        {
            gridx = GridBagConstraints.RELATIVE;
            gridy = 0;
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

    public TwoColumns() {
        setLayout(new GridBagLayout());
        leftPanel = new JPanel(new GridBagLayout());
        rightPanel = new JPanel(new GridBagLayout());

        add(leftPanel, mainPanelConstrains);
        add(rightPanel, mainPanelConstrains);

    }

    /**
     * Adds a component to the left sub-panel.
     *
     * @param component The component to be added to the left sub-panel.
     */
    protected void addLeft(Component component) {
        leftPanel.add(component, subPanelConstrains);
    }

    /**
     * Adds a component to the right sub-panel.
     *
     * @param component The component to be added to the right sub-panel.
     */
    protected void addRight(Component component) {
        rightPanel.add(component, subPanelConstrains);
    }
}
