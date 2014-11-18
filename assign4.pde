Ship ship;
PowerUp ruby;
Bullet[] bList;
Laser[] lList;
Alien[] aList;

//Game Status
final int GAME_START   = 0;
final int GAME_PLAYING = 1;
final int GAME_PAUSE   = 2;
final int GAME_WIN     = 3;
final int GAME_LOSE    = 4;
int status;              //Game Status
int point;               //Game Score
int expoInit;            //Explode Init Size
int countBulletFrame;    //Bullet Time Counter
int bulletNum;           //Bullet Order Number

/*--------Put Variables Here---------*/
int laserNum;
int aCount = 53;                  //total alien
int [] aPosX = new int[aCount];   // alien.x
int [] aPosY = new int[aCount];   // alien.y
int countLaserFrame;
int laserCount;
int lifeCount = 3;
int shotFrame = 50;               // when to shot

void setup() {

  status = GAME_START;

  bList = new Bullet[30];
  lList = new Laser[30];
  aList = new Alien[100];


  size(640, 480);
  background(0, 0, 0);
  rectMode(CENTER);

  ship = new Ship(width/2, 460, 3);
  ruby = new PowerUp(int(random(width)), -10);

  reset();
}

void draw() {
  background(50, 50, 50);
  noStroke();
  

  
  switch(status) {

  case GAME_START:
    /*---------Print Text-------------*/
    //text("press enter", 320, 240); 
    printText(GAME_START);
    // replace this with printText
    /*--------------------------------*/
    break;

  case GAME_PLAYING:
    background(50, 50, 50);
    
    drawHorizon();
    drawScore();
    drawLife();
    ship.display(); //Draw Ship on the Screen
    drawAlien();
    drawBullet();
    drawLaser();
    
    /*---------Call functions---------------*/
    countLaserFrame += 1;
    alienShoot(countLaserFrame);
    
    
    
    checkAlienDead();/*finish this function*/
    checkShipHit();  /*finish this function*/

    countBulletFrame+=1;
    break;

  case GAME_PAUSE:
    /*---------Print Text-------------*/
    printText(GAME_PAUSE);
    /*--------------------------------*/
    break;

  case GAME_WIN:
    /*---------Print Text-------------*/
    printText(GAME_WIN);
    /*--------------------------------*/
    winAnimate();
    break;

  case GAME_LOSE:
    loseAnimate();
    /*---------Print Text-------------*/
      printText(GAME_LOSE);
    /*--------------------------------*/
    break;
  }
}

void drawHorizon() {
  stroke(153);
  line(0, 420, width, 420);
}

void drawScore() {
  noStroke();
  fill(95, 194, 226);
  textAlign(CENTER, CENTER);
  textSize(23);
  text("SCORE:"+point, width/2, 16);
}

void keyPressed() {
  if (status == GAME_PLAYING) {
    ship.keyTyped();
    cheatKeys();
    shootBullet(30);
  }
  statusCtrl();
}

/*---------Make Alien Function-------------*/
void alienMaker( int aCount) {
  //aList[0]= new Alien(50, 50);
  int defualtP = 50;
  for(int i=0; i<aCount; i++){
    int x = defualtP+40*(i%12);
    int y = defualtP+50*(i/12);
    aList[i] = new Alien(x, y );
    
    aPosX[i] = x;
    aPosY[i] = y;
    //println("aList["+i+"] =" + aPosX[i] + ","+aPosY[i]);
  }
 
  
}
void alienShoot(int frame) {
  
  int ra = int(random(53));

  for(int i = 0 ; i<lList.length-1; i++){
    Alien alien = aList[ra];
    
    if(frame % shotFrame == 0 && alien!=null && !alien.die ){
      
     
      /*if(laserNum < lList.length-1){
        laserNum++;
        //lList[laserNum]= new Laser(aList[ra].aX, aList[ra].aY);  
        lList[3]=new Laser(aList[3].aX,aList[3].aY);
        println("laserNum = "+laserNum);
      }else{
        laserNum = 0;       
      }*/
    }
  }
  
}

void drawLife() {
  fill(230, 74, 96);
  text("LIFE:", 36, 455);
  /*---------Draw Ship Life---------*/
  
  int lifeWH = 15;
  int liftSpace = 25;
  for(int i=0; i<lifeCount; i++){
    ellipse(78+i*liftSpace,459,lifeWH,lifeWH );
  }
}

void drawBullet() {
  for (int i=0; i<bList.length-1; i++) {
    Bullet bullet = bList[i];
    if (bullet!=null && !bullet.gone) { // Check Array isn't empty and bullet still exist
      bullet.move();     //Move Bullet
      bullet.display();  //Draw Bullet on the Screen
      if (bullet.bY<0 || bullet.bX>width || bullet.bX<0) {
        removeBullet(bullet); //Remove Bullet from the Screen
      }
    }
  }
}

void drawLaser() {
  for (int i=0; i<lList.length-1; i++) { 
    Laser laser = lList[i];
    if (laser!=null && !laser.gone) { // Check Array isn't empty and Laser still exist
      laser.move();      //Move Laser
      laser.display();   //Draw Laser
      if (laser.lY>480) {
        removeLaser(laser); //Remove Laser from the Screen
      }
    }
  }
}

void drawAlien() {
  for (int i=0; i<aList.length-1; i++) {
    Alien alien = aList[i];
    if (alien!=null && !alien.die) { // Check Array isn't empty and alien still exist
      alien.move();    //Move Alien
      alien.display(); //Draw Alien
      /*---------Call Check Line Hit---------*/

      /*--------------------------------------*/
    }
  }
}

/*--------Check Line Hit---------*/


/*---------Ship Shoot-------------*/
void shootBullet(int frame) {
  if ( key == ' ' && countBulletFrame>frame) {
    if (!ship.upGrade) {
      bList[bulletNum]= new Bullet(ship.posX, ship.posY, -3, 0);
      if (bulletNum<bList.length-2) {
        bulletNum+=1;
      } else {
        bulletNum = 0;
      }
    } 
    /*---------Ship Upgrade Shoot-------------*/
    else {
      bList[bulletNum]= new Bullet(ship.posX, ship.posY, -3, 0); 
      if (bulletNum<bList.length-2) {
        bulletNum+=1;
      } else {
        bulletNum = 0;
      }
    }
    countBulletFrame = 0;
  }
}

/*---------Check Alien Hit-------------*/
void checkAlienDead() {

  for (int i=0; i<bList.length-1; i++) {
    Bullet bullet = bList[i];
    for (int j=0; j<aList.length-1; j++) {
      Alien alien = aList[j];
      
      if (bullet != null && alien != null && !bullet.gone && !alien.die &&
      // Check Array isn't empty and bullet / alien still exist
      
      /*------------Hit detect-------------*/
        bList[i].bX <= aList[j].aX + aList[j].aSize*1.5 && 
        bList[i].bX >= aList[j].aX - aList[j].aSize*1.5 &&
        bList[i].bY <= aList[j].aY + aList[j].aSize*1.5 && 
        bList[i].bY >= aList[j].aY - aList[j].aSize*1.5
     
      ) {
        
        /*-------do something------*/
        removeBullet(bList[i]);
        removeAlien(aList[j]);
        point+=10;
         
      

      }
    }
  }
 
}

/*---------Alien Drop Laser-----------------*/


/*---------Check Laser Hit Ship-------------*/
void checkShipHit() {
 
  for (int i=0; i<lList.length-1; i++) {
    Laser laser = lList[i];
    //prinln("lList[" + i + "]= " + lList[i].lX);
    if (laser!= null && !laser.gone 
    // Check Array isn't empty and laser still exist
    /*------------Hit detect-------------*/ &&
    ship.posX <= lList[i].lX  && 
    ship.posX >= lList[i].lX + 15  && 
    ship.posY > lList[i].lY  
    ) {
      /*-------do something------*/
      lifeCount-=1;
      println("Ship hit!");
    }
  }
}

/*---------Check Win Lose------------------*/


void winAnimate() {
  int x = int(random(128))+70;
  fill(x, x, 256);
  ellipse(width/2, 200, 136, 136);
  fill(50, 50, 50);
  ellipse(width/2, 200, 120, 120);
  fill(x, x, 256);
  ellipse(width/2, 200, 101, 101);
  fill(50, 50, 50);
  ellipse(width/2, 200, 93, 93);
  ship.posX = width/2;
  ship.posY = 200;
  ship.display();
}

void loseAnimate() {
  fill(255, 213, 66);
  ellipse(ship.posX, ship.posY, expoInit+200, expoInit+200);
  fill(240, 124, 21);
  ellipse(ship.posX, ship.posY, expoInit+150, expoInit+150);
  fill(255, 213, 66);
  ellipse(ship.posX, ship.posY, expoInit+100, expoInit+100);
  fill(240, 124, 21);
  ellipse(ship.posX, ship.posY, expoInit+50, expoInit+50);
  fill(50, 50, 50);
  ellipse(ship.posX, ship.posY, expoInit, expoInit);
  expoInit+=5;
}

/*---------Check Ruby Hit Ship-------------*/


/*---------Check Level Up------------------*/


/*---------Print Text Function-------------*/
void printText(int gameState){
  int titleX = width/2;
  int titleY = 240;
  int subTitleY = 240 + 40;
  switch(gameState) {

  case GAME_START:
    
    textAlign(CENTER);
    fill(95, 194, 226);
    textSize(60); 
    text("GALIXIAN", titleX, titleY);
    
    textAlign(CENTER);
    fill(95, 194, 226);
    textSize(20); 
    text("Press ENTER to Start", titleX , subTitleY); 
    
    break;
    
  case GAME_PAUSE:
    background(50, 50, 50);
    textAlign(CENTER);
    fill(95, 194, 226);
    textSize(60); 
    text("PUASE", titleX, titleY);
    
    textAlign(CENTER);
    fill(95, 194, 226);
    textSize(20); 
    text("Press ENTER to Resume", titleX , subTitleY);        
    break;

  case GAME_WIN:
    //background(50, 50, 50);
    textAlign(CENTER);
    fill(95, 194, 226);
    textSize(60); 
    text("WINNER", titleX, 340);
    
    textAlign(CENTER);
    fill(95, 194, 226);
    textSize(20); 
    text("SCORE:" + point , titleX , 340+40);    
    break;

  case GAME_LOSE:
    //background(50, 50, 50);
    textAlign(CENTER);
    fill(95, 194, 226);
    textSize(60); 
    text("BOOOM", titleX, titleY);
    
    textAlign(CENTER);
    fill(95, 194, 226);
    textSize(20); 
    text("You are dead!!!" , titleX , subTitleY); 
    
    break;    

  }
}



void removeBullet(Bullet obj) {
  obj.gone = true;
  obj.bX = 2000;
  obj.bY = 2000;
}

void removeLaser(Laser obj) {
  obj.gone = true;
  obj.lX = 2000;
  obj.lY = 2000;
}

void removeAlien(Alien obj) {
  obj.die = true;
  obj.aX = 1000;
  obj.aY = 1000;
}

/*---------Reset Game-------------*/
void reset() {
  for (int i=0; i<bList.length-1; i++) {
    bList[i] = null;
    lList[i] = null;
  }

  for (int i=0; i<aList.length-1; i++) {
    aList[i] = null;
  }

  point = 0;
  expoInit = 0;
  countBulletFrame = 30;
  bulletNum = 0;

  /*--------Init Variable Here---------*/
  

  /*-----------Call Make Alien Function--------*/
  alienMaker(aCount);

  ship.posX = width/2;
  ship.posY = 460;
  ship.upGrade = false;
  ruby.show = false;
  ruby.pX = int(random(width));
  ruby.pY = -10;
}

/*-----------finish statusCtrl--------*/
void statusCtrl() {
  if (key == ENTER) {
    switch(status) {

    case GAME_START:
      status = GAME_PLAYING;
      break;

      /*-----------add things here--------*/

    }
  }
}

void cheatKeys() {

  if (key == 'R'||key == 'r') {
    ruby.show = true;
    ruby.pX = int(random(width));
    ruby.pY = -10;
  }
  if (key == 'Q'||key == 'q') {
    ship.upGrade = true;
  }
  if (key == 'W'||key == 'w') {
    ship.upGrade = false;
  }
  if (key == 'S'||key == 's') {
    for (int i = 0; i<aList.length-1; i++) {
      if (aList[i]!=null) {
        aList[i].aY+=50;
      }
    }
  }
}
