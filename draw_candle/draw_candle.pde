ArrayList<fire_ball> fires;
PImage candle_image;
int i = 0;
int evalue = 0;

void setup(){
  size(1000,600);
  smooth();
  
  candle_image = loadImage("candle.jpg");
  
  fires = new ArrayList<fire_ball>();
  for ( int i = 0; i < 5000; ++i ) {
    fires.add( new fire_ball() );
  }
}


void draw(){
  background(0,0,0);
  frameRate(60);
  
  textSize(24);
  text(str(evalue),20,20);
  
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
  color fire_color = color(255,100 +random(10), 50 +random(10));
  PVector pos;
  PVector v;
  float T;

  fire_ball() {
    size = random(6,10); 
    pos = new PVector( 500 + random(-10,10), 250);
    v = new PVector(random(-0.6,0.6),random(-1,-0.2));
    //todo: vを周期Tで変化させる
  }

  void run() {
    if(size > 0.0001){
      new_update();
      display();
    }
    else{
      initialized();
    }
  }

  void update() {
    float temp;

    temp = pos.x + random(-1, 1);
    if ( 400 < temp && temp < 600) {
      pos.x = temp;
    }
    temp = pos.y - random(1);
    if (temp > 0 ) {
    pos.y = temp;
    }
    
    temp = size - random(0.02*abs(pos.x - 500)+0.03);
    if (temp > 0 ) {
    size = temp;
    }
  }
  
  void new_update(){
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
