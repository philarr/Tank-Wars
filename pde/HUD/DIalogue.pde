//Small class to describe Dialogue (the time it is to be shown, author, the text)
class Dialogue {
  int timer;
  String author;
  String text;
  Boolean sticky = false;

  Dialogue(int t, String a, String text) {
    this.timer = t;
    this.author = a;
    this.text = text;
  }

  Dialogue(int t, String a, String text, Boolean sticky) {
    this.timer = t;
    this.author = a;
    this.text = text;
    this.sticky = true;
  }
}
