import controlP5.*;

public class MenuBar {
  private ControlP5 cp5;
  private ListBox filesListBox;
  private int selectedFileIndex = -1;
  private int xPosition = 0;
  private int yPosition = 0;
  private String[] filenames;
  
  public MenuBar(PApplet p, String dataPath) {
    cp5 = new ControlP5(p);
    this.filenames = listFileNames(dataPath);
  }

  public void setXPosition(int x) {
    this.xPosition = x;
  }

  public void setYPosition(int y) {
    this.yPosition = y;
  }

  public int getSelectedFileIndex(){
    return selectedFileIndex;
  }
  
  public String getSelectedFileName(int selectedFileIndex){
    return filenames[selectedFileIndex];
  }
  

  public void init() {
    filesListBox = cp5.addListBox("filesList")
      .setPosition(xPosition, yPosition)   
        .setSize(120, 120)
          .setItemHeight(15)
            .setBarHeight(15)
              .setColorBackground(color(0))
                .setColorActive(color(50))
                  .setColorForeground(color(128));

    filesListBox.captionLabel().toUpperCase(true);
    filesListBox.captionLabel().set("Select file");
    filesListBox.captionLabel().setColor(0xffff0000);
    filesListBox.captionLabel().style().marginTop = 3;
    filesListBox.valueLabel().style().marginTop = 3;

    for (int i=0; i< this.filenames.length; i++) {
      ListBoxItem lbi = filesListBox.addItem(filenames[i], i);
      lbi.setColorBackground(0);
    }
    
     cp5.addButton("cuatricromia")
      .setPosition(xPosition, yPosition + 90)
        .setSize(60, 30)
          .setValue(0)
            .activateBy(ControlP5.RELEASE);

    cp5.addButton("crosshatch")
      .setPosition(xPosition, yPosition + 120)
        .setSize(60, 30)
          .setValue(0)
            .activateBy(ControlP5.RELEASE);


    cp5.addButton("contour")
      .setPosition(xPosition , yPosition + 150)
        .setSize(60, 30)
          .setValue(0)
            .activateBy(ControlP5.RELEASE);


    cp5.addButton("clear")
      .setPosition(xPosition, yPosition + 180)
        .setSize(60, 30)
          .setValue(0)
            .activateBy(ControlP5.RELEASE);



    cp5.addButton( "savejpg" )
      .setPosition(xPosition, yPosition + 210)
        .setSize( 60, 30 )
          .setValue(0)
            .activateBy(ControlP5.RELEASE);
  }

  public void controlEvent(ControlEvent theEvent) {
    if (theEvent.isGroup() && theEvent.name().equals("filesList")) {
      selectedFileIndex = (int)theEvent.group().value();
    }
  }

  private String[] listFileNames(String dir) {
    File file = new File(dir);
    if (file.isDirectory()) {
      String names[] = file.list(new FilenameFilter() {
        @Override
          public boolean accept(File dir, String name) {
          return !name.startsWith(".");
        }
      }
      );

      return names;
    } else {
      // If it's not a directory
      return null;
    }
  }
}

