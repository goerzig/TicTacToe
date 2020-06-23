/*import hypermedia.net.*;

UDP udp;
final int port= 9100;
final String ip= "localhost";


void initBCIListenForClassifier() {
  udp = new UDP(this, port);
  //udp.log( true );
  udp.listen( true );
}


// void receive(byte[] data) {       // <-- default handler
void receive(byte[] data, String ip, int port)
{
  String message = new String( data );
  // print the result
  println("received: \"" + message + "\" from " + ip + " on port " + port);
  
  int selectedClass= int(message)-1;
  if (status==PLAY_LEVEL) {
    gameBCIButtonTab.check(selectedClass);
    println("Check: " + selectedClass);
  }
}*/
