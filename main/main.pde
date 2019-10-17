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
final int wavetype = 2;
final int BUFFER_SIZE = 60;
final float MAX_MICROVOLTS = 1682.815;
final float DISPLAY_SCALE = 200.0;


final color BG_COLOR = color(0, 0, 0);


final int LABEL_SIZE = 21;
final int PORT = 5000;


OscP5 oscP5 = new OscP5(this, PORT);
float[][][] value = new float[wavetype][N_CHANNELS][BUFFER_SIZE];
int pointer = 0;

void setup(){
 size(1000, 600);
 frameRate(30);
 smooth();
 
 textSize(24);
}


void draw(){
 float evalue = 0;
 float beta_ave = 0;
 float gamma_ave = 0;
 
 background(BG_COLOR);
 
 beta_ave = (sum(value[0][0])+sum(value[0][1])+sum(value[0][2])+sum(value[0][3]))/(4*60); 
 gamma_ave = (sum(value[1][0])+sum(value[1][1])+sum(value[1][2])+sum(value[1][3]))/(4*60);
 // β波とγ波の2秒波の値の平均
 evalue = beta_ave + 2.5*gamma_ave;

//これ以下にろうそくのプログラム


}


// museからβ波とγ波のデータをbufferへ
void oscEvent(OscMessage msg){
 float[] data = new float[wavetype];

 if(msg.checkAddrPattern("/muse/elements/beta_relative")){
   for(int ch = 0; ch < N_CHANNELS; ch++){
     data[1] = msg.get(ch).floatValue();
     value[1][ch][pointer] = data[1];
   }
 }
 
 if(msg.checkAddrPattern("/muse/elements/gamma_relative")){
   for(int ch = 0; ch < N_CHANNELS; ch++){
     data[2] = msg.get(ch).floatValue();
     value[2][ch][pointer] = data[2];
   }
   pointer = (pointer + 1) % BUFFER_SIZE;
 }
}
