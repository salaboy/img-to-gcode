void cuatricromia()
{
  img = loadImage(archivo);
  img.loadPixels();
  // Create an opaque image of the same size as the original
  PImage cimg = createImage(img.width, img.height, RGB);
  PImage mimg = createImage(img.width, img.height, RGB);
  PImage yimg = createImage(img.width, img.height, RGB);
  PImage kimg = createImage(img.width, img.height, RGB);

  for (int y = 1; y < img.height-1; y++) {   // Skip top and bottom edges
    for (int x = 1; x < img.width-1; x++) {

      pos = y*img.width + x;
      r = red(img.pixels[pos]);  
      g = green(img.pixels[pos]);
      b = blue(img.pixels[pos]);
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

  cimg.save(generatedImgs+"/cimg.jpg");
  mimg.save(generatedImgs+"/mimg.jpg");
  yimg.save(generatedImgs+"/yimg.jpg");
  kimg.save(generatedImgs+"/kimg.jpg");


  rect(850, 500, 300, 300);
  tint(255, 255, 0, 128);
  image(yimg, 850, 500, 850+(yimg.width/7), 500+(yimg.height/7));
  tint(255, 0, 255, 128); 
  image(mimg, 1000, 500, 1000+(mimg.width/7), 500+(mimg.height/7));
  tint(0, 255, 255, 128);
  image(cimg, 850, 600, 850+(cimg.width/7), 600+(cimg.height/7));
  noTint();
  image(kimg, 1000, 600, 1000+(kimg.width/7), 600+(kimg.height/7));
}

