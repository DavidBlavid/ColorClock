String hours, minutes, seconds;
float red, green, blue;

int fontCounter;      // current position in fonts array
int maxFonts;         // max number of fonts
int fontCooldown;     // frametimer for font change cooldown
int fontCooldownMax;  // length of cooldown
EFont[] fonts;        // contains all fonts
String[] fontNames;   // names of fonts, is used to build fonts[]

boolean showDate;     // show the date?

float spacing;        // spacing between the characters HH : MM : SS
int fontSize;         // size of font
float xAdjust;        // adjust x position
float yAdjust;        // adjust y position

String mode;          // "light" or "dark" for light or darkmode


void setup(){
 
  size(600, 200);
  surface.setTitle("ColorClock");
  
  fontSize = 80;  // starting font size
  fontNames = new String[]{
    
    "Courier New Bold",
    "Broadway",
    "Lucida Console",
    "Rockwell",
    "Consolas",
    "Comic Sans MS Bold"
    
  };
  
  maxFonts = fontNames.length;
  
  fonts = new EFont[maxFonts];
  
  for (int i = 0; i < maxFonts; i++){
    
    String currentFontName = fontNames[i];
    
    fonts[i] = new EFont(currentFontName, fontSize);
    
    
  }
  
  surface.setResizable(true); 
  
  fontCounter = 0;
  fontCooldownMax = 15;
  
  showDate = true;
  
  
  // horizontal spacing between hours and minutes and seconds
  // can be changed with +-.,
  spacing = 3;
  
  mode = "light";
  
  // load previous session if it exists
  loadSessionData();
  
  textFont(fonts[0].getFont());
  
  
  //printArray(PFont.list());
  
}

void keyPressed(){
  
  // change font
  if(key == ' '){
    fontCounter++;
    if(fontCounter == maxFonts) fontCounter = 0;
    
    fonts[fontCounter].setSize(fontSize);
  }
  
  if (key == '+') spacing /= 1.2;    // spacing big adjust +
  if (key == '-') spacing *= 1.2;    // spacing big adjust -
  if (key == '.') spacing /= 1.03;   // spacing small adjust +
  if (key == ',') spacing *= 1.03;   // spacing small adjust -
  
  if (key == 'd') showDate = !showDate;  // toggle show date
  
  // increase font size
  if (key == 'w'){
    if(fontSize <= 500) fontSize += 2;
    fonts[fontCounter].setSize(fontSize);
  };
  
  // decrease font size
  if (key == 's') {
    if(fontSize >= 3) fontSize -= 2;
    fonts[fontCounter].setSize(fontSize);
  };
  
  // reset to x and y adjust
  if(keyCode == ENTER){
     
    yAdjust = 0;
    xAdjust = 0;
      
  }
  
  // detect special keys
  // use keyCode here, not key
  if(key == CODED){
    
    // x and y adjust
    if(keyCode == UP)     yAdjust -= 1;
    if(keyCode == DOWN)   yAdjust += 1;
    if(keyCode == LEFT)   xAdjust -= 1;
    if(keyCode == RIGHT)  xAdjust += 1;
    
  }
  
  saveSessionData();
  
}

void draw(){
  
    red = map(  hour(), 0, 23, 0, 255);
  green = map(minute(), 0, 59, 0, 255);
   blue = map(second(), 0, 59, 0, 255);
   
    hours = str(hour());
  minutes = str(minute());
  seconds = str(second());
  
  if (  hours.length() == 1)    hours = "0" + hours;
  if (minutes.length() == 1)  minutes = "0" + minutes;
  if (seconds.length() == 1)  seconds = "0" + seconds;
  
  float segment = width / spacing;
  
  //println(hours + ":" + minutes + ":" + seconds);
  
   if (mousePressed == true && fontCooldown <= 0) {
    
     if(mode == "light") mode =  "dark";
     else                mode = "light";
     
     fontCooldown = fontCooldownMax;
     
     saveSessionData();
   
   }
   
   fontCooldown = fontCooldown - 1;
   
   PFont currentFont = fonts[fontCounter].getFont();
  
  textFont(currentFont);
  
     
   if(mode.equals("light")) {
   
     background(red, green, blue);
     fill(255);
     
   }
   
   
   if(mode.equals("dark")) {
   
     background(red * 0.1, green * 0.1, blue * 0.1, 0.3);
     fill(red * 1.1, green * 1.3, blue * 1.2);
     
   }
  
  // Main time
  // HH : MM : SS
  textAlign(CENTER, CENTER);
  text(  hours, ((width / 2) - segment * 1)   + xAdjust, (height/2 - 10) + yAdjust);
  text(    ":", ((width / 2) - segment * 1/2) + xAdjust, (height/2 - 15) + yAdjust);
  text(minutes, ((width / 2)                ) + xAdjust, (height/2 - 10) + yAdjust);
  text(    ":", ((width / 2) + segment * 1/2) + xAdjust, (height/2 - 15) + yAdjust);
  text(seconds, ((width / 2) + segment * 1)   + xAdjust, (height/2 - 10) + yAdjust);
  
  // Date
  if(showDate){
    
    float endOfTime = textWidth(seconds);
    textAlign(RIGHT);
    
    String day   = str(day());
    String month = str(month());
    String year  = str(year());
    
    if(day.length() == 1) day = "0" + day;
    if(month.length() == 1) month = "0" + month;
    
    String dateString = day + "." + month + "." + year;
    
    textSize(fontSize/1.9);
    text(dateString, ((width / 2) + segment + endOfTime/2) + xAdjust, (height/2 + fontSize) + yAdjust);
    
    
  }
  
}

void surfaceResized() {
  saveSessionData();
}

public void saveSessionData(){
  
  String[] dataToSave = new String[8];
  
  dataToSave[0] = str(fontCounter);
  dataToSave[1] = str(fontSize);
  dataToSave[2] = str(spacing);
  dataToSave[3] = mode;
  dataToSave[4] = str(width);
  dataToSave[5] = str(height);
  dataToSave[6] = str(xAdjust);
  dataToSave[7] = str(yAdjust);
  
  saveStrings("settings.txt", dataToSave);
  
  print("s");
  
}

public boolean loadSessionData(){
  
  String path = sketchPath() + "/settings.txt";
   
  if (new File(path).exists()) {
    String[] loadedData = loadStrings("settings.txt");
    
    fontCounter = int(loadedData[0]);
    fontSize    = int(loadedData[1]);
    spacing     = float(loadedData[2]);
    mode        = loadedData[3];
    
    int new_width  = int(loadedData[4]);
    int new_height = int(loadedData[5]);
    
    xAdjust = int(loadedData[6]);
    yAdjust = int(loadedData[7]);
    
    fonts[fontCounter].setSize(fontSize);
    surface.setSize(new_width, new_height);
    
    print("l+");
    
    return true;
      
  } else {
    
    print("l-");
    
    return false;
    
  }
    
}
