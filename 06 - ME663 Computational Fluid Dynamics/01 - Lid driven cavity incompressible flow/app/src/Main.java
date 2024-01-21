import GUI.GUI;
import GUI.panels.Home;
import models.MainModel;

class Main {

    public GUI gui;
    public MainModel mainModel;

    public Main() {
        mainModel = new MainModel();
    }

    public void lauchGUI() {
        gui = new GUI(mainModel);
        gui.addPanels();
        gui.goToPanel(Home.ID, null);
    }

    public void lauchCMD(String[] args) {
        // cmd = new CMD(mainModel);
        // cmd.run(args);
        // RecordCity city = mainModel.dataHandler.dataQuery.getCityBy(3178229);
        // System.out.println(city);
    }

    public static void main(String[] args) {
        Main mainIstance = new Main();

        if (args.length == 0) {
            mainIstance.lauchGUI();
        } else {
            mainIstance.lauchCMD(args);
            // TODO: Add command line arguments
        }
    }

}
