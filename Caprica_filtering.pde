import netscape.javascript.*;

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
//import org.apache.commons.math.*;

import processing.serial.*;

XYChart lineChart;
int valuesToRead = 100;
float vBatt=0;
int temp =0;
int error = 0;
int pos = 0;


  
  
  
  ArrayList dataArray = new ArrayList();
  ArrayList indexArray = new ArrayList();
  
  int medianCount = 50;
  
  double[] data;
  double[] medianArray;
float[] filteredData;
float[] indeces;
float[] averagedData;
double[] speedData;

float a;
float b;
  
void setup()
{
  size(displayWidth, displayHeight);

  boolean connected = false;

  String lines[] = loadStrings("data.csv");
println("there are " + lines.length + " lines");

data = new double[lines.length];
filteredData = new float[lines.length];
indeces = new float[lines.length];
averagedData = new float[lines.length];
speedData = new double[lines.length];
medianArray = new double[medianCount];

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
    //lineChart.setMinY(0);
      
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
  Percentile p = new Percentile();
  
  
  float dt = 0.5;
        float xk_1 = 0, vk_1 = 0;
         a = mouseX/(float)width;//0.1;
         b = ((float)mouseY*mouseY)/((float)height*height)/10;//0.03; 
       //  a=.1;
        // b=.03;

        float xk, vk, rk;
        float xm;
        
        int avg=5; //number of samples to average for moving average filter

        for (int i =0 ; i < data.length; i++) 
        {
          if(i<avg)
          {
          averagedData[i]=(float)data[i];
          }else
          {
            int sum=0;
            
            //medianArray=Arrays.copyOfRange(data,i-medianCount,i);
            
            for(int j = 0; j< avg; j++)
            {
              sum+=data[i-j];
            }
         
        // if (!mousePressed) {
           averagedData[i]=(float)sum/avg;//(float)p.evaluate(medianArray, 50);    //(float)sum/avg;
      //   } else{
        //   averagedData[i]=(float)data[i-2];//(float)sum/avg;
       //  }
          }
          
                xm = averagedData[i];// input signal

                xk = xk_1 + ( vk_1 * dt );
                vk = vk_1;

                rk = xm - xk;

                xk += a * rk;
                vk += ( b * rk ) / dt;
                
               // speedData[i]=xk-xk_1;

                xk_1 = xk;
                vk_1 = vk;
              
             // if (mousePressed) {
              speedData[i]=vk_1; //if the mouse is pressed, display velocity data, otherwise display position data
              averagedData[i]=vk_1;
          //   }else{
            if(i>=medianCount){
            medianArray=Arrays.copyOfRange(speedData,i-medianCount,i);
                 filteredData[i]=(float)p.evaluate(medianArray, 50);
            }else{
              filteredData[i]=0;
            }
            //  }
               // printf( "%f \t %f\n", xm, xk_1 );
               
        }


    background(255);
         // Draw a title over the top of the chart.
    fill(120);
    textSize(20);
    text("alpha = "+a+" beta =" +b +" MouseX="+ mouseX +" MouseY=" + mouseY , 70,30);
    textSize(11);

        

  
 
 
 int startpoint=200; //these two values define the window of data from our sample that we'll plot (the actual data is 8,281 samples)
 int endpoint = 1000;
 
  if (mousePressed) {
    lineChart.setPointColour(color(180,50,50,100));
    lineChart.setData(Arrays.copyOfRange(indeces,startpoint,endpoint), Arrays.copyOfRange(filteredData,startpoint,endpoint));
    lineChart.draw(15,15,width-30,height-30);
  } else{
    lineChart.setPointColour(color(50,150,150,100));
    lineChart.setData(Arrays.copyOfRange(indeces,startpoint,endpoint), Arrays.copyOfRange(averagedData,startpoint,endpoint));
    lineChart.draw(15,15,width-30,height-30);
    
   // lineChart.setPointColour(color(20,20,150,100));
   // lineChart.setData(Arrays.copyOfRange(indeces,startpoint,endpoint), Arrays.copyOfRange(speedData,startpoint,endpoint));
   // lineChart.draw(15,15,width-30,height-30);
  }
   

 
  
}

void averageFilter(double[] dataIn, double[] dataOut, int avg)
{
   for (int i =0 ; i < dataIn.length; i++) 
        {
          if(i<avg)
          {
          averagedData[i]=(float)data[i];
          }else
          {
            int sum=0;
            
            //medianArray=Arrays.copyOfRange(data,i-medianCount,i);
            
            for(int j = 0; j< avg; j++)
            {
              sum+=data[i-j];
            }
         
           dataOut[i]=(float)sum/avg;//(float)p.evaluate(medianArray, 50);    //(float)sum/avg;
     
          }
          
        } 
}


