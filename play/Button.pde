class Button{
  private int m_width;
  private int m_height;
  private int m_x;
  private int m_y;
  private float m_alpha;
  private color m_true_color;
  private color m_false_color;
  private color m_accent_color;
  private PImage m_true_icon;
  private PImage m_false_icon;
  private Boolean m_state;

  // konstruktor
  Button (int x, int y, int p_width, int p_height, PImage p_true, PImage p_false){
    m_x = x;
    m_y = y;
    m_width = p_width;
    m_height = p_height;
    m_alpha = 0.75;
    //m_color = #E8E288;
    m_true_color = color(0,237,0);
    m_false_color = #E8E288;
    m_accent_color = #FF00FF;
    m_true_icon = p_true;
    m_false_icon = p_false;
    m_state = true;
  }

  // prikaže gumb u trenutnom stanju
  public void Display(Boolean accent, Boolean state){
    ellipseMode(CENTER);
    int alpha = int(m_alpha * 255);
    if (accent){
      fill(m_accent_color, alpha);
    } else {
      if (state){
        fill(m_true_color, alpha);
      } else {
        fill(m_false_color, alpha);
      }
    }
    stroke(black);
    ellipse(m_x, m_y, m_width, m_height);

    imageMode(CENTER);
    if (state){
      image(m_true_icon, m_x, m_y, m_width, m_height);
    } else {
      image(m_false_icon, m_x, m_y, m_width, m_height);
    }
    // vraćamo na default vrijednost
    imageMode(CORNER);
  }

  public boolean MouseOverItem(){
    if(mouseX < (m_x + m_width / 2) &&
      mouseX > (m_x - m_width / 2) &&
      mouseY < (m_y + m_height / 2) &&
      mouseY > (m_y - m_height / 2)
        )
      return true;
    else
      return false;
  }
}
