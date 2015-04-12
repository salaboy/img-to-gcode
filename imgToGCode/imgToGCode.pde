
import processing.pdf.*;
import blobDetection.*;
import java.io.*;

MenuBar menuBar;
ImagePreview imgPreview;

String selectedImageFileName;
String dataPath = "";
String gcodePath = ""; 
String generatedImgs  = "";
String resultImgs = "";

float globalScale = 3.3; //PARA ARCHIVO 800 X 600 : A3 2.5 A4 3.3


void setup() {
  size(1200, 700);
 
  background(255);

  dataPath = sketchPath + "/data";
  gcodePath = sketchPath + "/gcode";
  generatedImgs = sketchPath + "/generatedImages";
  resultImgs = sketchPath + "/resultImages";

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

  menuBar = new MenuBar(this, dataPath);
  menuBar.setXPosition(1000);
  menuBar.setYPosition(100);
  menuBar.init();
}

public void controlEvent(ControlEvent theEvent) {
  menuBar.controlEvent(theEvent);
}

void draw() {

  fill(100);
  if ( menuBar.getSelectedFileIndex() >= 0) {
    selectedImageFileName = menuBar.getSelectedFileName(menuBar.getSelectedFileIndex());
    imgPreview = new ImagePreview(selectedImageFileName);
    imgPreview.setXPosition(1000);
    imgPreview.setYPosition(400);
    imgPreview.showPreview();

  }
}

void cuatricromia(int value){
  Cuatricromia c = new Cuatricromia(imgPreview.getOriginalImage().get());
  c.calculate();
  c.saveImages(generatedImgs);
  c.showPreview(1000,550);
}

void contour(int value){
  ContourAlgorithm c = new ContourAlgorithm(imgPreview.getOriginalImage().get(), globalScale, 3);
  c.calculate();
  
}

void crosshatch(int value) {
  
  CrossHatchAlgorithm c = new CrossHatchAlgorithm(imgPreview.getOriginalName(), globalScale);

  c.drawColour("yellow", generatedImgs + "/yellow-img.jpg", 255, 220, 0);

  c.drawColour("magenta", generatedImgs + "/magenta-img.jpg", 255, 80, 120);

  c.drawColour("cyan", generatedImgs + "/cyan-img.jpg", 0, 255, 255);

  c.drawColour("black", generatedImgs + "/black-img.jpg", 0, 0, 0);
   
}

public void savejpg(int value) {
  PImage imgc = get(0, 0, imgPreview.getOriginalWidth(), imgPreview.getOriginalHeight());
  imgc.save(resultImgs+ "/"+imgPreview.getOriginalName()+"-final.jpg");
}

public void clear(int value){
  background(255);
}

