


class Cuatricromia {
  private PImage originalImage;
  private PImage cimg;
  private PImage mimg;
  private PImage yimg;
  private PImage kimg;
  private float r;
  private float g;
  private float b;
  private float computedC = 0;
  private float computedM = 0;
  private float computedY = 0;
  private float computedK = 0;
  private int pos = 0;

  public Cuatricromia(PImage image) {
    originalImage = image;
    originalImage.loadPixels();
    cimg = createImage(originalImage.width, originalImage.height, RGB);
    mimg = createImage(originalImage.width, originalImage.height, RGB);
    yimg = createImage(originalImage.width, originalImage.height, RGB);
    kimg = createImage(originalImage.width, originalImage.height, RGB);
  }

  public void calculate() {
    for (int y = 1; y < originalImage.height-1; y++) {   // Skip top and bottom edges
      for (int x = 1; x < originalImage.width-1; x++) {

        pos = y*originalImage.width + x;
        r = red(originalImage.pixels[pos]);  
        g = green(originalImage.pixels[pos]);
        b = blue(originalImage.pixels[pos]);
        // BLACK


        computedC = 1.0 - (r/255);
        computedM = 1.0 - (g/255);
        computedY = 1.0 - (b/255);

        float minCMY = min(computedC, computedM, computedY);

        computedC = (computedC - minCMY) / (1 - minCMY) ;
        computedM = (computedM - minCMY) / (1 - minCMY) ;
        computedY = (computedY - minCMY) / (1 - minCMY) ;
        computedK = minCMY;


        cimg.pixels[y*cimg.width + x] = color(int(255 * (1 - computedC)));
        mimg.pixels[y*mimg.width + x] = color(int(255 * (1 - computedM)));
        yimg.pixels[y*yimg.width + x] = color(int(255 * (1 - computedY)));
        kimg.pixels[y*kimg.width + x] = color(int(255 * (1 - computedK)));
      }
    }

    cimg.updatePixels();
    mimg.updatePixels();
    yimg.updatePixels();
    kimg.updatePixels();
  }

  public void saveImages(String path) {
    yimg.save(path+"/yellow-img.jpg");
    mimg.save(path+"/magenta-img.jpg");
    cimg.save(path+"/cyan-img.jpg");
    kimg.save(path+"/black-img.jpg");
  }

  public void showPreview(int x, int y) {
    rect(x, y, 300, 300);
    tint(255, 255, 0, 128);
    image(yimg, x, y, (yimg.width/7), (yimg.height/7));
    tint(255, 0, 255, 128); 
    image(mimg, x + 150, y, (mimg.width/7), (mimg.height/7));
    tint(0, 255, 255, 128);
    image(cimg, x, y+150, (cimg.width/7), (cimg.height/7));
    noTint();
    image(kimg, x+150, y+150, (kimg.width/7), (kimg.height/7));
  }
}

