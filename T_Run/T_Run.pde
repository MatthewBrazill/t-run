//-- Imports ----------------------------------------------------------------------------------------------------------------------------------------------------------
import processing.sound.*; // sound functions are neded to play the death sond and the ambient music

//-- here are the Variables -------------------------------------------------------------------------------------------------------------------------------------------

float rexyXMovement = 0;
float objectXMovement = 0;
float speed = 0;
float jumpHeight = 0;
float sinusCounter = 0;
float platformHeight = 0;
PImage bg;
SoundFile death;
SoundFile ambient;
SoundFile finish;
int fastEnough = 0;
int killFall = 0;
int victoryRun = 0;
int allocationHelp = 0;
boolean jumpCompleat = false;
boolean jumpOngoing = false;
boolean hit = false;
boolean deathStart = true;
boolean endStart = true;
boolean debugg = false;
boolean[] keys = new boolean[6];
      /* 
         0 => UP
         1 => LEFT
         2 => DOWN
         3 => RIGHT
         4 => SHIFT
         5 => ALT
      */
int[] flyingObjects = new int[150];
int[] floorObjects = new int[150];


//-- The Setup ---------------------------------------------------------------------------------------------------------------------------------------------------------

void setup() {
  frameRate(60);
  rexyXMovement = 0;
  objectXMovement = 0;
  hit = false;
  debugg = false;
  deathStart = true;
  killFall = 0;
  size(1600, 800);
  bg = loadImage("images/background.png");
  background(bg);
  objectCreation();
  for (int i = 0; i <= 4; i++) {
    keys[i] = false;
  }
  death = new SoundFile(this, "music/death.wav");
  ambient = new SoundFile(this, "music/ambient.wav");
  finish = new SoundFile(this, "music/finish.wav");
  ambient.loop();
}


//-- This method alows Rexy to move to the left. 'speed' is the variable that is given in to this function and dacided by the speed() function -------------------------

public void goLeft(float speed) {
  if (keys[1] == true && objectXMovement <= 500) {
    if (rexyXMovement >= -40) {
      rexyXMovement = rexyXMovement - speed;
    }
    else {
      objectXMovement = objectXMovement + speed;
    }
  }
}


//-- This method alows Rexy to move to the right. 'speed' is the variable that is given in to this function and dacided by the speed() function ------------------------

public void goRight(float speed) {
  if (keys[3] == true) {
    if (rexyXMovement <= 40) {
      rexyXMovement = rexyXMovement + speed;
    }
    else {
      objectXMovement = objectXMovement - speed;
    }
  }
}


//-- This method regulates Roxys speed, and decides weather Roxy is sprinting. -----------------------------------------------------------------------------------------

public float speed() {
  if (debugg == true) {
    speed = 18;
  }
  else {
    if (keys[4] == true) {
      speed = 6;
    }
    else {
      speed = 3;
    }
  }
  return speed;
}


//-- This method alows Rexy to jump. -----------------------------------------------------------------------------------------------------------------------------------

public void jump() {
  if (keys[0] == true || jumpOngoing == true) {
    if (jumpCompleat == true) {
      jumpCompleat = false;
      jumpOngoing = false;
    }
    else if ((jumpCompleat == false) && (sinusCounter <= 3.141)) {
      jumpHeight = 150 * sin(sinusCounter);
      sinusCounter = sinusCounter + 0.1;
      jumpOngoing = true;
    }
    else {
      sinusCounter = 0;
      jumpHeight = 0;
      jumpCompleat = true;
    }
  }
  goLeft(speed());
  goRight(speed());
}


//-- This method alows Rexy to duck and draws him. ---------------------------------------------------------------------------------------------------------------------

public void duck() {
  if (keys[2] == true) {
    rexyDucked(760 + rexyXMovement, 570 - jumpHeight - platformHeight);
  }
  else {
    rexy(760 + rexyXMovement, 490 - jumpHeight - platformHeight);
  }
}


//--These methods create the objects that Rexy has to avoid. Hit detection is in the method hitDetection().-------------------------------------------------------------

public void objectCreation() {
  int rnFloor = 0;
  for (int i = 0; i < 150; i++) {
    rnFloor = int(random(20, 500));
    if (rnFloor % 2 == 0) {
      floorObjects[i] = rnFloor;
    }
    else {
      floorObjects[i] = 15;
    }
  }
}


//-- This is for the displaying of the objects. ------------------------------------------------------------------------------------------------------------------------

public void objectDisplay() {
  //floor objects
  for (int i = 0; i <= 149; i++) {
    fill(180); //medium gray
    rect(100*floorObjects[i]+objectXMovement, 615, 80, 35);
    fill(255); //white
  }
}


//-- This method us udes to tell weather Rexy hit anything. if he does it returns the boolean --------------------------------------------------------------------------
//-- 'hit' whitch the endGame() function uses to determin when to end the game.               --------------------------------------------------------------------------

public void hitDetection() {
  if (keys[2] == false) {
    for (int i = 0; i <= 149; i++) {
      if ((760+rexyXMovement+30 >= 100*floorObjects[i]+objectXMovement) && (760+rexyXMovement <= 100*floorObjects[i]+objectXMovement+80) && (490-jumpHeight - platformHeight+160 >= 615)) {
        hit = true;
      }
    }
    for (int i = 0; i <= 149; i++) {
      if ((760+rexyXMovement+60 >= 100*flyingObjects[i]+objectXMovement) && (760+rexyXMovement <= 100*flyingObjects[i]+objectXMovement+100) && (490-jumpHeight - platformHeight <= 560) && (490-jumpHeight - platformHeight+160 >= 540)) {
        hit = true;
      }
    }
  }
  else if (keys[2] == true) {
    for (int i = 0; i <= 149; i++) {
      if ((760+rexyXMovement+90 >= 100*floorObjects[i]+objectXMovement) && (760+rexyXMovement <= 100*floorObjects[i]+objectXMovement+80) && (570-jumpHeight - platformHeight+80 >= 615)) {
        hit = true;
      }
    }
    for (int i = 0; i <= 149; i++) {
      if ((760+rexyXMovement+90 >= 100*flyingObjects[i]+objectXMovement) && (760+rexyXMovement <= 100*flyingObjects[i]+objectXMovement+100) && (570-jumpHeight - platformHeight <= 560) && (570-jumpHeight - platformHeight+80 >= 540)) {
        hit = true;
      }
    }
  }
}


//-- This function goes thrue the process of ending the game. Weather or not Rexy made it hoe and playing the apropreate end sceen. ------------------------------------

public void endGame() {
  if (hit == true) {
    textSize(50);
    ambient.stop();
    if (deathStart == true) {
      death.play();
      delay(1000);
      deathStart = false;
      death.stop();
    }
    background(bg);
    objectDisplay();
    killFall += 2;
    rexy(760 + rexyXMovement, 490 + killFall);
    text("Game Over: Rexy didn't make it home :(", 380, 300);
    if (killFall >= 350) {
      text("Play Again? Y/N", 580, 400);
      if (keyPressed == true && (key == 'Y' || key == 'y')) {
        setup();
      }
      else if (keyPressed == true && (key == 'N' || key == 'n')) {
        exit();
      }
    }
  }
  else {
    background(bg);
    goalTexture();
    objectDisplay();
    if (objectXMovement <= -50080) {
      textSize(50);
      ambient.stop();
      if (endStart == true) {
        finish.play();
        delay(3000);
        endStart = false;
        finish.stop();
      }
      victoryRun += 2;
      rexy(760 + rexyXMovement + victoryRun, 490);
      text("Congratulations, Rexy made it home! :)", 380, 300);
      if (victoryRun >= 400) {
        text("Play Again? Y/N", 580, 400);
        if (keyPressed == true && (key == 'Y' || key == 'y')) {
          setup();
        }
        else if (keyPressed == true && (key == 'N' || key == 'n')) {
          exit();
        }
      }
    }
    else {
      goLeft(speed());
      goRight(speed());
      jump();
      duck();
    }
  }
}


//-- the keyPressed() and keyReleased() functions are built in. the activate when a key is pressed  --------------------------------------------------------------------
//-- or released respectivly. This way allows me to reliably use multible keys at the same time and --------------------------------------------------------------------
//-- not be limited to a single key being pressed at a time etc.                                    --------------------------------------------------------------------

void keyPressed() {
  if (key == 'W' || key == 'w' || keyCode == UP) {
    keys[0] = true;
  }
  if (key == 'A' || key == 'a' || keyCode == LEFT) {
    keys[1] = true;
  }
  if (key == 'S' || key == 's' || keyCode == DOWN) {
    keys[2] = true;
  }
  if (key == 'D' || key == 'd' || keyCode == RIGHT) {
    keys[3] = true;
  }
  if (keyCode == SHIFT) {
    keys[4] = true;
  }
  if (keyCode == ALT) {
    keys[5] = true;
  }
}
void keyReleased() {
  if (key == 'W' || key == 'w' || keyCode == UP) {
    keys[0] = false;
  }
  if (key == 'A' || key == 'a' || keyCode == LEFT) {
    keys[1] = false;
  }
  if (key == 'S' || key == 's' || keyCode == DOWN) {
    keys[2] = false;
  }
  if (key == 'D' || key == 'd' || keyCode == RIGHT) {
    keys[3] = false;
  }
  if (keyCode == SHIFT) {
    keys[4] = false;
  }
  if (keyCode == ALT) {
    keys[5] = false;
  }
}


//-- this function creates Rexy. it uses a combination of all the different drawing things we learned at the beginning. ------------------------------------------------

public void rexy(float rexyX, float rexyY) {
  fill(107, 80, 36);
  rect(rexyX, rexyY, 40, 30); //head
  rect(rexyX, rexyY+30, 30, 30); //neck
  rect(rexyX+30, rexyY+30, 30, 15); //mouth
  triangle(rexyX+40, rexyY+45, rexyX+60, rexyY+45, rexyX+50, rexyY+55); //tooth
  rect(rexyX, rexyY+60, 30, 60); //body
  triangle(rexyX+15, rexyY+120, rexyX+30, rexyY+120, rexyX+22.5, rexyY+160); //right leg
  triangle(rexyX, rexyY+120, rexyX+15, rexyY+120, rexyX+7.5, rexyY+160); //left leg
  rect(rexyX+30, rexyY+70, 30, 5); // arm
  triangle(rexyX+50, rexyY+75, rexyX+60, rexyY+75, rexyX+60, rexyY+85); //hand
  fill(255);
  ellipse(rexyX+30, rexyY+10, 10, 10); //eye
}

public void rexyDucked(float rexyX, float rexyY) {
  fill(107, 80, 36);
  rect(rexyX+60, rexyY, 30, 40); //head
  rect(rexyX+30, rexyY, 30, 30); //neck
  rect(rexyX+45, rexyY+30, 15, 30); //mouth
  triangle(rexyX+45, rexyY+40, rexyX+45, rexyY+60, rexyX+35, rexyY+50); //tooth
  rect(rexyX, rexyY, 30, 40); //body
  triangle(rexyX+15, rexyY+40, rexyX+30, rexyY+40, rexyX+22.5, rexyY+80); //right leg
  triangle(rexyX, rexyY+40, rexyX+15, rexyY+40, rexyX+7.5, rexyY+80); //left leg
  rect(rexyX+32, rexyY+30, 5, 30); // arm
  triangle(rexyX+22, rexyY+60, rexyX+32, rexyY+60, rexyX+32, rexyY+50); //hand
  fill(255);
  ellipse(rexyX+80, rexyY+30, 10, 10); //eye
}


//-- The progress bar is there to give the player a sense of how far from the 

public void progressBar(float progress) {
  rect(100, 75, 1400, 10);
  ellipse(100, 80, 60, 60);
  ellipse(1500, 80, 60, 60);
  fill(107, 80, 36);
  rect(-progress/39.37+135, 50, 40, 30); //head
  rect(-progress/39.37+135, 80, 30, 30); //neck
  rect(-progress/39.37+165, 80, 30, 15); //mouth
  triangle(-progress/39.37+175, 95, -progress/39.37+135+60, 95, -progress/39.37+135+50, 105); //tooth
  fill(0);
  textSize(18);
  text("Start", 80, 85);
  text("Finish", 1475, 85);
  fill(255);
  ellipse(-progress/39.37+165, 60, 10, 10); //eye
}


//--

public void goalTexture() {
  fill(255);
  rect(760+50100+objectXMovement, 650, 30, 30);
  fill(0);
  rect(760+50100+objectXMovement+30, 650, 30, 30);
  rect(760+50100+objectXMovement, 680, 30, 30);
  fill(255);
  rect(760+50100+objectXMovement+30, 680, 30, 30);
  rect(760+50100+objectXMovement, 710, 30, 30);
  fill(0);
  rect(760+50100+objectXMovement+30, 710, 30, 30);
  fill(255);
}


public void debuggMode() {
  if (keys[1] && keys[4] && keys[5]){
    debugg = true;
  }
}

////////////////////////////////////////////////////////////

void draw() {
  debuggMode();
  if (debugg == false){
    hitDetection();
  }
  endGame();
  progressBar(objectXMovement);
}
