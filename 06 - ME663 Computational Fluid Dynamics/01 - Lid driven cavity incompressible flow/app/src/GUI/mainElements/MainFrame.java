package GUI.mainElements;

import java.awt.BorderLayout;
import java.awt.Image;
import java.io.IOException;

import javax.imageio.ImageIO;
import javax.swing.ImageIcon;
import javax.swing.JFrame;

import GUI.Widget;
import utils.ENV;

/**
 * The MainFrame class represents the main window of the application.
 * It extends the JFrame class and sets the size, location, title, icon, and layout of the window.
 */
public class MainFrame extends JFrame {

    public MainFrame() {
        setSize(ENV.GUI.FRAME_WIDTH, ENV.GUI.FRAME_HEIGHT);
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        setLocationRelativeTo(null);
        setVisible(true);

        setTitle(ENV.APP_TITLE);
        setIcon(ENV.Path.Assets.LOGO);
        setLayout(new BorderLayout());
    }

    /**
     * Sets the icon of the window.
     *
     * @param iconPath The path of the icon.
     */
    private void setIcon(String iconPath) {
        ImageIcon iconImage = new ImageIcon();
        
        try {
            Image originalImage = ImageIO.read(Widget.class.getResource(iconPath));
            iconImage = new ImageIcon(originalImage);
        } catch (IOException e) {
            // TODO Auto-generated catch block
        }

        setIconImage(iconImage.getImage());
    }
}
