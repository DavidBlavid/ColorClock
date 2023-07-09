String hours, minutes, seconds;
float red, green, blue;

int fontCounter;      // current position in fonts array
int maxFonts;         // max number of fonts
int fontCooldown;     // frametimer for font change cooldown
int fontCooldownMax;  // length of cooldown
EFont[] fonts;        // contains all fonts
String[] fontNames;   // names of fonts, is used to build fonts[]

boolean showDate;     // show the date?
boolean showRGBValues;// show the RGB values?
boolean showTimer;    // show the timer?

float spacing;        // spacing between the characters HH : MM : SS
int fontSize;         // size of font
float xAdjust;        // adjust x position
float yAdjust;        // adjust y position

String mode;          // "light" or "dark" for light or darkmode

Timer timer;          // the timer that gets displayed when showTimer is true
PImage timerIconWhite, timerIconBlack;

void setup(){
 
  // window settings
  size(600, 200);
  surface.setTitle("ColorClock");
  surface.setResizable(true); 
  
  // font settings
  // you can get a list of possible fonts with Pfont.list()
  fontSize = 80;
  fontNames = new String[]{
    
    "Courier New Bold",
    "Broadway",
    "Lucida Console",
    "Rockwell",
    "Consolas",
    "Comic Sans MS Bold" // best font
    
  };
  
  maxFonts = fontNames.length;
  
  // create fonts from fontNames list
  // add the fontname to fontNames to add a font
  fonts = new EFont[maxFonts];
  for (int i = 0; i < maxFonts; i++){
    
    // create an EFont and save it in the fonts[] array
    String currentFontName = fontNames[i];
    fonts[i] = new EFont(currentFontName, fontSize);
    
    
  }
  
  // position in the fonts[] array
  fontCounter = 0;
  
  // how many frames between allowing the darkmode/lightmode switch
  // 15 at 30 fps -> half a second
  fontCooldownMax = 15;
  
  showTimer = false;
  showDate = true;
  showRGBValues = true;
    
  // horizontal spacing between hours and minutes and seconds
  // can be changed with +-.,
  spacing = 3;
  
  // light mode by default
  // please dont hate me
  mode = "light";
  
  // load the timer icons
  timerIconBlack = loadImage("timerBlack.png");
  timerIconWhite = loadImage("timerWhite.png");
  
  // set the current font to the first font in fonts[]
  textFont(fonts[0].getFont());
  
  // load previous session if it exists
  // overrides default settings
  loadSessionData();
  
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
  
  if (key == 'a') showRGBValues = !showRGBValues;  // toggle show RGB values
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
  
  // start the timer
  if(key == 't' || key == 'T'){
    
    // switch between showing and hiding the timer
    showTimer = !showTimer;
    
    if (showTimer) timer = new Timer();
    else           timer = null;
    
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
    
    float secondStringLength = textWidth(seconds);
    textAlign(RIGHT);
    
    String day   = str(day());
    String month = str(month());
    String year  = str(year());
    
    if(day.length() == 1) day = "0" + day;
    if(month.length() == 1) month = "0" + month;
    
    String dateString = day + "." + month + "." + year;
    
    textSize(fontSize/1.9);
    text(dateString, ((width / 2) + segment + secondStringLength/2) + xAdjust, (height/2 + fontSize) + yAdjust);
    
  }
  
  // RGB Values
  if(showRGBValues){
    
    textSize(fontSize);
    float hourStringLength = textWidth(hours);
    
    textSize(fontSize/1.9);
    float spaceStringLength = textWidth(" ");
    textAlign(LEFT);
    
    String sRed   = str(int(red));
    String sBlue  = str(int(blue));
    String sGreen = str(int(green));
    
    while(sRed.length()   < 3) sRed = "0" + sRed;
    while(sBlue.length()  < 3) sBlue = "0" + sBlue;
    while(sGreen.length() < 3) sGreen = "0" + sGreen;
    
    float   sRedLength = textWidth(sRed);
    float  sBlueLength = textWidth(sBlue);
    float sGreenLength = textWidth(sGreen);
    
    fill(red, 0, 0);
    text(sRed,   ((width / 2) - segment - hourStringLength/2) + xAdjust, (height/2 + fontSize) + yAdjust);
    
    fill(0, green, 0);
    text(sGreen, ((width / 2) - segment - hourStringLength/2) + xAdjust + sRedLength, (height/2 + fontSize) + yAdjust);
    
    fill(0, 0, blue);
    text(sBlue,  ((width / 2) - segment - hourStringLength/2) + xAdjust + sRedLength + sBlueLength, (height/2 + fontSize) + yAdjust);
    
  }
  
  if(showTimer){
    
    fill(240, 70);

    textSize(fontSize/2);  // assuming half of the original font size for start time and passed time
    textAlign(LEFT, TOP);  // align to the top-left corner
    
    String startTime = timer.getStartTime();
    String passedTime = timer.getPassedTime();
    
    float  startTimeLength = textWidth(startTime);
    float passedTimeLength = textWidth(passedTime);
    
    text(startTime, ((width / 2) - segment - startTimeLength/4) + xAdjust, (height/2 - fontSize) + yAdjust);  // Positioning above the start time
    
    fill(250);
    
    textAlign(RIGHT, TOP);
    text(passedTime, ((width / 2) + segment + passedTimeLength/4) + xAdjust, (height/2 - fontSize) + yAdjust);  // Positioning above the passed time
    
    // draw a white border
    fill(240, 70);
    stroke(0, 0);
    float borderSize = (width + height) / 75.;
    
    rect(0, 0, width, borderSize);      // top border
    rect(width - borderSize, borderSize, borderSize, height - borderSize);      // right border
    rect(borderSize, height - borderSize, width - borderSize * 2, borderSize);      // bottom border
    rect(0, borderSize, borderSize, height - borderSize);      // left border 
    
    // show a timer icon
    // icon by aepul Nahwan
    // https://www.flaticon.com/free-icon/timer_10994506
    float iconSize = fontSize / 1.9;
    
    image(timerIconWhite, (width/2 - iconSize / 2) + xAdjust, (height/2 - fontSize) + yAdjust, iconSize, iconSize);
    
  }
  
}

void surfaceResized() {
  saveSessionData();
}

public void saveSessionData(){
  
  String[] dataToSave = new String[10];
  
  dataToSave[0] = str(fontCounter);
  dataToSave[1] = str(fontSize);
  dataToSave[2] = str(spacing);
  dataToSave[3] = mode;
  dataToSave[4] = str(width);
  dataToSave[5] = str(height);
  dataToSave[6] = str(xAdjust);
  dataToSave[7] = str(yAdjust);
  dataToSave[8] = str(showDate);
  dataToSave[9] = str(showRGBValues);
  
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
    
    showDate = boolean(loadedData[8]);
    showRGBValues = boolean(loadedData[9]);
    
    fonts[fontCounter].setSize(fontSize);
    surface.setSize(new_width, new_height);
    
    print("l+");
    
    return true;
      
  } else {
    
    print("l-");
    
    return false;
    
  }
    
}
