import oscP5.*;
import netP5.*;


ArrayList<fire_ball> fires;
PImage candle_image;
int i = 0;
float time = 0;
float sint = 0;
float evalue = 0;


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
 frameRate(60);
 smooth();
 
 candle_image = loadImage("candle.jpg");
 
 //fire_ballのインスタンス生成
 fires = new ArrayList<fire_ball>();
  for ( int i = 0; i < 5000; ++i ) {
    fires.add( new fire_ball() );
  }
}


void draw(){
 float beta_ave = 0;
 float gamma_ave = 0;
 
 background(BG_COLOR);
 frameRate(60);
 time = (time+random(1))%320;
 
 beta_ave = (sum(value[0][0])+sum(value[0][1])+sum(value[0][2])+sum(value[0][3]))/(4*60); 
 gamma_ave = (sum(value[1][0])+sum(value[1][1])+sum(value[1][2])+sum(value[1][3]))/(4*60);
 // β波とγ波の2秒波の値の平均
 evalue = beta_ave + 2.5*gamma_ave;

//これ以下にろうそくのプログラム
//evalueが集中力評価に用いる値

//candleの描画
  image(candle_image, 400, 250, 200, 300);
  
  blendMode(ADD);
  if(i < 5000){
    i = i+1;
  }
  for(int j = 0; j < i ; j += 2){ 
    fires.get(j).run();
    fires.get(j+1).run();
  }

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


//火の玉のクラス
class fire_ball {
  float size;
  color fire_color = color(255,100 +random(10), 50 +random(10),128);
  PVector pos;
  PVector v;
  float T;

  fire_ball() {
    size = random(8,12); 
    pos = new PVector( 500 + random(-10,10), 250);
    v = new PVector(random(-0.6,0.6),random(-1,-0.1));
    //todo: vを周期Tで変化させる
  }

  void run() {
    if(size > 0.0001){
      
      if(evalue == 0){
        new_update0();
      }
      else if(evalue == 1){
        new_update1();
      }
      else if(evalue == 2){
        new_update2();
      }
      display();
    }
    
    else{
      initialized();
    }
  }

  //揺れレベル0
  void new_update0(){
    pos.add(v);
    float temp;

    v.x = v.x - random(0.0008*(pos.x-500));
    
    temp = v.y + random(-0.002,0.005);
    if(temp < 250){
      v.y = temp;
    }
    
    temp = size - random(0.08);
    if (temp > 0 ) {
    size = temp;
    }
    
    if(sq(pos.x - 500)/900 + sq(pos.y - 160)/8100 > 1){
      size = 0.00001;
    }
  }
  
  //揺れレベル1
  void new_update1(){
    pos.add(v);
    float temp;

    v.x = v.x - random(0.0008*(pos.x-500));
    
    temp = v.y + random(-0.002,0.005);
    if(temp < 250){
      v.y = temp;
    }
    
    temp = size - random(0.08);
    if (temp > 0 ) {
    size = temp;
    }
    
    pos.x += sin(PI*time/160)*(250-pos.y)/100;
    
    //if(sq(pos.x - 500)/900 + sq(pos.y - 160)/8100 > 1){
      //size = 0.00001;
    //}
  }
  
  
  //揺れレベル2
  void new_update2(){
    pos.add(v);
    float temp;

    v.x = v.x - random(0.0008*(pos.x-500));
    
    temp = v.y + random(-0.002,0.005);
    if(temp < 250){
      v.y = temp;
    }
    
    temp = size - random(0.08);
    if (temp > 0 ) {
    size = temp;
    }
    
    pos.x += sin(PI*time/80)*(250-pos.y)/100;
    
    //if(sq(pos.x - 500)/900 + sq(pos.y - 160)/8100 > 1){
      //size = 0.00001;
    //}
  }
  
  
  
  void initialized(){
    size = random(6,10);
    pos = new PVector( 500 + random(-10,10), 250);
    v = new PVector(random(-0.3,0.3),random(-1,-0.2));
  }

  void display() {
    fill(fire_color);
    noStroke();
    ellipse( pos.x, pos.y, size, size + random(7));
  }
}

//合計を計算する関数
private static float sum(float[] list){
  float ans = 0;
  for(int i = 0; i < list.length ; i++){
    ans += list[i];
  }
  return ans;
}
    
