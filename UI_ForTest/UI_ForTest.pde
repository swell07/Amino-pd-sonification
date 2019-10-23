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
int select_i, select_j; 

MyRect[][] myrect;

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

  myrect = new MyRect[4][4];//new MyRect[atomnumber][elementname.length];
  for (int i = 0; i < 4; i++) {
    for (int j = 0; j < 4; j++) {

      //myrect[i][j] = new MyRect(i, j, rectSize, currentColor, elementname[j], currentelementColor, elementdirection[i]);
      // println("myrect["+i+"]["+j+"]" );
      int rectx, recty;
      if (i == 0) {
        rectx = width/2 +(j-2)*rectSize;
        recty = rectSize;
        myrect[i][j] = new MyRect(rectx, recty, rectSize, currentColor, elementname[j], currentelementColor, elementdirection[i]);
        //myrect[i][j].display();
        println("myrect["+i+"]["+j+"]" + " : " + rectx + " ; " + recty);
      } else {
        rectx = (j+1)*rectSize;
        recty = height/2 - rectSize;
        myrect[i][j] = new MyRect(rectx, recty, rectSize, currentColor, elementname[j], currentelementColor, elementdirection[i]);
        // myrect[i][j].display();
        println("myrect["+i+"]["+j+"]" + " : " + rectx + " ; " + recty);
      }
      if (i == 2) {
        rectx = width/2 + (j-2)*rectSize;
        recty = height - 2*rectSize;
        myrect[i][j] = new MyRect(rectx, recty, rectSize, currentColor, elementname[j], currentelementColor, elementdirection[i]);
        //  myrect[i][j].display();
      } else if (i == 3) {
        rectx = width + (j-5)*rectSize;
        recty = height/2 - rectSize;
        myrect[i][j] = new MyRect(rectx, recty, rectSize, currentColor, elementname[j], currentelementColor, elementdirection[i]);
        //  myrect[i][j].display();
      }
      // myrect[i][j].display();
    }
  }
}

void draw() {  

  //background(0);

  for (int i = 0; i < 4; i++) {
    for (int j = 0; j < 4; j++) {

      myrect[i][j].update();
    }
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
    for (int j = 0; j < 4; j++) {
      myrect[i][j].colorChange(rectColor, elementColor);
      myrect[i][j].display();
    }
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
    for (int j = 0; j < 4; j++) {
      if ( myrect[i][j].overRect()) {
        select_i = i;
        select_j = j;

        TableRow row = table.getRow(questionnum*2-1);
        row.setString(elementdirection[i], elementname[j]);
       
      }
    }
  }

  println(select_i + " ; " + select_j);


  for (int j = 0; j < 4; j++) {
    if (j == select_j) {
      myrect[select_i][j].colorChange(selectedColor, selectedelementColor);
      println("select: " + j + " , " + myrect[select_i][j].getColor());
      myrect[select_i][j].display();
    } else {
      myrect[select_i][j].colorChange(rectColor, elementColor);
      println("unselect: " + j + " , " + myrect[select_i][j].getColor());
      myrect[select_i][j].display();
    }    
  }

}





void TableUser() {
}
