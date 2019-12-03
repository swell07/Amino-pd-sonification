import netP5.*;
import oscP5.*;

OscP5 oscP5;
NetAddress myRemoteLocation;

int questionnum = 0, sourcenum = 0;
int atomnumber = 4;
int starttime, stoptime, resulttime;
int totalsample = 24;
IntList sampleplayorder;
int shuffleorder, preorder, curorder;
int[] elementplayer = {1, 2, 3, 4};
String[] elementname = {"H", "C", "O", "N"};
String[] elementdirection = {"T", "L", "B", "R"};
int[] playbacktime = {1000, 2000, 4000};

String[] samplename = {"CCCH4", "CCCH8", "-CNC4", "-CNC8", "-COC4", "-COC8", "-NNN4", "-NNN8", "-NOC4", "-NOC8", 
  "C-OO4", "C-OO8", "CCCH4", "CCCH8", "CCOH4", "CCOH8", "CHCH4", "CHCH8", "H-NC4", "H-NC8", "HHHC4", "HHHC8", 
  "HNHC4", "HNHC8", "HOHC4", "HOHC8", "NCCH4", "NCCH4"
};

Table table, table2;

boolean pretest, posttest;

OscMessage MessageTime, MessageTime2;
OscMessage MessagePlayer, MessagePlayer2;
//OscMessage MessageElementName;
//OscMessage MessageElementDirection;

//display-interface

int rectX, rectY, rectSize;
color rectColor, highlightColor, selectedColor, currentColor;
color elementColor, selectedelementColor, currentelementColor;
int select_i, select_j; 

MyRect[][] myrect;

String filename, f_year, f_month, f_day, f_hour, f_minute;

void setup() {
  size(500, 500);
  frameRate(25);
  oscP5 = new OscP5(this, 4567);
  myRemoteLocation = new NetAddress("127.0.0.1", 7654);

  // create excel table name
  f_year = str(year());
  f_month = str(month());
  f_day = str(day());
  f_hour = str(hour());
  f_minute = str(minute());

  filename = f_year + f_month + f_day + f_hour + f_minute + ".csv";

  // create a shuffle list
  sampleplayorder = new IntList();
  for (int i = 0; i < samplename.length; i++) {
    sampleplayorder.append(i);
  }

  sampleplayorder.shuffle();
  pretest = true;
  posttest = false;

  // draw pretest table 
  table = new Table();
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
      } 
      if (i == 1) {
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
  if (pretest == true) {
    switch (keyCode) {
    case ENTER:
      questionnum++;
      SendToPD();
      DisplayChoice();
      saveTable(table, filename);
      println("pretest");
      break;

    case TAB:
      pretest = false;
      questionnum = 0;
      sampleplayorder.shuffle();
      //draw posttest column
      DrawTable();
      text();
      println("posttest now!");
    }
  } else {
    switch (keyCode) {
    case ENTER:
      questionnum++;
      SendToPD();
      DisplayChoice();
      saveTable(table, filename); 
      break;
    }
  }
}


void SendToPD() {
  //choose a sample
  if (questionnum > 1 && questionnum <= samplename.length + 1 && shuffleorder >= 0) {
    preorder = shuffleorder;
  } else {
    preorder = -1;
  }

  if (questionnum < samplename.length + 1) {
    //shuffle a number from sample array
    shuffleorder = sampleplayorder.get(questionnum-1);
    print(questionnum, shuffleorder);
    String samplePlay = samplename[shuffleorder];
    int ElementTime = int(str(samplePlay.charAt(4)));
    //MessageTime.add(ElementTime);
    //oscP5.send(MessageTime, myRemoteLocation);

    //send sample name to PD
    MessagePlayer = new OscMessage("/player");
    MessagePlayer.add(samplePlay);
    oscP5.send(MessagePlayer, myRemoteLocation);

    //draw a new row in table for questions, or find it in posttest
    TableRow newRow = table.addRow();
    TableRow findRow = table.findRow("Q"+shuffleorder, "file_order");

    if (pretest == true) {
      newRow.setString("file_order", "Q"+shuffleorder);
      newRow.setString("num_pre", "Question " + questionnum);
      newRow.setInt("time_pre", ElementTime*1000);
    } else {
      findRow.setString("num_post", "Question " + questionnum);
      findRow.setInt("time_post", ElementTime*1000);
    }

    for (int i = 0; i <atomnumber; i++) {

      int ElementPlayer = elementplayer[i];
      String ElementName = str(samplePlay.charAt(i));
      String ElementDirection = elementdirection[(i+1)%4];


      println(questionnum + ": " + ElementTime, ElementPlayer, ElementName, ElementDirection);

      //fill four generated results in this row
      //TableQues(questionnum, ElementName, ElementDirection);
      if (pretest== true) {
        newRow.setString(ElementDirection+"1", ElementName);//ElementDirection, ElementName
      } else {
        findRow.setString(ElementDirection+"2", ElementName);
      }
    }
  }
}

void DrawTable() { 
  shuffleorder = -1;
  if (pretest == true) {
    table.addColumn("num_pre");
    table.addColumn("file_order");

    //draw table: four direction columns
    for (int i = 0; i<elementdirection.length; i++) {
      table.addColumn(elementdirection[i] + "1");
    }

    //add time 
    table.addColumn("time_pre");
  } else {
    table.addColumn("num_post");
    for (int i = 0; i<elementdirection.length; i++) {
      table.addColumn(elementdirection[i] + "2");
    }

    table.addColumn("time_post");
  }

  saveTable(table, filename);
}

void DisplayChoice() {
  background(0);
  textSize(15);
  fill(255);

  if (questionnum < samplename.length + 1) {
    if (pretest == true) {
      text("Pretest Question " + questionnum, 10, 20);
    } else {
      text("Posttest Question " + questionnum, 10, 20);
    }
    for (int i = 0; i < 4; i++) {
      for (int j = 0; j < 4; j++) {
        myrect[i][j].colorChange(rectColor, elementColor);
        myrect[i][j].display();
      }
    }
  } else if (questionnum == samplename.length + 1) {
    if (pretest == true) {
      text("Pretest ends, thank you!", 10, 20 );
    } else {
      text("Posttest ends, thank you!", 10, 20 );
    }
  }

  stoptime = millis();
  resulttime = stoptime - starttime;

  //draw a new row in table for users  
  if (pretest == true) {
    if (questionnum > 0 && questionnum < samplename.length + 1) {
      TableRow newRow = table.addRow();
      newRow.setString("file_order", "R" + shuffleorder);
      newRow.setString("num_pre", "Result " + questionnum);
    }

    if (questionnum > 1 && questionnum <= samplename.length + 1) {
      TableRow row = table.getRow(questionnum*2-3);
      row.setInt("time_pre", resulttime);
    }
  }
  //posttest
  if (pretest != true) {
    if (questionnum > 0 && questionnum < samplename.length + 1) {
      TableRow findRow = table.findRow("R" + shuffleorder, "file_order");
      findRow.setString("num_post", "Result " + questionnum);
    }

    if (questionnum > 1 && questionnum <= samplename.length + 1 && preorder >= 0) {
      TableRow row = table.findRow("R" + preorder, "file_order");
      row.setInt("time_post", resulttime);
      print("preorder" + preorder + "result :" + resulttime);
    }
  }

  starttime = millis();
}

void mousePressed() {

  for (int i = 0; i < 4; i++) {
    for (int j = 0; j < 4; j++) {
      if ( myrect[i][j].overRect()) {
        select_i = i;
        select_j = j;


        if (pretest == true) {
          TableRow row = table.getRow(questionnum*2-1);
          row.setString(elementdirection[i]+"1", elementname[j]);
        } else {
          TableRow findrow = table.findRow("R"+shuffleorder, "file_order");
          findrow.setString(elementdirection[i]+"2", elementname[j]);
        }
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
