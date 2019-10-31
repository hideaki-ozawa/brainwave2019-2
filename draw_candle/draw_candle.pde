ArrayList<fire_ball> fires;
PImage candle_image;
int i = 0;
int evalue = 0;
float t = 0;
float sint = 0;



void setup(){
  size(1000,600);
  smooth();
  
  candle_image = loadImage("candle.jpg");
  

  //fire_ballのインスタンス生成
  fires = new ArrayList<fire_ball>();
  for ( int i = 0; i < 5000; ++i ) {
    fires.add( new fire_ball() );
  }
}


void draw(){
  background(0,0,0);
  frameRate(60);
  t = (t+random(1))%320;
  
  textSize(24);
  text(str(evalue),20,20);
  text(str(t),20,50);
  text(str(sint),20,80);
  
//グリッドの描画
  int gridSize = 100;

  for (int x = gridSize; x <= width - gridSize; x += gridSize) {
    for (int y = gridSize; y <= height - gridSize; y += gridSize) {
      noStroke();
      fill(255);
      ellipse(x, y, 3, 3);
      stroke(255, 50);
      line(x, y, width/2, height/2);
    }
  }
  
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
    
    pos.x += sin(PI*t/160)*(250-pos.y)/100;
    
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
    
    pos.x += sin(PI*t/80)*(250-pos.y)/100;
    
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
    
    
void mousePressed() {
  if(evalue < 7){
    evalue += 1;
  }
}
