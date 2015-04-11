void rayasd1(float lim_inf, float lim_sup, int paso, int trazo, int largo_min, int rojo, int verde, int azul, int deltax, int deltay)
{

  x=0+paso-deltax;
  y=imgd.height+deltay;
  fin_lineax = 0;
  fin_lineay = 0;
  desdex = 0;  
  desdey = 0; 
  for (int z=-imgd.height; z < imgd.width; z=z+paso)

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


    while (y < imgd.height-1 && x < imgd.width-1) 
    { 

      int pos = y*imgd.width + x;

      float val = brightness(imgd.pixels[pos]);

      if ( val >= lim_inf && val <= lim_sup)
      {
        desdex = x;
        desdey = y;
        fin_lineax = x;
        fin_lineay = y;

        while ( val >= lim_inf && val <= lim_sup && x < imgd.width-1 && y < imgd.height-1)
        { 
          pos = y*imgd.width + x;
          val = brightness(imgd.pixels[pos]);
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
          output.println("G1 X" + desdex/escala +" Y"+ desdey/escala );
          output.println("M106");
          output.println("G1 X" + fin_lineax/escala + " Y" + fin_lineay/escala);


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
void rayasd2(float lim_inf, float lim_sup, int paso, int trazo, int largo_min, int rojo, int verde, int azul, int deltax, int deltay)
{

  x=0-deltax+imgd.width;

  y=imgd.height+deltay;
  fin_lineax = imgd.width;
  fin_lineay = 0;
  desdex = imgd.width+imgd.height;  
  desdey = 0; 
  for (int z=imgd.height+imgd.width; z > 0; z=z-paso)

  {


    if (z > imgd.width)
    {

      y=z-imgd.width+deltay;
      x=imgd.width+deltax;
    } else
    {
      y=0+deltay;
      x=z+deltax;
    }


    while (y < imgd.height-1 && x > 0) 
    { 

      int pos = y*imgd.width + x;

      float val = brightness(imgd.pixels[pos]);

      if ( val >= lim_inf && val <= lim_sup)
      {
        desdex = x;
        desdey = y;
        fin_lineax = x;
        fin_lineay = y;

        while ( val >= lim_inf && val <= lim_sup && x > 0 && y < imgd.height-1)
        { 
          pos = y*imgd.width + x;
          val = brightness(imgd.pixels[pos]);
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
          output.println("G1 X" + desdex/escala +" Y"+ desdey/escala );
          output.println("M106");
          output.println("G1 X" + fin_lineax/escala + " Y" + fin_lineay/escala);


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

