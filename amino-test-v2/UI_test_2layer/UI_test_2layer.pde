import netP5.*;
import oscP5.*;

OscP5 oscP5;
NetAddress myRemoteLocation;
OscMessage MessageQuestion;
OscMessage MessageCondition;

//condition order
int con1 = 1, con2 = 2;

int questionnum = 0, sourcenum = 0, examplenum = 0;
int atomnumber = 8, totalexample = 4;
int starttime, stoptime, resulttime;
int totalsample = 24;
IntList sampleplayorder;
int shuffleorder, preorder, curorder;

int [] elementlayer = {1, 2};
String[] elementname = {"H", "C", "N", "O", "-"};
String[] elementdirection = {"T", "L", "B", "R"};
String[] samplename = {"HCCO-HCH", "HNCC-HHO", "HNCC-CCO", "CCCCHHHH", 
  "CHCCH-HH", "OC-O-N-H", "HCCO-NHH", "C-CNC-NC"};


boolean condition1, condition2, showexample;

//draw interface
int rectX, rectY, rectSize;
color rectColor, highlightColor, selectedColor, currentColor;
color elementColor, selectedelementColor, currentelementColor;
int select_i, select_j, select_k; 

MyRect[][][] myrect;

//table settings
String filename, f_year, f_month, f_day, f_hour, f_minute;
Table table, table2;

void setup() {
  size(780, 780); //rectsize*13
  frameRate(25);

  //send to pd settings
  oscP5 = new OscP5(this, 2121);
  myRemoteLocation = new NetAddress("127.0.0.1", 1212);

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
  condition1 = true;
  condition2 = false;
  showexample = true;

  // draw condition1 table 
  table = new Table();
  DrawTable();

  starttime = 0;
  resulttime = 0;


  //set up interface design: colors and fonts
  rectX = width/2;
  rectY = height/2;
  rectSize = 60;

  rectColor = color(0);
  highlightColor = color(51);
  selectedColor = color(255);
  elementColor = color(255);
  selectedelementColor = color(0);

  currentColor = rectColor;
  currentelementColor = elementColor;

  myrect = new MyRect[elementdirection.length][elementname.length][elementlayer.length];//new MyRect[atomnumber][elementname.length];
  for (int i = 0; i < elementdirection.length; i++) {
    for (int j = 0; j < elementname.length; j++) {
      for (int k = 0; k < elementlayer.length; k++) {

        //myrect[i][j] = new MyRect(i, j, rectSize, currentColor, elementname[j], currentelementColor, elementdirection[i]);
        // println("myrect["+i+"]["+j+"]" );
        int rectx, recty;
        if (i == 0) {
          rectx = (j+4)*rectSize;
          recty = (2-k)*rectSize + (1-k)*rectSize*2/3;
          myrect[i][j][k] = new MyRect(rectx, recty, rectSize, currentColor, elementname[j], currentelementColor, elementdirection[i]);
          //myrect[i][j].display();
         // println("myrect["+i+"]["+j+"]" + " : " + rectx + " ; " + recty);
        } 
        if (i == 1) {
          recty = (j+1)*rectSize + height/4;
          rectx = (2-k)*rectSize+(1-k)*rectSize*2/3;
          myrect[i][j][k] = new MyRect(rectx, recty, rectSize, currentColor, elementname[j], currentelementColor, elementdirection[i]);
          // myrect[i][j].display();
          //println("myrect["+i+"]["+j+"]" + " : " + rectx + " ; " + recty);
        }
        if (i == 2) {
          rectx = (j+4)*rectSize;
          recty = height - ( (3-k)*rectSize +(1-k)*rectSize*2/3);
          myrect[i][j][k] = new MyRect(rectx, recty, rectSize, currentColor, elementname[j], currentelementColor, elementdirection[i]);
          //  myrect[i][j].display();
        } else if (i == 3) {
          recty = height/4 + (j+1)*rectSize;
          rectx = width - ( (3-k)*rectSize +(1-k)*rectSize*2/3);
          myrect[i][j][k] = new MyRect(rectx, recty, rectSize, currentColor, elementname[j], currentelementColor, elementdirection[i]);
          //  myrect[i][j].display();
        }
        // myrect[i][j].display();
      }
    }
  }


  background(0);
  textSize(20);
  fill(255);
  text("Please press ENTER to start condition 1 if you are ready.", 10, 20);
  println(condition1);
}

void draw() {  

  //background(0);
  for (int i = 0; i < elementdirection.length; i++) {
    for (int j = 0; j < elementname.length; j++) {
      for (int k = 0; k < elementlayer.length; k++) {

        myrect[i][j][k].update();
      }
    }
  }

 
}


void keyPressed() {
  if (key == 27) {
    key = 0;
  }

  if (condition1 == true) {
    if (showexample == true) {
      switch (keyCode) {
      case ENTER:
        examplenum++;
        DisplayExample();
        break;
      }
    } else {
      switch (keyCode) {
      case ENTER:
        questionnum++;
        SendToPD();
        DisplayChoice();
        saveTable(table, filename);
        println("con 1");
        break;

      case TAB:
        condition1 = false;
        showexample = true;
        questionnum = 0;
        examplenum = 0;
        sampleplayorder.shuffle();
        //draw con2 column
        DrawTable();
        background(0);
        text("Please press ENTER to start Condition 2.", 10, 20);
        println("con 2 now!");
      }
    }
  } else {
    if (showexample == true) {
      switch (keyCode) {
      case ENTER:
        examplenum++;
        DisplayExample();
        break;
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
    //int ElementTime = int(str(samplePlay.charAt(4)));
    //MessageTime.add(ElementTime);
    //oscP5.send(MessageTime, myRemoteLocation);

    //send sample name to PD
    MessageQuestion = new OscMessage("/question");
    MessageQuestion.add(shuffleorder);
    if (condition1 == true) {
      MessageQuestion.add(con1);
    } else {
      MessageQuestion.add(con2);
    } 
    //else  (condition2 == true){
    //MessageQuestion.add(0);
    //}

    oscP5.send(MessageQuestion, myRemoteLocation);
    println("PD questions: " + MessageQuestion);

    //draw a new row in table for questions or find it in condition2
    TableRow newRow = table.addRow();
    TableRow findRow = table.findRow("Q"+shuffleorder, "file_order");

    if (condition1 == true) {
      newRow.setString("file_order", "Q"+shuffleorder);    
      newRow.setString("num_con"+con1, "Question " + questionnum);
      //newRow.setInt("time_con"+con1, ElementTime*1000);
    } else {
      findRow.setString("num_con"+con2, "Question " + questionnum);
      //findRow.setInt("time_con"+con2, ElementTime*1000);
    }

    for (int k = 0; k <elementlayer.length; k++) {
      for (int i = 0; i <elementdirection.length; i++) {
        // int ElementPlayer = elementplayer[i];
        String ElementName = str(samplePlay.charAt(i+k*4));
        String ElementDirection = elementdirection[i%4];
        int ElementLayer = elementlayer[k];


        //println(questionnum + ": " + ElementTime, ElementPlayer, ElementName, ElementDirection);

        if (condition1== true) {
          newRow.setString("con" + con1 + "_" + ElementDirection+ElementLayer, ElementName);//ElementDirection, ElementName
        } else {
          findRow.setString("con" + con2 + "_" + ElementDirection+ElementLayer, ElementName);
        }
      }
    }
  }
}


void DisplayExample() {
  background(0);
  textSize(20);
  fill(255);
  println("Example number: " + examplenum);

  if (examplenum < totalexample) {
    if (condition1 == true) {
      text("condition1 Example " + examplenum, 10, 20);
    } else {
      text("condition2 Example " + examplenum, 10, 20);
    }

    for (int i = 0; i < elementdirection.length; i++) {
      for (int j = 0; j < elementname.length; j++) {
        for (int k = 0; k < elementlayer.length; k++) {
          myrect[i][j][k].colorChange(rectColor, elementColor);
          myrect[i][j][k].display();
        }
      }
    }
    MessageQuestion = new OscMessage("/question");
    MessageQuestion.add(examplenum+10);
    if (condition1 == true) {
      MessageQuestion.add(con1);
    } else {
      MessageQuestion.add(con2);
    } 
    oscP5.send(MessageQuestion, myRemoteLocation);
  } else if (examplenum == totalexample) {
    showexample = false;
    text("Example ends, please press Enter to continue the test.", 10, 20 );
    println("example ends," + showexample);
  }
}


void DisplayChoice() {
  background(0);
  textSize(20);
  fill(255);

  if (questionnum < samplename.length + 1) {
    if (condition1 == true) {
      text("condition1 Question " + questionnum, 10, 20);
    } else {
      text("condition2 Question " + questionnum, 10, 20);
    }
    for (int i = 0; i < elementdirection.length; i++) {
      for (int j = 0; j < elementname.length; j++) {
        for (int k = 0; k < elementlayer.length; k++) {
          myrect[i][j][k].colorChange(rectColor, elementColor);
          myrect[i][j][k].display();
        }
      }
    }
  } else if (questionnum == samplename.length + 1) {
    if (condition1 == true) {
      text("condition 1 ends, thank you! Please press TAB to continue.", 10, 20 );
    } else {
      text("condition 2 ends, thank you!", 10, 20 );
    }
  }

  stoptime = millis();
  resulttime = stoptime - starttime;

  //draw a new row in table for users  
  if (condition1 == true) {
    if (questionnum > 0 && questionnum < samplename.length + 1) {
      TableRow newRow = table.addRow();
      newRow.setString("file_order", "R" + shuffleorder);
      newRow.setString("num_con" + con1, "Result " + questionnum);
    }

    if (questionnum > 1 && questionnum <= samplename.length + 1) {
      TableRow row = table.getRow(questionnum*2-3);
      row.setInt("time_con" + con1, resulttime);
    }
    //println("condition1 table; " + "R" + shuffleorder);
  }
  //condition2
  if (condition1 != true) {
    if (questionnum > 0 && questionnum < samplename.length + 1) {
      TableRow findRow = table.findRow("R" + shuffleorder, "file_order");
      findRow.setString("num_con" + con2, "Result " + questionnum);
    }

    if (questionnum > 1 && questionnum <= samplename.length + 1 && preorder >= 0) {
      TableRow row = table.findRow("R" + preorder, "file_order");
      row.setInt("time_con" + con2, resulttime);
      print("preorder" + preorder + "result :" + resulttime);
    }
  }

  starttime = millis();
}

void DrawTable() {
  shuffleorder = -1;
  if (condition1 == true) {
    table.addColumn("num_con" + con1);
    table.addColumn("file_order");

    //draw table: four direction columns in 2 layers
    for (int k = 0; k < elementlayer.length; k++) {
      for (int i = 0; i< elementdirection.length; i++) {

        table.addColumn("con" + con1 + "_" + elementdirection[i] + elementlayer[k]);
      }
    }
    //add time 
    table.addColumn("time_con" + con1);
  } else {
    table.addColumn("num_con" + con2); 
    for (int k = 0; k < elementlayer.length; k++) {
      for (int i = 0; i< elementdirection.length; i++) {

        table.addColumn("con" + con2 + "_" + elementdirection[i] + elementlayer[k]);
      }
    }

    table.addColumn("time_con" + con2);
  }

  saveTable(table, filename);
}


void mousePressed() {

  for (int i = 0; i < elementdirection.length; i++) {
    for (int j = 0; j < elementname.length; j++) {
      for (int k = 0; k < elementlayer.length; k++) {
        if ( myrect[i][j][k].overRect()) {
          select_i = i; 
          select_j = j; 
          select_k = k; 


          if (showexample == false) {
            if (condition1 == true) {
              TableRow row = table.getRow(questionnum*2-1);
              row.setString("con" + con1 + "_" + elementdirection[select_i] + elementlayer[select_k], elementname[select_j]);
            } else {
              TableRow findrow = table.findRow("R"+shuffleorder, "file_order");
              findrow.setString("con" + con2 + "_" + elementdirection[select_i] + elementlayer[select_k], elementname[select_j]);
            }
            //print
           // println("Mouse Select: "+ elementdirection[select_i]+", layer :" + elementlayer[select_k] + ", name: " + elementname[select_j]);
          }
        }
      }
    }
  }

  //println("select :" + select_i + " ; " + select_j + " ; " + select_k); 


  for (int j = 0; j < elementname.length; j++) {
    if (j == select_j) {
      myrect[select_i][j][select_k].colorChange(selectedColor, selectedelementColor); 
      //println("select: " + j + " , " + myrect[select_i][j][select_k].getColor()); 
      myrect[select_i][j][select_k].display();
    } else {
      myrect[select_i][j][select_k].colorChange(rectColor, elementColor); 
      //  println("unselect: " + j + " , " + myrect[select_i][j][select_k].getColor()); 
      myrect[select_i][j][select_k].display();
    }
  }
}
