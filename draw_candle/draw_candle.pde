ArrayList<fire_ball> fires;
int i = 0;


void setup(){
  size(1000,600);
  smooth();
  
  fires = new ArrayList<fire_ball>();
  for ( int i = 0; i < 300; ++i ) {
    fires.add( new fire_ball() );
  }
}


void draw(){
  background(0,0,0);
  frameRate(60);
  float evalue = random(20);
  i = (i+1) % 300;
  for(int j = 0; j < i ; j ++){ 
    fires.get(i).run();
  }

}
    


class fire_ball {
  float size;
  color col;
  PVector pos;

  fire_ball() {
    size = random(20,30);
    col = color(255, 100, 0); //todo:random
    pos = new PVector( 500 + random(20), 300);
  }

  void run() {
    update();
    display();
  }

  void update() {
    float temp;

    temp = pos.x + random(-0.5, 0.5);
    if ( 400 < temp && temp < 600) {
      pos.x = temp;
    }
    temp = pos.y - random(1);
    if (temp > 0 ) {
    pos.y = temp;
    }
    
    temp = size - random(0.2);
    if (temp > 0 ) {
    size = temp;
    }
  }

  void display() {
    fill(col);
    noStroke();
    ellipse( pos.x, pos.y, size, size);
  }
}
    
