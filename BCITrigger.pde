import hypermedia.net.*;

class BCITrigger
{
  UDP udp;
  int port;
  String host;
  
  BCITrigger(String _host, int _port)
  {
    host= _host;
    port= _port;
    udp= new UDP(this);
//    udp.log( true );
  }

  BCITrigger()
  {
    this("localhost", 1206);
  }


  void send(int value)
  {
    String msg= "S" + nf(value,3);
    udp.send(msg, host, port);
//    print(nf(floor(millis()/1000),5) + "." + nf(millis()%1000,3));
//    println(": Marker '" + msg + "' send to host " + host + " on port " + port);
  }

}
