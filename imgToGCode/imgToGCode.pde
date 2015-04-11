import controlP5.*;
import processing.pdf.*;
import blobDetection.*;
import java.io.*;
ControlP5 cp5;
ListBox l;
String archivo = "";
String[] filenames;
int cant = 0;
int fin_linea = 0;
int fin_lineax = 0;
int fin_lineay = 0;
int desde = 1;
int desdex = 0;  
int desdey = 0; 
int largo;
int vueltas;
int x=0;
int y=0;
float j=0;
int k=0;
int test;
int up = 0;
float escala = 3.3; //PARA ARCHIVO 800 X 600 : A3 2.5 A4 3.3
float computedC = 0;
float computedM = 0;
float computedY = 0;
float computedK = 0;
float r ;
float g ;
float b ;
int pos;
PrintWriter output;
PImage imgc;
PImage img;
PImage imgd;
PImage cimg;
PImage mimg;
PImage yimg;
PImage kimg;
PImage mini; 
String[] nomb = {
  ""
};
//*********************************
float levels = 3;                    // number of contours
float factor = 1/escala;                     // scale factor
boolean record;

float colorStart =  0;               // Starting dregee of color range in HSB Mode (0-360)
float colorRange =  255;             // color range / can also be negative
PFont font;


String dataPath = "";
String gcodePath = ""; 
String generatedImgs  = "";
String resultImgs = "";

void setup() {
  size(1200, 700);
  img = loadImage(archivo);

  background(255);


  dataPath = sketchPath + "/data";
  gcodePath = sketchPath + "/gcode";
  generatedImgs = sketchPath + "/generatedImages";
  resultImgs = sketchPath + "/resultImages";
  
  
  File dataDir = new File( dataPath);
  if (!dataDir.exists()) {
    try {
      dataDir.mkdir();
    } 
    catch(SecurityException se) {
      //handle it
    }
  }

  File gcodeDir = new File(gcodePath);
  if (!gcodeDir.exists()) {
    try {
      gcodeDir.mkdir();
    } 
    catch(SecurityException se) {
      //handle it
    }
  }
  File generatedImgsDir = new File(generatedImgs);
  if (!generatedImgsDir.exists()) {
    try {
      generatedImgsDir.mkdir();
    } 
    catch(SecurityException se) {
      //handle it
    }
  }
  File resultImgsDir = new File(resultImgs);
  if (!resultImgsDir.exists()) {
    try {
      resultImgsDir.mkdir();
    } 
    catch(SecurityException se) {
      //handle it
    }
  }

  filenames = listFileNames(dataPath);
  ControlP5.printPublicMethodsFor(ListBox.class);
  cp5 = new ControlP5(this);

  l = cp5.addListBox("myList")
    .setPosition(1000, 350)
      .setSize(120, 120)
        .setItemHeight(15)
          .setBarHeight(15)
            .setColorBackground(color(0))
              .setColorActive(color(50))
                .setColorForeground(color(128))
                  ;

  l.captionLabel().toUpperCase(true);
  l.captionLabel().set("Select file");
  l.captionLabel().setColor(0xffff0000);
  l.captionLabel().style().marginTop = 3;
  l.valueLabel().style().marginTop = 3;

  for (int i=0; i< filenames.length; i++) {
    ListBoxItem lbi = l.addItem(filenames[i], i);
    lbi.setColorBackground(0);
  }

  cp5.addButton("Crosshatch")
    .setPosition(1100, 40)
      // .setImages(loadImage("b1.jpg"), loadImage("b1.jpg"), loadImage("b1.jpg"))
      .setSize(60, 30)

        .setValue(0)
          .activateBy(ControlP5.RELEASE);


  cp5.addButton("Contour")
    .setPosition(1100, 80)
      //  .setImages(loadImage("b1.jpg"), loadImage("b1.jpg"), loadImage("b1.jpg"))
      .setSize(60, 30)

        .setValue(0)
          .activateBy(ControlP5.RELEASE);


  cp5.addButton("Clear")
    .setPosition(1100, 120)
      //  .setImages(loadImage("b1.jpg"), loadImage("b1.jpg"), loadImage("b1.jpg"))
      .setSize(60, 30)

        .setValue(0)
          .activateBy(ControlP5.RELEASE);



  cp5.addButton( "SaveJPG" )
    .setPosition( 1100, 160 )
      .setSize( 60, 30 )
        .setValue(0)
          .activateBy(ControlP5.RELEASE);



  //  font = createFont("Helvetica",80);
}




void draw() {

  fill(100);

  archivo = filenames[test];
  mini = loadImage(archivo);
  nomb = split(archivo, ".");
  fill(255);
  noStroke();
  rect(1000, 200, 200, 150);
  imageMode(CORNERS);
  image(mini, 1000, 200, 1000+(mini.width/8), 200+(mini.height/8));
}


void controlEvent(ControlEvent theEvent) {

  if (theEvent.isGroup()) {
    // an event from a group e.g. scrollList
    println(theEvent.group().value()+" from "+theEvent.group());
  }

  if (theEvent.isGroup() && theEvent.name().equals("myList")) {
    test = (int)theEvent.group().value();
    println("test "+test);
    noStroke();
    fill(255);
    rect(1000, 285, mini.width/8, mini.height/8);
  }
}

String[] listFileNames(String dir) {
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


void Crosshatch(int value) {
  //*******cuatricromia
  cuatricromia();
  vueltas = 0;

  //********************

  //background(255);


  //amarillo 
  imgd = loadImage(generatedImgs + "/yimg.jpg");
  cant = 0;
  output = createWriter(gcodePath + "/" + nomb[0]+"_amarillo.gcode");
  output.println("G21 G90");
  output.println("G0 F2000");
  rayasd1(  0.0, 13.0, 12, 1, 10, 255, 220, 0, 8, 0);
  rayasd2(  0.0, 26.0, 12, 1, 10, 255, 220, 0, 0, 8);
  rayasd1(  0.0, 40.0, 12, 1, 10, 255, 220, 0, 7, 0);
  rayasd2(  0.0, 53.0, 12, 1, 10, 255, 220, 0, 0, 7);
  rayasd1(  0.0, 34.0, 12, 1, 10, 255, 220, 0, 6, 0);
  rayasd2(  0.0, 80.0, 12, 1, 10, 255, 220, 0, 0, 6);
  rayasd1(  0.0, 68.0, 12, 1, 10, 255, 220, 0, 5, 0);
  rayasd2(  0.0, 107.0, 12, 1, 10, 255, 220, 0, 0, 5);
  rayasd1(  0.0, 102.0, 12, 1, 10, 255, 220, 0, 4, 0);
  rayasd2(  0.0, 134.0, 12, 1, 10, 255, 220, 0, 0, 4);
  rayasd1(  0.0, 136.0, 12, 1, 10, 255, 220, 0, 3, 0);
  rayasd2(  0.0, 160.0, 12, 1, 10, 255, 220, 0, 0, 3);
  rayasd1(  0.0, 170.0, 12, 1, 10, 255, 220, 0, 2, 0);
  rayasd2(  0.0, 187.0, 12, 1, 10, 255, 220, 0, 0, 2);
  rayasd1(  0.0, 200.0, 12, 1, 10, 255, 220, 0, 1, 0);
  rayasd2(  0.0, 214.0, 12, 1, 10, 255, 220, 0, 0, 1);
  rayasd1(  0.0, 241.0, 12, 1, 10, 255, 220, 0, 0, 0);
  rayasd2(  0.0, 241.0, 12, 1, 10, 255, 220, 0, 0, 0);
  output.println("M107");
  output.println("G0 X0.0 Y0.0");
  output.println("M107");
  output.flush(); // Write the remaining data
  output.close(); // Finish the file
  println(cant); 



  //magenta 
  imgd = loadImage(generatedImgs + "/mimg.jpg");
  cant = 0;
  output = createWriter(gcodePath + "/" +nomb[0]+"_magenta.gcode");
  output.println("G21 G90");
  output.println("G0 F2000");
  rayasd1(  0.0, 13.0, 12, 1, 10, 255, 80, 120, 8, 0);
  rayasd2(  0.0, 26.0, 12, 1, 10, 255, 80, 120, 0, 8);
  rayasd1(  0.0, 40.0, 12, 1, 10, 255, 80, 120, 7, 0);
  rayasd2(  0.0, 53.0, 12, 1, 10, 255, 80, 120, 0, 7);
  rayasd1(  0.0, 67.0, 12, 1, 10, 255, 80, 120, 6, 0);
  rayasd2(  0.0, 80.0, 12, 1, 10, 255, 80, 120, 0, 6);
  rayasd1(  0.0, 93.0, 12, 1, 10, 255, 80, 120, 5, 0);
  rayasd2(  0.0, 107.0, 12, 1, 10, 255, 80, 120, 0, 5);
  rayasd1(  0.0, 121.0, 12, 1, 10, 255, 80, 120, 4, 0);
  rayasd2(  0.0, 134.0, 12, 1, 10, 255, 80, 120, 0, 4);
  rayasd1(  0.0, 147.0, 12, 1, 10, 255, 80, 120, 3, 0);
  rayasd2(  0.0, 160.0, 12, 1, 10, 255, 80, 120, 0, 3);
  rayasd1(  0.0, 174.0, 12, 1, 10, 255, 80, 120, 2, 0);
  rayasd2(  0.0, 187.0, 12, 1, 10, 255, 80, 120, 0, 2);
  rayasd1(  0.0, 200.0, 12, 1, 10, 255, 80, 120, 1, 0);
  rayasd2(  0.0, 214.0, 12, 1, 10, 255, 80, 120, 0, 1);
  rayasd1(  0.0, 228.0, 12, 1, 10, 255, 80, 120, 0, 0);
  rayasd2(  0.0, 241.0, 12, 1, 10, 255, 80, 120, 0, 0); 
  output.println("M107");
  output.println("G0 X0.0 Y0.0");
  output.println("M107");
  output.flush(); // Write the remaining data
  output.close(); // Finish the file
  println(cant); 



  //cian 
  imgd = loadImage(generatedImgs + "/cimg.jpg");
  cant = 0;
  output = createWriter(gcodePath + "/" +nomb[0]+"_cian.gcode");
  output.println("G21 G90");
  output.println("G0 F2000");
  rayasd2(  0.0, 13.0, 12, 1, 10, 0, 255, 255, 0, 8);
  rayasd1(  0.0, 26.0, 12, 1, 10, 0, 255, 255, 8, 0);
  rayasd2(  0.0, 40.0, 12, 1, 10, 0, 255, 255, 0, 7);
  rayasd1(  0.0, 53.0, 12, 1, 10, 0, 255, 255, 7, 0);
  rayasd2(  0.0, 67.0, 12, 1, 10, 0, 255, 255, 0, 6);
  rayasd1(  0.0, 80.0, 12, 1, 10, 0, 255, 255, 6, 0);
  rayasd2(  0.0, 93.0, 12, 1, 10, 0, 255, 255, 0, 5);
  rayasd1(  0.0, 107.0, 12, 1, 10, 0, 255, 255, 5, 0);
  rayasd2(  0.0, 121.0, 12, 1, 10, 0, 255, 255, 0, 4);
  rayasd1(  0.0, 134.0, 12, 1, 10, 0, 255, 255, 4, 0);
  rayasd2(  0.0, 147.0, 12, 1, 10, 0, 255, 255, 0, 3);
  rayasd1(  0.0, 160.0, 12, 1, 10, 0, 255, 255, 3, 0);
  rayasd2(  0.0, 174.0, 12, 1, 10, 0, 255, 255, 0, 2);
  rayasd1(  0.0, 187.0, 12, 1, 10, 0, 255, 255, 2, 0);
  rayasd2(  0.0, 200.0, 12, 1, 10, 0, 255, 255, 0, 1);
  rayasd1(  0.0, 214.0, 12, 1, 10, 0, 255, 255, 1, 0);
  rayasd2(  0.0, 228.0, 12, 1, 10, 0, 255, 255, 0, 0);
  rayasd1(  0.0, 241.0, 12, 1, 10, 0, 255, 255, 0, 0);
  output.println("M107");
  output.println("G0 X0.0 Y0.0");
  output.println("M107");
  output.flush(); // Write the remaining data
  output.close(); // Finish the file
  println(cant);




  //negro 
  imgd = loadImage(generatedImgs + "/kimg.jpg");
  cant = 0;
  output = createWriter(gcodePath + "/" +nomb[0]+"_negro.gcode");
  output.println("G21 G90");
  output.println("G0 F2000");
  rayasd1(  0.0, 13.0, 12, 1, 10, 0, 0, 0, 0, 8);
  rayasd2(  0.0, 26.0, 12, 1, 10, 0, 0, 0, 8, 0);
  rayasd1(  0.0, 40.0, 12, 1, 10, 0, 0, 0, 7, 0);
  rayasd2(  0.0, 53.0, 12, 1, 10, 0, 0, 0, 0, 7);
  rayasd1(  0.0, 67.0, 12, 1, 10, 0, 0, 0, 6, 0);
  rayasd2(  0.0, 80.0, 12, 1, 10, 0, 0, 0, 0, 6);
  rayasd1(  0.0, 93.0, 12, 1, 10, 0, 0, 0, 5, 0);
  rayasd2(  0.0, 107.0, 12, 1, 10, 0, 0, 0, 0, 5);
  rayasd1(  0.0, 121.0, 12, 1, 10, 0, 0, 0, 4, 0);
  rayasd2(  0.0, 134.0, 12, 1, 10, 0, 0, 0, 0, 4);
  rayasd1(  0.0, 147.0, 12, 1, 10, 0, 0, 0, 3, 0);
  rayasd2(  0.0, 160.0, 12, 1, 10, 0, 0, 0, 0, 3);
  rayasd1(  0.0, 174.0, 12, 1, 10, 0, 0, 0, 2, 0);
  rayasd2(  0.0, 187.0, 12, 1, 10, 0, 0, 0, 0, 2);
  rayasd1(  0.0, 200.0, 12, 1, 10, 0, 0, 0, 1, 0);
  rayasd2(  0.0, 214.0, 12, 1, 10, 0, 0, 0, 0, 1);
  rayasd1(  0.0, 228.0, 12, 1, 10, 0, 0, 0, 0, 0);
  rayasd2(  0.0, 241.0, 12, 1, 10, 0, 0, 0, 0, 0); 

  output.println("M107");
  output.println("G0 X0.0 Y0.0");
  output.println("M107");
  output.flush(); // Write the remaining data
  output.close(); // Finish the file
  println(cant);
}



void SaveJPG(int value) {
  imgc = get(0, 0, img.width, img.height);
  imgc.save(resultImgs+ "/final.jpg");
}






void Clear(int value)
{
  background(255);
}

/*
//********************************************
 void rayasd3(float lim_inf, float lim_sup, int paso, int trazo, int largo_min, int rojo, int verde, int azul, int deltax, int deltay)
 {
 
 
 
 
 
 
 
 }
 //********************************************
 
 
 
 void avanza(dir){
 
 if(dir == 1)
 {
 if (x < imgd.width && y < imgd.height)
 {
 x = x + dir;
 y = y + dir;
 }
 
 
 
 }  
 
 if(dir == -1)
 {
 if(x > 0 && y > 0)
 {
 x = x + dir;
 y = y + dir;
 }
 } 
 
 }
 
 
 void limite()
 {
 if ( y = imgd.height)
 {
 if( x < imgd.width - paso)
 {
 x = x + paso;
 dir = dir * -1;
 }
 else
 {
 y = y - (imgd.width - x)  ;
 x = imgd.width;
 dir = dir * -1;
 }  
 if (x == 0)
 {
 
 }  
 }
 
 if( y == 0)
 {
 if(x < imgd.width - paso)
 {  
 x = x + paso;
 dir = dir * -1;
 }
 else
 ´     {
 x = imgd.width;
 }
 
 
 } 
 
 
 
 
 
 } 
 
 */
