import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;
import oscP5.*;
import netP5.*;



Minim minim;
AudioPlayer song;

//画像の読み込み
PImage zazen_img;
PImage katsu_img;
PImage bouzu_img;
PImage trans_katsu_img;
PImage candle_image;
PFont f;


//文字・背景の調整
float centerX = 300;
float centerY = 200;
float widthRec = 300;
float heightRec = 50;
float black = 0;
float white = 255;

//火の生成に必要な関数
int i = 0;
float time = 0;
float sint = 0;
ArrayList<fire_ball> fires;


//画面遷移に必要な関数
int state;    // 現在の状態 (0=火の画面fire, 1=喝miss, 2=クリアend)
long t_start; // 現在の状態になった時刻[ミリ秒]
float t;      // 現在の状態になってからの経過時間[秒]
int katsu_display_time = 0;
long katsu_start;
int clear = 0;
float clear_time = pow(10,50);

//脳波の読み込みに必要な関数
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

float evalue = 0;
float beta_ave = 0;
float gamma_ave = 0;




void setup(){
  size(1000, 600);
  frameRate(60);
  smooth();
  textSize(32);
  textAlign(CENTER);
  fill(255);
  f = createFont("HiraMinPro-W3",16,true); //画面・背景・フレームレート・フォントの調整
  
  state = 4;
  t_start = millis();
  
 
  zazen_img = loadImage("zazen.png");
  katsu_img = loadImage("喝.png");
  trans_katsu_img = loadImage("transparent_katsu.png");
  bouzu_img = loadImage("bouzu.png");  //画像の読み込み
  candle_image = loadImage("candle.jpg");
  
  
  minim = new Minim( this );
  song = minim.loadFile("katu.mp3"); //音の読み込み
  
  fires = new ArrayList<fire_ball>();
  for ( int i = 0; i < 5000; ++i ) {
    fires.add( new fire_ball() ); //火の設定
  }
}


void draw(){
  
  t = (millis() - t_start) / 1000.0; // 画面遷移に使用する経過時間を更新
  time = (time+random(1))%320;//火の生成に使うtime
  background(BG_COLOR);
  frameRate(60);
  
  
  

  int nextState= 2;
  if(state == 0){ nextState = fire(); }
  else if(state == 1){ nextState = end(); }
  else if(state == 2){ nextState = title();}
  else if(state == 3){ nextState = countdown();}
  
  if(state != nextState){ t_start = millis(); }// 状態が遷移するので、現在の状態になった時刻を更新する
  state = nextState;
}

int fire(){
  
    //脳波の読み込み、evalueを生成。
  beta_ave = (sum(value[0][0])+sum(value[0][1])+sum(value[0][2])+sum(value[0][3]))/(4*60); 
  gamma_ave = (sum(value[1][0])+sum(value[1][1])+sum(value[1][2])+sum(value[1][3]))/(4*60);
  // β波とγ波の2秒間の値の平均
  evalue = 400*(beta_ave+1.2*gamma_ave);
  
  image(candle_image, 400, 250, 200, 300);
  fill(255,255,255);
  text("evalue:"+ nf(evalue,1,3),350,60);
  
  blendMode(ADD);//光を加算合成に
  if(i < 5000){
    i = i+1;
  }
  for(int j = 0; j < i ; j += 2){ 
    fires.get(j).run();
    fires.get(j+1).run();
  }
  
  //喝
  if(evalue > 3 && t > 10 && (millis()-katsu_start)/1000 > 10){
  song.rewind();
  song.play();
  katsu_display_time = 90;
  katsu_start = millis();
  }
  
  if(katsu_display_time > 0){
  image(trans_katsu_img,200,200);
  katsu_display_time -= 1;
  }
  
  if(evalue < 1 && clear == 0){
    clear_time = millis();
    clear = 1;
  }
  
  if(evalue > 1){
    clear = 0;
  }
  
  if(evalue < 1 && clear == 1 && (millis()-clear_time)/1000 > 5){
    clear = 0;
    return 1; // endの画面へ
  }
  return 0;
}



int end(){
  drawText("お疲れさまでした",60,width/2,height/2,255,255);
      if(mousePressed == true){
       return 2;
  }
  return 1;
}


//todo:脳波を4ch全てから受け取ってることを確認
int title(){
  image(bouzu_img,0,0);
  drawRect(centerX,centerY,widthRec,heightRec,white,0,white);
  drawText("押したら始まります",30,centerX,centerY,255,255);
  if (mouseX > centerX-widthRec/2 && mouseX < centerX+widthRec/2 && mouseY > centerY-heightRec/2 && mouseY < centerY+heightRec/2) {
       //overBox = true;
    drawRect(centerX,centerY,widthRec,heightRec,white,177,white);
    drawText("押したら始まります",30,centerX,centerY,0,255);
    if(mouseX > centerX-widthRec/2 && mouseX < centerX+widthRec/2 && mouseY > centerY-heightRec/2 && mouseY < centerY+heightRec/2 && mousePressed == true){
       return 3;
       }
  }
  return 2;
  }
  
  
int countdown(){
  if(t < 1){
       drawText("3",60,width/2,height/2,255,255);
       return 3;
     }else if(t < 2){
       drawText("2",60,width/2,height/2,255,255);
       return 3;
     }else if(t < 3){
       drawText("1",60,width/2,height/2,255,255);
       return 3;
   }else if(t < 4){
       drawText("開始!",60,width/2,height/2,255,255);
       katsu_start = millis();
       return 3;
     }
     return 0;

}



void drawRect(float centerX,float centerY,float widthRec,float heightRec,float colour, float transparency, float lineColour) {
 rectMode(CENTER);
 stroke(lineColour);
 fill(colour,transparency);
 rect(centerX,centerY,widthRec,heightRec);
 }
// draw text
void drawText(String message,float fontSize,float centerX,float centerY,float colour, float transparency){
 textFont(f,fontSize);                  // STEP 3 Specify font to be used
 fill(colour,transparency);             // STEP 4 Specify font color
 textAlign(CENTER,CENTER);
 text(message,centerX,centerY);         // STEP 5 Display Text(text,centerX,centerY)
}

  

void stop()
{
  song.close();
  minim.stop();
  super.stop();
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
      
      if(evalue < 1.8){
        new_update0();
      }
      else if(evalue > 2.5){
        new_update2();
      }
      else{
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
