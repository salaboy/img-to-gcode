// Array of BlobDetection Instances
BlobDetection[] yellowBlobDetection = new BlobDetection[int(levels)];
BlobDetection[] magentaBlobDetection = new BlobDetection[int(levels)];
BlobDetection[] cianBlobDetection = new BlobDetection[int(levels)];
BlobDetection[] blackBlobDetection = new BlobDetection[int(levels)];
//*********************************


void Contour(int value) {



  cuatricromia();
  output = createWriter(gcodePath + "/yline.gcode");
  output.println("G21 G90");
  output.println("G0 F2000");
  imgd = loadImage(generatedImgs + "/yimg.jpg");
  for (int i=1; i<levels; i++) {
    yellowBlobDetection[i] = new BlobDetection(imgd.width, imgd.height);
    yellowBlobDetection[i].setPosDiscrimination(true);
    yellowBlobDetection[i].setThreshold(i/levels);
    fastblur(imgd, 2);
    yellowBlobDetection[i].computeBlobs(imgd.pixels);
  }


  for (int i=1; i<levels; i++) {

    drawContours(i, yellowBlobDetection, 255, 255, 0);
  }
  output.flush(); // Write the remaining data
  output.close(); // Finish the file


    output = createWriter(gcodePath + "/mline.gcode");
  output.println("G21 G90");
  output.println("G0 F2000");
  imgd = loadImage(generatedImgs + "/mimg.jpg");
  for (int i=1; i<levels; i++) {
    magentaBlobDetection[i] = new BlobDetection(imgd.width, imgd.height);
    magentaBlobDetection[i].setPosDiscrimination(true);
    magentaBlobDetection[i].setThreshold(i/levels);
    fastblur(imgd, 2);
    magentaBlobDetection[i].computeBlobs(imgd.pixels);
  }


  for (int i=1; i<levels; i++) {

    drawContours(i, magentaBlobDetection, 255, 0, 255);
  }
  output.flush(); // Write the remaining data
  output.close(); // Finish the file


    output = createWriter(gcodePath + "/cline.gcode");
  output.println("G21 G90");
  output.println("G0 F2000");
  imgd = loadImage(generatedImgs + "/cimg.jpg");
  for (int i=1; i<levels; i++) {
    cianBlobDetection[i] = new BlobDetection(imgd.width, imgd.height);
    cianBlobDetection[i].setPosDiscrimination(true);
    cianBlobDetection[i].setThreshold(i/levels);
    fastblur(imgd, 2);
    cianBlobDetection[i].computeBlobs(imgd.pixels);
  }  


  for (int i=1; i<levels; i++) {

    drawContours(i, cianBlobDetection, 0, 255, 255);
  }
  output.flush(); // Write the remaining data
  output.close(); // Finish the file

    output = createWriter(gcodePath + "/kline.gcode");
  output.println("G21 G90");
  output.println("G0 F2000"); 
  imgd = loadImage(generatedImgs + "/kimg.jpg");
  for (int i=1; i<levels; i++) {
    blackBlobDetection[i] = new BlobDetection(imgd.width, imgd.height);
    blackBlobDetection[i].setPosDiscrimination(true);
    blackBlobDetection[i].setThreshold(i/levels);
    fastblur(imgd, 2);
    blackBlobDetection[i].computeBlobs(imgd.pixels);
  }

  for (int i=1; i<levels; i++) {

    drawContours(i, blackBlobDetection, 0, 0, 0);
  } 


  output.flush(); // Write the remaining data
  output.close(); // Finish the file
}

void drawContours(int i, BlobDetection[] cmyk, int re, int gr, int bl) {

  Blob b;
  EdgeVertex eA, eB, eAnt, eBnt;


  for (int n=0; n<cmyk[i].getBlobNb (); n++) {
    b=cmyk[i].getBlob(n);
    if (b!=null) {
      stroke(re, gr, bl);
      strokeWeight(2);
      println(b.getEdgeNb());
      if (b.getEdgeNb() > 50)
      {
        output.println("M107");
        eA = b.getEdgeVertexA(0);
        eB = b.getEdgeVertexB(0);
        output.println("G0 X"+eA.x*img.width*factor+" Y"+eA.y*img.height*factor);
        output.println("M106");


        for (int m=1; m<b.getEdgeNb (); m++) {
          eAnt = eA;
          eBnt = eB;

          eA = b.getEdgeVertexA(m);
          eB = b.getEdgeVertexB(m);
          if (eA !=null && eB !=null)
          {
            if (eA.x != eB.x || eA.y != eB.y )

            {

              line(
              eA.x*img.width, eA.y*img.height, 
              eB.x*img.width, eB.y*img.height 
                );
              if (m % 5 == 0)
              {


                if (abs(eA.x*img.width*factor - eAnt.x*img.width*factor) > 20) {
                  output.println("M107");
                  up = 1;
                }
                output.println("G0 X"+eA.x*img.width*factor+" Y"+eA.y*img.height*factor);
                if (up == 1) {
                  output.println("M106");
                  up = 0;
                }
              }

              cant++;
            }
          }
        }
      }
    }
  }
  output.println("M107");  
  output.println("G0 X0 Y0");
}


// ==================================================
// Super Fast Blur v1.1
// by Mario Klingemann 
// <http://incubator.quasimondo.com>
// ==================================================
void fastblur(PImage img, int radius)
{
  if (radius<1) {
    return;
  }
  int w=img.width;
  int h=img.height;
  int wm=w-1;
  int hm=h-1;
  int wh=w*h;
  int div=radius+radius+1;
  int r[]=new int[wh];
  int g[]=new int[wh];
  int b[]=new int[wh];
  int rsum, gsum, bsum, x, y, i, p, p1, p2, yp, yi, yw;
  int vmin[] = new int[max(w, h)];
  int vmax[] = new int[max(w, h)];
  int[] pix=img.pixels;
  int dv[]=new int[256*div];
  for (i=0; i<256*div; i++) {
    dv[i]=(i/div);
  }

  yw=yi=0;

  for (y=0; y<h; y++) {
    rsum=gsum=bsum=0;
    for (i=-radius; i<=radius; i++) {
      p=pix[yi+min(wm, max(i, 0))];
      rsum+=(p & 0xff0000)>>16;
      gsum+=(p & 0x00ff00)>>8;
      bsum+= p & 0x0000ff;
    }
    for (x=0; x<w; x++) {

      r[yi]=dv[rsum];
      g[yi]=dv[gsum];
      b[yi]=dv[bsum];

      if (y==0) {
        vmin[x]=min(x+radius+1, wm);
        vmax[x]=max(x-radius, 0);
      }
      p1=pix[yw+vmin[x]];
      p2=pix[yw+vmax[x]];

      rsum+=((p1 & 0xff0000)-(p2 & 0xff0000))>>16;
      gsum+=((p1 & 0x00ff00)-(p2 & 0x00ff00))>>8;
      bsum+= (p1 & 0x0000ff)-(p2 & 0x0000ff);
      yi++;
    }
    yw+=w;
  }

  for (x=0; x<w; x++) {
    rsum=gsum=bsum=0;
    yp=-radius*w;
    for (i=-radius; i<=radius; i++) {
      yi=max(0, yp)+x;
      rsum+=r[yi];
      gsum+=g[yi];
      bsum+=b[yi];
      yp+=w;
    }
    yi=x;
    for (y=0; y<h; y++) {
      pix[yi]=0xff000000 | (dv[rsum]<<16) | (dv[gsum]<<8) | dv[bsum];
      if (x==0) {
        vmin[y]=min(y+radius+1, hm)*w;
        vmax[y]=max(y-radius, 0)*w;
      }
      p1=x+vmin[y];
      p2=x+vmax[y];

      rsum+=r[p1]-r[p2];
      gsum+=g[p1]-g[p2];
      bsum+=b[p1]-b[p2];

      yi+=w;
    }
  }
}

