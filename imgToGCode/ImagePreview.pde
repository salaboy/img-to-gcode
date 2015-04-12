public class ImagePreview {
  private int xPosition = 0;
  private int yPosition = 0;
  private PImage originalImage;
  private String originalName;

  public ImagePreview(String imageFileName) {
    this.originalName = imageFileName;
    originalImage = loadImage(imageFileName);
  }

  public void setXPosition(int x) {
    this.xPosition = x;
  }

  public void setYPosition(int y) {
    this.yPosition = y;
  }
  
  public String getOriginalName(){
    return this.originalName;
  }
  
  public int getOriginalWidth(){
    return originalImage.width;
  }
  
  public int getOriginalHeight(){
    return originalImage.height;
  }
  
  public PImage getOriginalImage(){
    return originalImage;
  }

  public void showPreview() {
    fill(255);
    noStroke();
    rect(xPosition, yPosition,(originalImage.width/8), (originalImage.height/8));
    // Drawing scaled preview
    image(originalImage, xPosition, yPosition, (originalImage.width/8), (originalImage.height/8));
  }
}

