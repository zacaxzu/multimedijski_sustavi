
class Menu{
  // lista itema (string)
  private ArrayList<String> m_items = new ArrayList<String>();
  private ArrayList<Button> m_buttons = new ArrayList<Button>();
  // lista koja sadrži središta svih itema (za njihovo crtanje na ekran)
  // menu itemi se crtaju na temelju lokacije središta, širine i visine
  private IntList m_centers;
  // ostale varijable članice
  private int m_spacing = 0;
  private int m_itemHeight = 0;
  private int m_itemWidth = 0;
  private int m_textSize;
  private color m_itemColor;
  private color m_itemAccentColor;
  private color m_textColor;
  private color m_textAccentColor;
  private PImage m_background = null;
  private PFont m_menuFont;

  // konstruktor
  Menu(int textSize){
    m_textSize = textSize;
    // defaultne boje, mogu se promijeniti setterima
    m_itemColor = #FF00FF;
    m_itemAccentColor = #1FE3F4;
    m_textColor = color(255,255,255);
    m_textAccentColor = color(0,0,0);
    // postavljanje fonta
    m_menuFont = createFont("PressStart2P.ttf", m_textSize, true);
    textFont(m_menuFont);
    textSize(m_textSize);
    m_itemHeight = int(textAscent() + textDescent());
    m_itemHeight *= 2.5;
    m_spacing = m_itemHeight / 2;
  }
  // konstruktor koji prima PImage background
  Menu(int textSize, PImage bg){
    this(textSize);
    m_background = bg;
  }
  // nakon svakog umetanja itema, ažurira listu središta menu itema
  private void UpdateCenters(){
    int topBegin = m_items.size() * m_itemHeight + (m_items.size() - 1) * m_spacing;
    topBegin = (height - topBegin) / 2 + (m_itemHeight / 2);
    m_centers = new IntList();
    for(int i = 0; i < m_items.size(); ++i){
      m_centers.append(topBegin);
      topBegin += (m_spacing + m_itemHeight);
    }
  }

  public void AddButton(Button button){
    m_buttons.add(button);
  }

  // menu item get/set
  public void AddMenuItem(String item){
    m_items.add(item);
    UpdateCenters();
    // ažuriranje širine menu itema
    textFont(m_menuFont);
    textSize(m_textSize);
    if (textWidth(item) > m_itemWidth){
      m_itemWidth = int(textWidth(item) + 4 * textWidth('c'));
    }
  }
  public String GetMenuItem(int i){
    return m_items.get(i);
  }

  // iscrtava i-ti item
  void DrawMenuItem(int i, color bgColor, color textColor){
    if (i <= m_items.size()){
      rectMode(CENTER);
      stroke(black);
      textAlign(CENTER, CENTER);
      textFont(m_menuFont);
      textSize(m_textSize);
      fill(bgColor);
      rect(width / 2, m_centers.get(i), m_itemWidth, m_itemHeight,3,12,3,12);
      fill(textColor);
      text(m_items.get(i), width / 2, m_centers.get(i));
      rectMode(CORNER);
    }
    else
      println("DrawMenuItem: index " + i + " out of range: ");
  }

  // vraća indeks kliknutog itema ili -1 ako nijedan nije kliknut
  //BUG oprez: ovo je hardkodirano za samo jedan gumb na 0-om indeksu
  // ovdje dodati podršku za registriranje klika na nove gumbove
  public int SelectedItem(){
    for (int i = 0; i < m_items.size(); ++i){
      if (MouseOverItem(i))
        return i;
    }
    // dodajemo specifičan kod: -5 za klik na Mute gumb
    if (m_buttons.get(0).MouseOverItem())
      return -5;
    return -1;
  }

  // nalazi li se kursor iznad i-tog itema
  public boolean MouseOverItem(int i){
    if(mouseX < (width / 2) + (m_itemWidth / 2) &&
      mouseX > (width / 2) - (m_itemWidth / 2) &&
      mouseY < (m_centers.get(i) + m_itemHeight / 2) &&
      mouseY > (m_centers.get(i) - m_itemHeight / 2)
        )
      return true;
    else
      return false;
  }

  // item height getter
  public int GetItemHeight(){
    return m_itemHeight;
  }

  // color get/set
  public color itemColor(){
    return m_itemColor;
  }
  public void SetItemColor(color value){
    m_itemColor = value;
  }
  public color itemAccentColor(){
    return m_itemAccentColor;
  }
  public void SetItemAccentColor(color value){
    m_itemAccentColor = value;
  }
  public color textColor(){
    return m_textColor;
  }
  public void SetTextColor(color value){
    m_textColor = value;
  }
  public color textAccentColor(){
    return m_textAccentColor;
  }
  public void SetTextAccentColor(color value){
    m_textAccentColor = value;
  }

  // prikazuje meni sa svim stavkama
  void Display(){
    if (m_background == null){ //bilo je m_background != null, no onda se ne može pokrenut
      background(m_background);
    }
    for (int i = 0; i < m_items.size(); ++i){
      if (MouseOverItem(i))
        DrawMenuItem(i, m_itemAccentColor, m_textAccentColor);
      else
        DrawMenuItem(i, m_itemColor, m_textColor);
    }
    // sound icon
    // BUG pripaziti ako odlučimo dodati više gumbova da se prikažu ovdje
    Boolean selected = false;
    if (m_buttons.get(0).MouseOverItem())
      selected = true;
    // Display(boolean accent, boolean state)
    m_buttons.get(0).Display(selected, isSoundOn);
  }
}
