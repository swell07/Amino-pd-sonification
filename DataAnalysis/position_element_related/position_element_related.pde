String filename, fileresult;
Table table, table_result;
String Q_T_pre, R_T_pre, Q_L_pre, R_L_pre, Q_B_pre, R_B_pre, Q_R_pre, R_R_pre, Q_T_post, R_T_post, Q_L_post, R_L_post, Q_B_post, R_B_post, Q_R_post, R_R_post;
int totalQ, score_T_pre, score_L_pre, score_B_pre, score_R_pre, score_T_post, score_L_post, score_B_post, score_R_post;
int time_pre, time_post, participant,dev;

String [] element = {"H", "C", "N", "O", "-"};
float [][] ep_correct, ep_total;
float[][] CheckElement;

String type = "pre";
int _dev = 1;
String [] position = {"T1", "L1", "B1", "R1"};
//String type = "post";
//int _dev = 5;
//String [] position = {"T2", "L2", "B2", "R2"};

void setup() {
  //selectInput("Select a file:", "fileSelected");
  filename = "202001161452.csv";
  participant = 1;
  dev = _dev+(participant-1)*8;
  fileresult = "position-element-related.csv";
  table = loadTable(filename, "header");
  table_result = loadTable(fileresult, "header"); 
  totalQ = 28;

  //myelement =  new MyElement();
  ep_correct = new float [4][5];
  ep_total = new float [4][5];
  score_T_pre = 0;
  score_L_pre = 0;
  score_B_pre = 0;
  score_R_pre = 0;

  time_pre = 0;
  time_post = 0;

  //myelement[0] = new MyElement("H");

  for (int i = 0; i < position.length; i ++) {
    for (int j = 0; j < element.length; j ++) {
      ep_correct[i][j] = 0;
      ep_total[i][j] = 0;
    }
  }


  for (int i = 0; i < totalQ; i++) {

    TableRow rowQ = table.getRow(i*2);
    Q_T_pre = rowQ.getString(position[0]);
    Q_L_pre = rowQ.getString(position[1]);
    Q_B_pre = rowQ.getString(position[2]);
    Q_R_pre = rowQ.getString(position[3]);

    TableRow rowR = table.getRow(i*2+1);
    R_T_pre = rowR.getString(position[0]);
    R_L_pre = rowR.getString(position[1]);
    R_B_pre = rowR.getString(position[2]);
    R_R_pre = rowR.getString(position[3]);

    String fileorder = rowQ.getString("file_order");
    float filescore = 0;

    time_pre = time_pre + rowR.getInt("time_pre");
    time_post = time_post + rowR.getInt("time_post");

    //println( rowR.getInt("time_pre") + " and " + time_pre + " THEN " +rowR.getInt("time_post") + " and " + time_post);

///*
    for (int j = 0; j < 5; j++) {
      if (element[j].equals(Q_T_pre)) {
        ep_total[0][j] ++;
        if ( R_T_pre.equals(Q_T_pre) == true) {
          ep_correct[0][j] ++;
        } else {
          ep_correct[0][j] += 0;
        }
      }
      if (element[j].equals(Q_L_pre)) {
        ep_total[1][j] ++;
        if ( R_L_pre.equals(Q_L_pre) == true) {
          ep_correct[1][j] ++;
        } else {
          ep_correct[1][j] += 0;
        }
      }
      if (element[j].equals(Q_B_pre)) {
        ep_total[2][j] ++;
        if ( R_B_pre.equals(Q_B_pre) == true) {
          ep_correct[2][j] ++;
        } else {
          ep_correct[2][j] += 0;
        }
      }
      if (element[j].equals(Q_R_pre)) {
        ep_total[3][j] ++;
        if ( R_R_pre.equals(Q_R_pre) == true) {
          ep_correct[3][j] ++;
        } else {
          ep_correct[3][j] += 0;
        }
      }
    }
  }

  for (int i = 0; i < position.length; i ++) {
   // TableRow newRow = table_result.getRow(i%4+dev);
   TableRow newRow = table_result.addRow();
    newRow.setInt("participant", participant);
    newRow.setString("pos", position[i]);
    newRow.setString("type", type);
    for (int j = 0; j < element.length; j ++) {
      //TableRow findRow = findRow(position[i],)
      if (ep_total[i][j] != 0) {
        newRow.setFloat(element[j], (ep_correct[i][j]/ep_total[i][j]));
        println(element[j] + " is on " + position[i]+ " : " + ep_correct[i][j]+ " / " + ep_total[i][j]);
      } else {
        newRow.setString(element[j], "-");
        println(element[j] + " is on " + position[i]+ " : - ");
      }
      saveTable (table_result, "data/"+fileresult);
//
      
    }
  }
}
