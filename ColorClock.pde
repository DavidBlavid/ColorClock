String hours, minutes, seconds;
float red, green, blue;

int fontCounter;      // current position in fonts array
int maxFonts;         // max number of fonts
int fontCooldown;     // frametimer for font change cooldown
int fontCooldownMax;  // length of cooldown
EFont[] fonts;        // contains all fonts
String[] fontNames;   // names of fonts, is used to build fonts[]

float spacing;        // spacing between the characters HH : MM : SS
int fontSize;         // size of font
float xAdjust;        // adjust x position
float yAdjust;        // adjust y position

String mode;


void setup(){
 
  size(600, 200);
  
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
  
  // set to the number of fonts
  maxFonts = 5;
  fontCounter = 0;
  fontCooldownMax = 15;
  
  
  // horizontal spacing between hours and minutes and seconds
  // can be changed with +-.,
  spacing = 3;
  
  mode = "light";
  
  // load previous session if it exists
  loadSessionData();
  
  textFont(fonts[0].getFont());
  textAlign(CENTER, CENTER);
  
  //printArray(PFont.list());
  
}

void keyPressed(){
  
  if(key == ' '){
    
    fontCounter++;
    
    if(fontCounter == maxFonts){
     
      fontCounter = 0;
      
    }
    
    fonts[fontCounter].setSize(fontSize);
    saveSessionData();
  }
  
  if (key == '-') {
    spacing /= 1.2;
    saveSessionData();
  }
  if (key == '+') {
    spacing *= 1.2;
    saveSessionData();
  }
  if (key == '.') {
    spacing /= 1.03;
    saveSessionData();
  }
  if (key == ',') {
    spacing *= 1.03;
    saveSessionData();
  }
  
  
  if (key == 'w') {
    if(fontSize <= 500) fontSize += 2;
    fonts[fontCounter].setSize(fontSize);
    saveSessionData();
  };
    
    if (key == 's') {
    if(fontSize >= 3) fontSize -= 2;
    fonts[fontCounter].setSize(fontSize);
    saveSessionData();
  };
  
  
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
     fill(red * 1.2, green * 1.5, blue * 1.2);
     
   }
  
  text(  hours, (width / 2) - segment * 1, height/2 - 10);
  text(    ":", (width / 2) - segment * 1/2, height/2 - 15);
  text(minutes, (width / 2)              , height/2 - 10);
  text(    ":", (width / 2) + segment * 1/2, height/2 - 15);
  text(seconds, (width / 2) + segment * 1, height/2 - 10);
  
}

public void saveSessionData(){
  
  String[] dataToSave = new String[5];
  dataToSave[0] = str(fontCounter);
  dataToSave[1] = str(fontSize);
  dataToSave[2] = str(spacing);
  dataToSave[3] = mode;
  saveStrings("userSettings.txt", dataToSave);
  
  print("s");
  
}

public boolean loadSessionData(){
  
  String path = sketchPath() + "/userSettings.txt";
   
  if (new File(path).exists()) {
    String[] loadedData = loadStrings("userSettings.txt");
    fontCounter = int(loadedData[0]);
    fontSize = int(loadedData[1]);
    spacing = float(loadedData[2]);
    mode = loadedData[3];
    
    fonts[fontCounter].setSize(fontSize);
    
    print("l+");
    
    return true;
      
  } else {
    
    print("l-");
    
    return false;
    
  }
    
}
