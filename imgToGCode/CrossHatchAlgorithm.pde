
class CrossHatchAlgorithm {
  private String imageName;
  private int fin_linea = 0;
  private int fin_lineax = 0;
  private int fin_lineay = 0;
  private int desde = 1;
  private int desdex = 0;  
  private int desdey = 0; 
  private int largo;

  private int x=0;
  private int y=0;
  private float j=0;
  private int k=0;
  private int cant = 0;
  private float scale = 1.0;
  private PrintWriter output;

  public CrossHatchAlgorithm(String name, float scale) {
    
    this.imageName = name;
    this.scale = scale;
  }
  
  

  public void drawColour(String colourName, String imagePath, int red, int green, int blue ) {

    cant = 0;
    PImage colourImage = loadImage(imagePath);

    output = createWriter(gcodePath + "/" + imageName+"_"+colourName+".gcode");
    output.println("G21 G90");
    output.println("G0 F2000");

    lineLtoR(colourImage,  0.0, 13.0, 12, 1, 10, red, green, blue, 8, 0);
    lineRtoL(colourImage,  0.0, 26.0, 12, 1, 10, red, green, blue, 0, 8);
    lineLtoR(colourImage,  0.0, 40.0, 12, 1, 10, red, green, blue, 7, 0);
    lineRtoL(colourImage,  0.0, 53.0, 12, 1, 10, red, green, blue, 0, 7);
    lineLtoR(colourImage,  0.0, 34.0, 12, 1, 10, red, green, blue, 6, 0);
    lineRtoL(colourImage,  0.0, 80.0, 12, 1, 10, red, green, blue, 0, 6);
    lineLtoR(colourImage,  0.0, 68.0, 12, 1, 10, red, green, blue, 5, 0);
    lineRtoL(colourImage,  0.0, 107.0, 12, 1, 10, red, green, blue, 0, 5);
    lineLtoR(colourImage,  0.0, 102.0, 12, 1, 10, red, green, blue, 4, 0);
    lineRtoL(colourImage,  0.0, 134.0, 12, 1, 10, red, green, blue, 0, 4);
    lineLtoR(colourImage,  0.0, 136.0, 12, 1, 10, red, green, blue, 3, 0);
    lineRtoL(colourImage,  0.0, 160.0, 12, 1, 10, red, green, blue, 0, 3);
    lineLtoR(colourImage,  0.0, 170.0, 12, 1, 10, red, green, blue, 2, 0);
    lineRtoL(colourImage,  0.0, 187.0, 12, 1, 10, red, green, blue, 0, 2);
    lineLtoR(colourImage,  0.0, 200.0, 12, 1, 10, red, green, blue, 1, 0);
    lineRtoL(colourImage,  0.0, 214.0, 12, 1, 10, red, green, blue, 0, 1);
    lineLtoR(colourImage,  0.0, 228.0, 12, 1, 10, red, green, blue, 0, 0);
    lineRtoL(colourImage,  0.0, 241.0, 12, 1, 10, red, green, blue, 0, 0);

    output.println("M107");
    output.println("G0 X0.0 Y0.0");
    output.println("M107");
    output.flush(); // Write the remaining data
    output.close(); // Finish the file
    
    println(cant);
    
    
  }

  public void lineLtoR(PImage img, float lim_inf, float lim_sup, int paso, int trazo, int largo_min, int rojo, int verde, int azul, int deltax, int deltay)
  {

    x=0+paso-deltax;
    y=img.height+deltay;
    fin_lineax = 0;
    fin_lineay = 0;
    desdex = 0;  
    desdey = 0; 
    for (int z=-img.height; z < img.width; z=z+paso)

    {


      if (z <= 0)
      {

        y=y+z+deltay;
        x=0+deltax;
      } else
      {
        y=0;
        x=z+deltax;
      }


      while (y < img.height-1 && x < img.width-1) 
      { 

        int pos = y*img.width + x;

        float val = brightness(img.pixels[pos]);

        if ( val >= lim_inf && val <= lim_sup)
        {
          desdex = x;
          desdey = y;
          fin_lineax = x;
          fin_lineay = y;

          while ( val >= lim_inf && val <= lim_sup && x < img.width-1 && y < img.height-1)
          { 
            pos = y*img.width + x;
            val = brightness(img.pixels[pos]);
            fin_lineax = fin_lineax+1;
            fin_lineay = fin_lineay+1;
            x++;
            y++;
          }  

          stroke(rojo, verde, azul);
          strokeWeight(trazo);
          if ((fin_lineax - desdex) > largo_min) {
            line(desdex, desdey, fin_lineax, fin_lineay);

            output.println("M107");
            output.println("G1 X" + desdex/scale +" Y"+ desdey/scale );
            output.println("M106");
            output.println("G1 X" + fin_lineax/scale + " Y" + fin_lineay/scale);


            cant++;
          }
        } else
        {
          x++;
          y++;
        }
      }
    }
  }


  //****************************************
  public void lineRtoL(PImage img, float lim_inf, float lim_sup, int paso, int trazo, int largo_min, int rojo, int verde, int azul, int deltax, int deltay)
  {

    x=0-deltax+img.width;

    y=img.height+deltay;
    fin_lineax = img.width;
    fin_lineay = 0;
    desdex = img.width+img.height;  
    desdey = 0; 
    for (int z=img.height+img.width; z > 0; z=z-paso)

    {


      if (z > img.width)
      {

        y=z-img.width+deltay;
        x=img.width+deltax;
      } else
      {
        y=0+deltay;
        x=z+deltax;
      }


      while (y < img.height-1 && x > 0) 
      { 

        int pos = y*img.width + x;

        float val = brightness(img.pixels[pos]);

        if ( val >= lim_inf && val <= lim_sup)
        {
          desdex = x;
          desdey = y;
          fin_lineax = x;
          fin_lineay = y;

          while ( val >= lim_inf && val <= lim_sup && x > 0 && y < img.height-1)
          { 
            pos = y*img.width + x;
            val = brightness(img.pixels[pos]);
            fin_lineax = fin_lineax-1;
            fin_lineay = fin_lineay+1;
            x--;
            y++;
          }  

          stroke(rojo, verde, azul);
          strokeWeight(trazo);
          if ((desdex - fin_lineax) > largo_min) {  
            line(desdex, desdey, fin_lineax, fin_lineay);


            output.println("M107");
            output.println("G1 X" + desdex/scale +" Y"+ desdey/scale );
            output.println("M106");
            output.println("G1 X" + fin_lineax/scale + " Y" + fin_lineay/scale);


            cant++;
          }
        } else
        {
          x--;
          y++;
        }
      }
    }
  }
}

