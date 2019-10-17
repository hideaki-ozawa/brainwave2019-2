import oscP5.*;
import netP5.*;

private static float sum(float[] list){
  float ans = 0;
  for(int i = 0; i < list.length ; i++){
    ans += list[i];
  }
  return ans;
}

final int N_CHANNELS = 4;
final int wavetype = 3;
final int BUFFER_SIZE = 60;
final float MAX_MICROVOLTS = 1682.815;
final float DISPLAY_SCALE = 200.0;


final color BG_COLOR = color(0, 0, 0);
final color AXIS_COLOR = color(255, 0, 0);
final color GRAPH_COLOR = color(0, 0, 255);
final color LABEL_COLOR = color(255, 255, 0);


final int LABEL_SIZE = 21;
final int PORT = 5000;


OscP5 oscP5 = new OscP5(this, PORT);
float[][][] buffer = new float[wavetype][N_CHANNELS][BUFFER_SIZE];
int pointer = 0;
float[] offsetX = new float[N_CHANNELS];
float[] offsetY = new float[N_CHANNELS];
float[][] value = new float[wavetype][BUFFER_SIZE];

void setup(){
 size(1000, 600);
 frameRate(30);
 smooth();
 for(int ch = 0; ch < N_CHANNELS; ch++){
   offsetX[ch] = (width / N_CHANNELS) * ch + 15;
   offsetY[ch] = height / 2;
 }
 
 textSize(24);
}


void draw(){
 float evalue = 0;
 float beta_sum = 0;
 float gamma_sum = 0;
 String wave; 
 float[][] type_sum = new float[wavetype][BUFFER_SIZE];
 background(BG_COLOR);
 
 for(int t = 0; t < wavetype; t++){
   for(int ch = 0; ch < N_CHANNELS; ch++){
     type_sum[t][pointer] += buffer[t][ch][pointer]; 
     fill(0,255,0);
     wave = nf(buffer[t][ch][pointer],1,3);
     text(wave,40,t*150+ch*30+60);
   }
   text("mean:"+nf(type_sum[t][pointer]/4,1,3),150,60+t*150);
   text(str(pointer),width-40,40);
 }

 fill(255,100,0);
 beta_sum = (sum(buffer[1][0])+sum(buffer[1][1])+sum(buffer[1][2])+sum(buffer[1][3]))/(4*60); 
 gamma_sum = (sum(buffer[2][0])+sum(buffer[2][1])+sum(buffer[2][2])+sum(buffer[2][3]))/(4*60);
 evalue = beta_sum + 2.5*gamma_sum;
 ellipse(500,500,  20*evalue, 20*evalue);
 fill(0,255,0);
 text("beta_sum:" + nf(beta_sum,1,3),350,210);
 text("gamma_sum:" + nf(gamma_sum,1,3),350,360);
 text("sample",350,60);
}


void oscEvent(OscMessage msg){
 float[] data = new float[wavetype];
 
 if(msg.checkAddrPattern("/muse/elements/alpha_relative")){
   for(int ch = 0; ch < N_CHANNELS; ch++){
     data[0] = msg.get(ch).floatValue();
     //data[0] = (data[0] - (MAX_MICROVOLTS / 2)) / (MAX_MICROVOLTS / 2); // -1.0 1.0
     buffer[0][ch][pointer] = data[0];
   }
 }
 
 if(msg.checkAddrPattern("/muse/elements/beta_relative")){
   for(int ch = 0; ch < N_CHANNELS; ch++){
     data[1] = msg.get(ch).floatValue();
     //data[1] = (data[1] - (MAX_MICROVOLTS / 2)) / (MAX_MICROVOLTS / 2); // -1.0 1.0
     buffer[1][ch][pointer] = data[1];
   }
 }
 
 if(msg.checkAddrPattern("/muse/elements/gamma_relative")){
   for(int ch = 0; ch < N_CHANNELS; ch++){
     data[2] = msg.get(ch).floatValue();
     //data[2] = (data[2] - (MAX_MICROVOLTS / 2)) / (MAX_MICROVOLTS / 2); // -1.0 1.0
     buffer[2][ch][pointer] = data[2];
   }
   pointer = (pointer + 1) % BUFFER_SIZE;
 }
}
