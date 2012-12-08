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
  
  float[] filteredSpeedData;
  float[] medianSpeedData;
  float[] data;
float[] filteredData;
float[] indeces;
float[] averagedData;
float[] speedData;

float a;
float b;
  
void setup()
{
  size(displayWidth, displayHeight);

  boolean connected = false;

  String lines[] = loadStrings("data.csv");
println("there are " + lines.length + " lines");

data = new float[lines.length];
filteredData = new float[lines.length];
filteredSpeedData = new float[lines.length];
medianSpeedData = new float[lines.length];
indeces = new float[lines.length];
averagedData = new float[lines.length];
speedData = new float[lines.length];

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
  
  
  
         a = mouseX/(float)width;//0.1;
         b = ((float)mouseY*mouseY)/((float)height*height)/10;//0.03; 
       //  a=.1;
        // b=.03;

        
        int avg=4;//(int)(25*mouseX/(float)width); //number of samples to average for moving average filter
        
        averagedData=averageFilter(data,avg);
       
        alphaBeta(averagedData, filteredData, .1,.03);//a, b);
       
        getSpeeds(filteredData, speedData);
        
     //  filteredSpeedData=averageFilter(speedData, 2);
       
      // medianSpeedData=medianFilter(speedData , 2);
 
        alphaBeta(averageFilter(speedData, 2),filteredSpeedData, a, b);
        


    background(255);
         // Draw a title over the top of the chart.
    fill(120);
    textSize(20);
    text("alpha = "+a+" beta =" +b +" avg =" + avg +" MouseX="+ mouseX +" MouseY=" + mouseY , 70,30);
    textSize(11);

        

  
 
 
 int startpoint=500; //these two values define the window of data from our sample that we'll plot (the actual data is 8,281 samples)
 int endpoint = 1000;
 
 // if (!mousePressed) {
      lineChart.setPointColour(color(120,90,50,100));
    lineChart.setData(Arrays.copyOfRange(indeces,startpoint,endpoint), Arrays.copyOfRange(speedData,startpoint,endpoint));
    lineChart.draw(15,15,width-30,height-30);
    
 // } else{
      lineChart.setPointColour(color(20,20,150,100));
    lineChart.setData(Arrays.copyOfRange(indeces,startpoint,endpoint), Arrays.copyOfRange(filteredSpeedData,startpoint,endpoint));
    lineChart.draw(15,15,width-30,height-30);
 // }
    
    
    lineChart.setPointColour(color(180,50,50,100));
    lineChart.setData(Arrays.copyOfRange(indeces,startpoint,endpoint), Arrays.copyOfRange(filteredData,startpoint,endpoint));
    lineChart.draw(15,15,width-30,height-30);
    
    lineChart.setPointColour(color(50,150,150,100));
    lineChart.setData(Arrays.copyOfRange(indeces,startpoint,endpoint), Arrays.copyOfRange(averagedData,startpoint,endpoint));
    lineChart.draw(15,15,width-30,height-30);
    
  
 // }
   

 
  
}

 float[] averageFilter(float[] dataIn, int avg)
{
  
  float[] dataOut = new float[dataIn.length];
   for (int i =0 ; i < dataIn.length; i++) 
        {
          if(i<avg)
          {
          dataOut[i]=dataIn[i];
          }else
          {
            float sum=0;
           // print("avg=" + avg);
            for(int j = 0; j< avg; j++)
            {
              sum+=dataIn[i-j];
           //   print(" " + dataIn[i-j]);
            }
         
           dataOut[i]=(float)sum/(float)avg;
          // println("average=" + dataOut[i]);
           
     
          }
          
        }
        
        return dataOut;
}

float[] medianFilter(float[] dataIn, int count)
{
   Percentile p = new Percentile(); 
   double[] medianArray = new double[count];
   float[] dataOut = new float[dataIn.length];

   for (int i =0 ; i < dataIn.length; i++) 
        {
          if(i<count)
          {
          dataOut[i]=(float)dataIn[i];
          }else
          {
            for(int j = 0; j<count;j++)
            {
              medianArray[j]=(double)dataIn[j+i-count];
            }
         
           dataOut[i]=(float) p.evaluate(medianArray, 50);    
     
          }
          
        } 
        return dataOut;
}

void alphaBeta(float[] dataIn, float[] dataOut, float a, float b)
{
  
  
  float dt = 0.5;
        float xk_1 = 0, vk_1 = 0;
        float xk, vk, rk;
        float xm;
        
        for (int i =0 ; i < dataIn.length; i++) 
        {
         
                xm = dataIn[i];// input signal

                xk = xk_1 + ( vk_1 * dt );
                vk = vk_1;

                rk = xm - xk;

                xk += a * rk;
                vk += ( b * rk ) / dt;

                xk_1 = xk;
                vk_1 = vk;
              
   
              dataOut[i]=xk;
    
               // printf( "%f \t %f\n", xm, xk_1 );
               
        }
}

void getSpeeds(float[] dataIn, float[] dataOut)
{
        
        dataOut[0]=dataIn[0];
        
        for (int i =4 ; i < dataIn.length; i++) 
        {
              dataOut[i]=dataIn[i]-dataIn[i-4];
               
        }
}
