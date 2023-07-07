class EFont{
  
  private PFont _font;
  private String _name;
  private int _size;
  
  public EFont(String name, int size){
    
    _name = name;
    _size = size;
    
    refresh();
    
    
  }
  
  public PFont getFont(){
    
    return _font;
    
  }
  
  public String getFontName(){
    
    return _name;
    
  }
  
  public int getSize(){
    
    return _size;
    
  }
  
  public void setFont(PFont font){
    
    _font = font;
    refresh();
    
  }
  
  public void setFontName(String name){
    
    _name = name;
    refresh();
    
  }
  
  public void setSize(int size){
    
    _size = size;
    refresh();
    
  }
  
  public void refresh(){
    
    _font = createFont(_name, _size);
    
  }
  
}
