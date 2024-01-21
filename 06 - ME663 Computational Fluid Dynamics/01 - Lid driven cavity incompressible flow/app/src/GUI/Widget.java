package GUI;

import java.awt.Cursor;
import java.awt.GridBagConstraints;
import java.awt.GridBagLayout;
import java.awt.Image;
import java.awt.Insets;
import java.awt.image.BufferedImage;
import java.io.IOException;

import javax.imageio.ImageIO;
import javax.swing.ImageIcon;
import javax.swing.JButton;
import javax.swing.JComponent;
import javax.swing.JLabel;
import javax.swing.JPanel;

import utils.ENV;

/**
 * The Widget class provides a collection of reusable GUI components and panels
 * commonly used in the application.
 */
public class Widget {

    /**
     * The FormPanel class represents a JPanel used for form-like layouts.
     * It includes a label and an active area (e.g., input field) to create labeled
     * form elements.
     */
    public static class FormPanel extends JPanel {

        /**
         * Constructs a FormPanel with a specified label text and an active area
         * component.
         *
         * @param appTheme   The application's theme for styling.
         * @param labelText  The text to display as the label.
         * @param activeArea The active area component (e.g., input field).
         */
        public FormPanel(Theme appTheme, String labelText, JComponent activeArea) {
            super(new GridBagLayout());

            // Create and configure the label
            JLabel label = new JLabel(labelText);
            activeArea.setPreferredSize(ENV.GUI.WIDGET_DIMENSION);

            // Configure GridBagConstraints for layout
            GridBagConstraints gbc = new GridBagConstraints();
            gbc.gridx = 0;
            gbc.gridy = 0;
            gbc.anchor = GridBagConstraints.NORTHWEST;
            gbc.insets = new Insets(5, 5, 2, 5);
            add(label, gbc);

            gbc.gridy = 1;
            gbc.insets = new Insets(0, 5, 5, 5);
            add(activeArea, gbc);

            // Register the panel and label with the application's theme
            appTheme.registerPanel(this);
            appTheme.registerLabel(label);
        }
    }

    /**
     * The Button class represents a JButton with predefined styling and cursor
     * behavior.
     */
    public static class Button extends JButton {

        /**
         * Constructs a Button with the specified text.
         *
         * @param text The text to display on the button.
         */
        public Button(String text) {
            setText(text);
            setCursor(Cursor.getPredefinedCursor(Cursor.HAND_CURSOR));
            setPreferredSize(ENV.GUI.WIDGET_DIMENSION);
        }
    }

    /**
     * The LogoLabel class represents a JLabel for displaying a scaled application
     * logo.
     */
    public static class LogoLabel extends JLabel {

        /**
         * Constructs a LogoLabel with default scaling.
         */
        public LogoLabel() {
            this(2);
        }

        /**
         * Constructs a LogoLabel with custom scaling.
         *
         * @param scale The scaling factor for the logo.
         */
        public LogoLabel(double scale) {
            this((int) (200 * scale), (int) (186 * scale));
        }

        /**
         * Constructs a LogoLabel with specified width and height.
         *
         * @param width  The width of the logo.
         * @param height The height of the logo.
         */
        public LogoLabel(int width, int height) {
            setHorizontalAlignment(JLabel.CENTER);
            setVerticalAlignment(JLabel.CENTER);

            try {
                // Load and scale the application logo
                BufferedImage originalImage = ImageIO.read(getClass().getResource(ENV.Path.Assets.LOGO));
                Image scaledImage = originalImage.getScaledInstance(width, height, Image.SCALE_SMOOTH);

                // Set the scaled logo as the label's icon
                ImageIcon icon = new ImageIcon(scaledImage);
                setIcon(icon);

            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }

    /**
     * The ComboItem class represents an item for use in JComboBox components.
     * It includes a label and an associated integer value.
     */
    public static class ComboItem {
        private String label;
        private int value;

        /**
         * Constructs a ComboItem with a label and an integer value.
         *
         * @param label The label to display in the combo box.
         * @param value The integer value associated with the item.
         */
        public ComboItem(String label, int value) {
            this.label = label;
            this.value = value;
        }

        /**
         * Retrieves the integer value associated with the ComboItem.
         *
         * @return The integer value.
         */
        public int getValue() {
            return value;
        }

        /**
         * Returns the label of the ComboItem as a string representation.
         *
         * @return The label as a string.
         */
        @Override
        public String toString() {
            return label;
        }
    }
}
