

import processing.opengl.*;

import org.gicentre.utils.colour.*;
import org.gicentre.utils.io.*;
import org.gicentre.utils.gui.*;
import org.gicentre.utils.move.*;
import org.gicentre.utils.multisketch.*;
import org.gicentre.utils.stat.*;
import org.gicentre.utils.*;
import org.gicentre.utils.network.*;
import org.gicentre.utils.spatial.*;
import org.gicentre.utils.geom.*;



XYChart lineChart;
int valuesToRead = 100;
float vBatt=0;
int temp =0;
int error = 0;
int pos = 0;


  
  
  
  ArrayList dataArray = new ArrayList();
  ArrayList indexArray = new ArrayList();
  
  float[] data;
float[] filteredData;
float[] indeces;
float[] averagedData;
float[] speeds;

float a;
float b;
float g;
  
void setup()
{
 // size(1200, 720);
size(displayWidth, displayHeight);

  boolean connected = false;

  String lines[] = loadStrings("data.csv");
println("there are " + lines.length + " lines");

data = new float[lines.length];
filteredData = new float[lines.length];
indeces = new float[lines.length];
averagedData = new float[lines.length];
speeds = new float[lines.length];

for (int i =0 ; i < lines.length; i++) {
  data[i]=(int(lines[i]));
  indeces[i]=i;
}




 smooth();
 //noLoop();
  
  PFont font = createFont("Helvetica",11);
  textFont(font,10);

  // Both x and y data set here.  
  lineChart = new XYChart(this);
  
   lineChart.setData(new float[] {1,2},
                    new float[] { 0,0});
     // Axis formatting and labels.
    lineChart.showXAxis(false); 
    lineChart.showYAxis(true); 
   // lineChart.setMinY(-500);
   // lineChart.setMaxY(1000);
      
    lineChart.setYFormat("0");  // Monetary value in $US
    lineChart.setXFormat("0");      // Year
    
    // Symbol colours
    lineChart.setPointColour(color(180,50,50,100));
    lineChart.setPointSize(5);
    lineChart.setLineWidth(2);
  
   
  
 
 
}

/** Draws the chart and a title.
  */
void draw()
{
  
  
        float dt = 1/(float)1500;
        float xk_1 = 0, vk_1 = 0, ak_1=0;
         a = mouseX/(float)width;//0.1;
         b = ((float)mouseY*mouseY)/((float)height*height)/10;//0.05; 
         g = 0.1;
         
              if (mousePressed&& (mouseButton == LEFT)) {
              g=0;
              }else if (mousePressed&& (mouseButton == CENTER)) {
              g=0;
              }
         
        float xk =0, vk =0, rk =0, ak =0;
        float xm;
        
        int avg=5;

        for (int i =0 ; i < data.length; i++) 
        {
          if(i<avg)
          {
          averagedData[i]=data[i];
          }else
          {
            int sum=0;
            for(int j = 0; j< avg; j++)
            {
              sum+=data[i-j];
            }
           averagedData[i]=(float)sum/avg;
          }
          
                xm = averagedData[i];// input signal

                //predictions
              //  xk = xk_1 +  vk_1 * dt  + 0.5f*dt*dt*ak_1;
              //  vk = vk_1+dt*ak_1;
              //  ak = ak_1;
               xk = xk_1 + ( vk_1 * dt );
                vk = vk_1;
                
                //change
                rk = xm - xk;

                xk += a * rk;
                vk += (b * rk) / dt;// +ak_1 * dt;
             //   ak += rk * g;///(2*dt*dt);
                
                xk_1 = xk;
                vk_1 = vk;
              //  ak_1 = ak;
              
              if (mousePressed && (mouseButton == RIGHT)) {
             filteredData[i]=vk;
              }else if (mousePressed && (mouseButton == CENTER)) {
              filteredData[i]=vk;
              }else {
                 filteredData[i]=xk;
              }
                
               
        }


    background(255);
         // Draw a title over the top of the chart.
    fill(120);
    textSize(20);
    text("alpha = "+a+" beta =" +b +" gamma =" +g +" MouseX="+ mouseX +" MouseY=" + mouseY , 70,30);
    textSize(11);

        

  
 
 
 int startpoint=100;
 int endpoint = 1000;
 
 // if (mousePressed) {
    lineChart.setPointColour(color(180,50,50,100));
    lineChart.setData(Arrays.copyOfRange(indeces,startpoint,endpoint), Arrays.copyOfRange(averagedData,startpoint,endpoint));
     lineChart.showXAxis(false); 
    lineChart.showYAxis(false); 
    lineChart.draw(15,15,width-30,height-30);
 // }
    lineChart.setPointColour(color(50,150,150,100));
    lineChart.setData(Arrays.copyOfRange(indeces,startpoint,endpoint), Arrays.copyOfRange(filteredData,startpoint,endpoint));
     lineChart.showXAxis(false); 
    lineChart.showYAxis(true); 
    lineChart.draw(15,15,width-30,height-30);
  
   

 
  
}

