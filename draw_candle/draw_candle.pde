ArrayList<fire_ball> fires;
int i = 0;


void setup(){
  size(1000,600);
  smooth();
  
  fires = new ArrayList<fire_ball>();
  for ( int i = 0; i < 1000; ++i ) {
    fires.add( new fire_ball() );
  }
}


void draw(){
  background(0,0,0);
  frameRate(60);
  float evalue = random(20);
  if(i < 1000){
    i = i+1;
  }
  for(int j = 0; j < i ; j ++){ 
    fires.get(j).run();
  }

}
    


class fire_ball {
  float size;
  color col;
  PVector pos;

  fire_ball() {
    size = random(5,10);
    col = color(255, 120 + random(-20,20), 50); 
    pos = new PVector( 500 + random(-10,10), 250);
    //todo: 速度によって火の玉を制御する
  }

  void run() {
    if(size > 0.001){
      update();
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
    
    temp = size - random(0.07);
    if (temp > 0 ) {
    size = temp;
    }
  }
  
  void initialized(){
    size = random(5,10);
    col = color(255, 120 + random(-20,20), 50);
    pos = new PVector( 500 + random(-10,10), 250);
  }

  void display() {
    fill(col);
    noStroke();
    ellipse( pos.x, pos.y, size, size + random(5));
  }
}
    
