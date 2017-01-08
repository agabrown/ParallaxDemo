/**
 * Implement a simple horizontal scrollbar. Code adapted from the Scrollbar sketch in the GUI examples
 * included with the processing PDE.
 *
 * The code is setup to implement a horizontal scroll-bar with a slider inside.
 *
 * Anthony Brown Jan 2017
 */

class HorizontalScrollBar {
  int scrollBarWidth, scrollBarHeight;    // width and height of bar
  int sliderWidth, sliderHeight; // Width and height of slider
  float xPositionBar, yPositionBar;       // x and y position of bar
  float sliderPosition, newSliderPosition;    // x position of slider
  float sliderPositionMinimum, sliderPositionMaximum; // max and min values of slider
  boolean over;           // is the mouse over the slider?
  boolean locked;
  float sliderPositionNormalization;

  /**
   * Constructor.
   *
   * @param xp
   *   X-position of scroll-bar.
   * @param yp
   *   Y-position of scroll-bar.
   * @param sw
   *   Width of scroll-bar.
   * @param sh
   *   Height of scroll-bar.
   */
  HorizontalScrollBar (float xp, float yp, int sw, int sh) {
    scrollBarWidth = sw;
    scrollBarHeight = sh;
    sliderWidth = scrollBarHeight;
    sliderHeight = scrollBarHeight;
    sliderPositionNormalization = 1.0 / (float) (scrollBarWidth - sliderWidth);
    xPositionBar = xp;
    yPositionBar = yp-scrollBarHeight/2;
    sliderPosition = xPositionBar;
    newSliderPosition = sliderPosition;
    sliderPositionMinimum = sliderPosition;
    sliderPositionMaximum = xPositionBar + scrollBarWidth - scrollBarHeight;
  }

  /**
   * Update the status of the scroll-bar.
   */
  void update() {
    if (overEvent()) {
      over = true;
    } else {
      over = false;
    }
    if (mousePressed && over) {
      locked = true;
    }
    if (!mousePressed) {
      locked = false;
    }
    if (locked) {
      newSliderPosition = constrain(mouseX, sliderPositionMinimum, sliderPositionMaximum);
    }
    if (abs(newSliderPosition - sliderPosition) > 1) {
      sliderPosition = sliderPosition + (newSliderPosition-sliderPosition);
    }
  }

  /**
   * Constrain a value between an upper and lower limit.
   *
   * @param val
   *   Input value.
   * @param minv
   *   Minimum allowed value.
   * @param maxv
   *   Maximum allowed value.
   */
  float constrain(float val, float minv, float maxv) {
    return min(max(val, minv), maxv);
  }

  /**
   * Check if mouse is over SCROLLBAR (not the slider).
   */
  boolean overEvent() {
    if (mouseX > xPositionBar && mouseX < xPositionBar+scrollBarWidth &&
       mouseY > yPositionBar && mouseY < yPositionBar+scrollBarHeight) {
      return true;
    } else {
      return false;
    }
  }

  /**
   * Display the scrollbar and slider.
   */
  void display() {
    noStroke();
    fill(204);
    rect(xPositionBar, yPositionBar, scrollBarWidth, scrollBarHeight);
    if (over || locked) {
      fill(#4477AA);
    } else {
      fill(102, 102, 102);
    }
    rect(sliderPosition, yPositionBar, scrollBarHeight, scrollBarHeight);
  }

  /**
   * Get the normalized position of the slider within the scrollbar.
   * A position 0 means the slider is on the left while 1 means the slider
   * is on the right.
   */
  float getPos() {
    return (sliderPosition-xPositionBar) * sliderPositionNormalization;
  }
}