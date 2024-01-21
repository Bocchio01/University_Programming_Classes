package GUI.mainElements;

import java.awt.BorderLayout;
import java.awt.CardLayout;

import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.Timer;
import javax.swing.border.EmptyBorder;

import utils.Functions;
import utils.Interfaces;

/**
 * The MainWindows class represents the main user interface panel for the application.
 * It consists of a scrollable content panel, labels for application information and current data,
 * and a timer to update the current data label.
 */
public class MainWindows extends JPanel implements Interfaces.UIWindows {

    private JScrollPane scrollPane = new JScrollPane();
    private JPanel contentPanel = new JPanel();
    private JLabel labelAppInfo = new JLabel();
    private JLabel labelCurrentData = new JLabel();
    private JPanel bottomPanel = new JPanel();

     /**
     * Constructs a MainWindows panel with the specified CardLayout.
     *
     * @param cardLayout The CardLayout to use for managing content panels.
     */
    public MainWindows(CardLayout cardLayout) {
        super(new BorderLayout());

        contentPanel.setLayout(cardLayout);

        scrollPane.setViewportView(contentPanel);
        scrollPane.setHorizontalScrollBarPolicy(JScrollPane.HORIZONTAL_SCROLLBAR_AS_NEEDED);
        scrollPane.setVerticalScrollBarPolicy(JScrollPane.VERTICAL_SCROLLBAR_AS_NEEDED);

        bottomPanel.setLayout(new BorderLayout());
        bottomPanel.add(labelAppInfo, BorderLayout.WEST);
        bottomPanel.add(labelCurrentData, BorderLayout.EAST);

        bottomPanel.setBorder(new EmptyBorder(3, 7, 3, 7));

        add(scrollPane, BorderLayout.CENTER);
        add(bottomPanel, BorderLayout.SOUTH);

        new Timer(1000, e -> {
            String dateTime = Functions.getCurrentTimeDateString();
            labelCurrentData.setText(dateTime);
        }).start();
    }

    @Override
    public JPanel getMainPanel() {
        return this;
    }

    @Override
    public JScrollPane getScrollPane() {
        return scrollPane;
    }

    @Override
    public JPanel getContentPanel() {
        return contentPanel;
    }

    @Override
    public void setAppInfo(String text) {
        labelAppInfo.setText(text);
    }

}
