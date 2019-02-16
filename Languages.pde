/**
 * Define the language to use in the text components of the sketch.
 *
 * Anthony Brown Feb 2019
 */

enum Languages {
  EN("English") {
    public String[] getText() {
      return new String[]{"Apparent position of the closer star", "with respect to the distant stars", "Distance: ", " lightyear", "Parallax: ", " arcsecond"};
    }
  },
  NL("Nederlands"){
    public String[] getText() {
      return new String[]{"Schijnbare positie van de nabije ster ten", "opzichte van de verderweg staande sterren", "Afstand: ", " lichtjaar", "Parallax: ", " boogseconde"};
    }
  },
  FR("Francais"){
    public String[] getText() {
      return new String[]{"Position apparente de l'étoile la plus proche", "par rapport aux étoiles lointaines", "Distance: ", " année-lumière", "Parallaxe: ", " seconde d'arc"};
    }
  },;
  
  /* Human redeable description of enum */
  private String description;
  
  /**
   * Constructor.
   */
  private Languages(String desc) {
    description=desc;
  }
  
  public String toString() {
    return description;
  }
  
  /**
   * Returns the list of strings to be used as the sketch text."
   */
  public abstract String[] getText();
  
}
