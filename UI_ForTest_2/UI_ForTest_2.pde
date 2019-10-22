import netP5.*;
import oscP5.*;

OscP5 oscP5;
NetAddress myRemoteLocation;

int questionnum = 0;
int atomnumber = 4;
int starttime, stoptime, resulttime;
int[] elementplayer = {1, 2, 3, 4};
String[] elementname = {"H", "C", "O", "N"};
String[] elementdirection = {"T", "L", "B", "R"};
int[] playbacktime = {1000, 2000, 4000};

Table table;

OscMessage MessageTime;
OscMessage MessagePlayer;
//OscMessage MessageElementName;
//OscMessage MessageElementDirection;

//display-interface

int rectX, rectY, rectSize;
color rectColor, highlightColor, selectedColor, currentColor;
color elementColor, selectedelementColor, currentelementColor;

MyRect[] myrect1, myrect2, myrect3, myrect4;

void setup() {
  size(500, 500);
  frameRate(25);
  background(0);
  oscP5 = new OscP5(this, 4567);
  myRemoteLocation = new NetAddress("127.0.0.1", 7654);

  DrawTable();

  starttime = 0;
  resulttime = 0;

  //set up interface design: colors and fonts
  rectX = width/2;
  rectY = height/2;
  rectSize = 30;

  rectColor = color(0);
  highlightColor = color(51);
  selectedColor = color(255);
  elementColor = color(255);
  selectedelementColor = color(0);

  currentColor = rectColor;
  currentelementColor = elementColor;

  myrect1 = new MyRect[4];
  myrect2 = new MyRect[4];
  myrect3 = new MyRect[4];
  myrect4 = new MyRect[4];

  for (int i = 0; i < 4; i++) {
    int rectx, recty;
    rectx = width/2 +(i-2)*rectSize;
    recty = rectSize;
    myrect1[i] = new MyRect(rectx, recty, rectSize, currentColor, elementname[i], currentelementColor, elementdirection[0]);
  } 

  for (int i = 0; i < 4; i++) {
    int rectx, recty;
    rectx = (i+1)*rectSize;
    recty = height/2 - rectSize;
    myrect2[i] = new MyRect(rectx, recty, rectSize, currentColor, elementname[i], currentelementColor, elementdirection[1]);
  }

  for (int i = 0; i < 4; i++) {
    int rectx, recty;
    rectx = width/2 + (i-2)*rectSize;
    recty = height - 2*rectSize;
    myrect3[i] = new MyRect(rectx, recty, rectSize, currentColor, elementname[i], currentelementColor, elementdirection[2]);
  } 

  for (int i = 0; i < 4; i++) {
    int rectx, recty;
    rectx = width + (i-5)*rectSize;
    recty = height/2 - rectSize;
    myrect4[i] = new MyRect(rectx, recty, rectSize, currentColor, elementname[i], currentelementColor, elementdirection[3]);
  }
}


void draw() {  

  //background(0);

  for (int i = 0; i < 4; i++) {
    myrect1[i].update();
    myrect2[i].update();
    myrect3[i].update();
    myrect4[i].update();
  }
}


void keyPressed() { 
  switch (keyCode) {
  case ENTER:
    questionnum++;
    SendToPD();
    DisplayChoice();
    saveTable(table, "experiment.csv"); 
    break;
  }

  //if (key == CODED){
  //  if(keyCode == ENTER){
  //    SendToPD();
  //    break;
  //  }
  //}
}


void SendToPD() {
  MessageTime = new OscMessage("/duration");
  int ElementTime = playbacktime[questionnum%3];
  MessageTime.add(ElementTime);
  oscP5.send(MessageTime, myRemoteLocation);

  //draw a new row in table for questions
  TableRow newRow = table.addRow();
  newRow.setString("num", "Question " + questionnum);
  newRow.setInt("time", ElementTime);

  for (int i = 0; i <atomnumber; i++) {

    int ElementPlayer = elementplayer[i];
    String ElementName = elementname[(int)random(4)];
    String ElementDirection = elementdirection[i%4];

    MessagePlayer = new OscMessage("/player");
    MessagePlayer.add(ElementPlayer);
    MessagePlayer.add(ElementName);
    MessagePlayer.add(ElementDirection);
    oscP5.send(MessagePlayer, myRemoteLocation);

    println(questionnum + ": " + ElementTime, ElementPlayer, ElementName, ElementDirection);

    //fill four generated results in this row
    //TableQues(questionnum, ElementName, ElementDirection);
    newRow.setString(ElementDirection, ElementName);//ElementDirection, ElementName
    println(newRow.getString(ElementDirection));
  }
}

void DrawTable() { 
  table = new Table();
  table.addColumn("num");

  //draw table: four direction columns
  for (int i = 0; i<elementdirection.length; i++) {
    table.addColumn(elementdirection[i]);
  }

  //add time 
  table.addColumn("time");
  saveTable(table, "experiment.csv");
}


//void DisplayChoice() {
//  background(0); 

//  for (int i = 0; i < elementname.length; i++) {
//    int rectx = rectX + (i-2)*rectSize;
//    int recty = rectY - rectSize;

//    update(mouseX, mouseY, rectx, recty, rectSize);

//    if (rectOver) {
//      //if(mousePressed == true){
//      //currentColor = selectedColor;
//      //currentelementColor = selectedelementColor;
//      //}else {
//      //currentColor = highlightColor;
//      //currentelementColor = elementColor;  
//      //}
//      currentColor = highlightColor;
//      currentelementColor = elementColor;
//    } else {
//      currentColor = rectColor;
//      currentelementColor = elementColor;
//    }
//    myRect.display(rectx, recty, rectSize, currentColor, elementname[i], currentelementColor);
//  }
//}

void DisplayChoice() {
  background(0);

  textSize(15);
  text("Question " + questionnum, 10, 20);

  for (int i = 0; i < 4; i++) {
    myrect1[i].colorChange(rectColor, elementColor);
    myrect1[i].display();

    myrect2[i].colorChange(rectColor, elementColor);
    myrect2[i].display();

    myrect3[i].colorChange(rectColor, elementColor);
    myrect3[i].display();

    myrect4[i].colorChange(rectColor, elementColor);
    myrect4[i].display();
  }

  stoptime = millis();
  resulttime = stoptime - starttime;

  //draw a new row in table for users
  TableRow newRow = table.addRow();
  newRow.setString("num", "Result " + questionnum);
  if (questionnum > 1) {
    TableRow row = table.getRow(questionnum*2-3);
    row.setInt("time", resulttime);
  }
  starttime = millis();
}

void mousePressed() {

  for (int i = 0; i < 4; i++) {
    if ( (!myrect1[i].overRect()) && (!myrect1[i].SelectedCheck()) ) {
      myrect1[i].colorChange(selectedColor, selectedelementColor);
      myrect1[i].elementSelected(1);
      TableRow row = table.getRow(questionnum*2-1);
      row.setString(elementdirection[0], elementname[i]);
    } else {
      myrect1[i].elementSelected(0);
      myrect1[i].colorChange(rectColor, elementColor);
    }
    myrect1[i].display();
  }
  for (int i = 0; i < 4; i++) {
    if ( myrect2[i].overRect() || myrect2[i].SelectedCheck()) {
      myrect2[i].colorChange(selectedColor, selectedelementColor);
      myrect2[i].elementSelected(1);
      TableRow row = table.getRow(questionnum*2-1);
      row.setString(elementdirection[1], elementname[i]);
    } else {
      myrect2[i].elementSelected(0);
      myrect2[i].colorChange(rectColor, elementColor);
    }
    myrect2[i].display();
  }
  for (int i = 0; i < 4; i++) {
    if ( myrect3[i].overRect()) {
      myrect3[i].colorChange(selectedColor, selectedelementColor);
      myrect3[i].elementSelected(1);
      TableRow row = table.getRow(questionnum*2-1);
      row.setString(elementdirection[2], elementname[i]);
    } else {
      myrect3[i].elementSelected(0);
      myrect3[i].colorChange(rectColor, elementColor);
    }
    myrect3[i].display();
  }
}



void TableUser() {
}
