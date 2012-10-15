class FileWriter {

  PrintWriter output;
  File file;
  String filePath;
  String[] fileContent;
  int fileContentCount;

  FileWriter() {
    emptyFileContent();
  }

  void createSaveFile() {
    filePath = fileReader.filePath;
    file = new File(filePath);
    if (file.exists()) {
      if (file.delete()) println("file deleted");
    }

    output = createWriter(filePath);
  }

  void addToSave(String [] in) {
    expand(fileContent, in.length);
    fileContent = concat(fileContent, in);
  }

  void write() {
    try {
      saveStrings(filePath, fileContent);
      emptyFileContent();
      output.flush(); // Writes the remaining data to the file
      output.close(); // Finishes the file
      println(filePath + " written");
    } 
    catch(Exception e) {
      e.printStackTrace();
    }
  }

  void emptyFileContent() {
    fileContent = new String[1];
    fileContent[0] = ("DO NOT EDIT! This is a ZYX save file. © Emil Lewandowski 2012 - emilemil.emil@gmail.com");
  }
}

class FileReader {

  String[] lines;
  String filePath;

  FileReader() {
  }

  void read(int fileNum) {
    try {
        filePath = ("/sdcard/ZYX/ZYX-SAVE-"+nf(fileNum,2)+".txt");
        lines = loadStrings(filePath);
        
        int tempPosCountX = 0;
        int tempPosCountY = 0;
        int mapRectNum = 0;
        String[] pieces;
        String[] posData;
        String[] typeData;

        for (int i=0; i<lines.length; i++) {

          pieces = split(lines[i], TAB);
          posData = new String[4];
          typeData = new String[16];
          Position p;

          if (pieces[0].equals("MAPRECT")) {
            mapRectNum = Integer.parseInt(pieces[1]);
            tempPosCountX = 0;
          }
          else if (pieces[0].equals("ASSIGNMENT AUDIO")) {
            mMR.mapArray[mapRectNum].mappingAudio = Integer.parseInt(pieces[1]);
            mMR.mapArray[mapRectNum].dDMenuAudio.currentSelection = parameterListAudio[Integer.parseInt(pieces[1])];
          }
          else if (pieces[0].equals("ASSIGNMENT VISUAL")) {
            mMR.mapArray[mapRectNum].mappingVisual = Integer.parseInt(pieces[1]);
            mMR.mapArray[mapRectNum].dDMenuVisual.currentSelection = parameterListVisual[Integer.parseInt(pieces[1])];
          }
          else if (pieces[0].equals("BOIDTYPES")) {
            typeData = split(pieces[1], ",");
            //pieces.length-1 because the last piece is always empty, beacuse of the forloop in mMR
            for (int j=0; j<typeData.length-1; j++) mMR.boidTypes[j] = Integer.valueOf(typeData[j]);
            boidTypeClicker.val = mMR.boidTypes[typeData.length-1];
            boidTypeClicker.val = mMR.boidTypes[boidEditNumClicker.val];
          }
          else if (pieces[0].equals("PATH")) {
            tempPosCountY = 0;

            for (int j=2; j<pieces.length-1; j++) {
              posData = split(pieces[j], ",");
              p = new Position(int(Float.parseFloat(posData[0]) * mMR.mapArray[mapRectNum].w), Float.parseFloat(posData[1]), 
              int(Float.parseFloat(posData[0]) * mMR.mapArray[mapRectNum].resolution * mMR.mapArray[mapRectNum].w), int((1-Float.parseFloat(posData[1])) * mMR.mapArray[mapRectNum].h));
              mMR.mapArray[mapRectNum].positions[tempPosCountX][tempPosCountY] = p;
              tempPosCountY++;
            }
            
            mMR.mapArray[mapRectNum].posCountY[tempPosCountX] = tempPosCountY;
            mMR.posCountX = mMR.posCountXDisplay = tempPosCountX;
            mMR.posCountXMax = tempPosCountX + 1;
            boidEditNumClicker.setVal(tempPosCountX);
            boidDisplayNumClicker.setVal(tempPosCountX);
            boidTypeClicker.setVal(mMR.boidTypes[boidEditNumClicker.val]);
            tempPosCountX++;
          }
        }
        
        println(filePath +" read. Parsed all " +lines.length+ " lines");
      
    }
    catch(NullPointerException e) {
      println(e);
    }
    catch(IllegalArgumentException e) {
      println(e);
    }
  }
}

