import ddf.minim.*;

int x, y, time;
int counterI, counterJ;
int tailCounter;
int[][] tailPosition;
PVector pointLocation;
int score;
boolean paused;
boolean gameOver;
Minim minim;
AudioPlayer gameOverSound, coinSound;


byte direction;
  
void setup(){
   size(840, 600);
   x = width/2;
   y = height/2;
   direction = 3;
   time = millis();
   tailPosition  = new int[100][2];
   
   tailPosition[0][0] = x - 30;
   tailPosition[0][1] = y;
   tailPosition[1][0] = x - 60;
   tailPosition[1][1] = y;
   tailPosition[2][0] = x - 90;
   tailPosition[2][1] = y;
   tailPosition[3][0] = x - 120;
   tailPosition[3][1] = y;
   
   pointLocation = new PVector(random(x), random(y));
   score = 0;
   tailCounter = 6;
   paused = false;
   gameOver = false;
   
   minim = new Minim(this);
   gameOverSound = minim.loadFile("game_over.wav");
   coinSound = minim.loadFile("coin.wav");
 
 
 }
 
 void draw(){
 background(0); 
 
 pushStyle();
 textSize(32);
 fill(0, 255, 0);
 text("SCORE: " + score,width-200, 40);
 popStyle();
 
 
 if(dist(float(x), float(y), float(tailPosition[0][0]), float(tailPosition[0][1])) > 0){
 
   for(int i = tailCounter-1; i>0; i--){
     tailPosition[i][0] = tailPosition[i-1][0];
     tailPosition[i][1] = tailPosition[i-1][1];
   }
   tailPosition[0][0] = x;
   tailPosition[0][1] = y;
 }
 for(int i = 0; i<tailCounter; i++){
   int currentX = tailPosition[i][0];
   int currentY = tailPosition[i][1];
   pushStyle();
   fill(0, 0, 255);
   rect(currentX, currentY, 25, 25);
   popStyle();
   if(tailPosition[0][0] == tailPosition[i+1][0]  && tailPosition[0][1] == tailPosition[i+1][1]){
     gameOver();
   }
 }
 
 checkCollision();
 pushStyle();
 fill(0, 255, 0);
 ellipse(pointLocation.x, pointLocation.y, 25, 25);
 popStyle();
 
 pushStyle();
 fill(255, 0, 0);
 ellipse(pointLocation.x, pointLocation.y, 5, 5);
 popStyle();
 

 
 textSize(15);
 text("X: " + x + "\nY: " + y, 10, 20);
 velocity(direction);

 
 }
 
void velocity(byte direct){
 
 
 
 if(millis() >= time + 120){
   switch(direct){
     case 1: 
       x -= 30;
       break;
     case 3:
       x += 30;
       break;
     case 2:
       y -= 30;
       break;
     case 4:
       y += 30;
       break;
 }
 
 
 time = millis();
 if(x <0 || x > width - 30 || y < 0 || y > height - 30){
     gameOver();
 }
 }
} 
 
 
void keyPressed(){
 
 if(Character.toLowerCase(key) == 'a' && direction != 3){
   direction = 1; // left
 }else if(Character.toLowerCase(key) == 'd' && direction != 1){
   direction = 3; // right
 }else if(Character.toLowerCase(key) == 'w' && direction != 4){
   direction = 2; // up
 }else if(Character.toLowerCase(key) == 's' && direction != 2){
   direction = 4; // down
 }else if(Character.toLowerCase(key) == 'p' && paused == false){
   noLoop();
   paused = true;
   textSize(50);
   text("PAUSED", width/2 - 100, height/2 - 20);
 }else if(Character.toLowerCase(key) == 'p' && paused == true){
   loop();
   paused = false;
 }
 else if(Character.toLowerCase(key) == 'r' && gameOver == true){
   setup();
   loop();
 }
}
 
void checkCollision(){
  if(dist(pointLocation.x, pointLocation.y, (float) tailPosition[0][0]+12, (float) tailPosition[0][1]+12) <= 25.0){
    coinSound.rewind();
    coinSound.play();
    pointLocation.x = random(width);
    pointLocation.y = random(height);
    ++score;
    ++tailCounter;
    
  }
}

void gameOver(){
     gameOverSound.rewind();
     gameOverSound.play();
     pushStyle();
     textSize(50);
     fill(255, 0, 0); 
     text("GAME OVER", width/2 - 150, height/2 - 10);
     popStyle();
     
     pushStyle();
     textSize(25);
     text("Press \"R\" to restart", width/2 - 125, height-100);
     popStyle();
     
     gameOver = true;
     
     noLoop();  
}