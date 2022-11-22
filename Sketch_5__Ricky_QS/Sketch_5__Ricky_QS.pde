import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddressList IPaddressList = new NetAddressList();

int myListeningPort = 8000;
int myBroadcastPort = 9000;

String myMessageTag = "/person1";
int myPositionX;
int myPositionY;

String yourMessageTag = "/person2";
String yourIPaddress = "192.168.1.4";
int yourPositionX;
int yourPositionY;


String arduinoIP = "192.168.1.20";
int CatSiren; 
int CatSirendos; 


void preload() {
CatSiren = loadImage('CatSiren.png');
CatSirendos = loadImage('CatSirendos.jpg');
}
void setup()
{
 size(1280,640); 
  
 oscP5 = new OscP5(this, myListeningPort); 
  
 //add the IP of the devices you want to send to
 //use the command multiple times for multiple IP addresses
 //*****UPDATE THIS WITH YOUR IP ADDRESSES
 connect(yourIPaddress);
  connect(arduinoIP); 
  
}
void draw()
{
 background(255);
 fill(255,0,0);
 
 image (CatSiren, 20, 40);
 image (CatSiren, 60, 80);
 
 ///Draw my circle
 int myPositionX = mouseX;
 int myPositionY = mouseY;
 
 ellipse(myPositionX,myPositionY,20,20);
 
 ///send the data to everyone
 //create the message object with the appropriate tag
 OscMessage mPosition = new OscMessage(myMessageTag);
 //add the data to it
 mPosition.add(myPositionX);
 mPosition.add(myPositionY);
 //send the message to all the IP addresses
 oscP5.send(mPosition,IPaddressList);
 
 
///draw your circle
fill(0,255,0);
ellipse(yourPositionX,yourPositionY,20,20);
  
  
  
  
  
}

void oscEvent(OscMessage incomingMessage) 
  {
    println(incomingMessage);
    if(incomingMessage.checkAddrPattern(yourMessageTag)==true) 
    {
      yourPositionX = incomingMessage.get(0).intValue();
      yourPositionY = incomingMessage.get(1).intValue();
    }
    
    
  }



void connect(String theIPaddress) {
     if (!IPaddressList.contains(theIPaddress, myBroadcastPort)) {
       IPaddressList.add(new NetAddress(theIPaddress, myBroadcastPort));
       println("### adding "+theIPaddress+" to the list.");
     } else {
       println("### "+theIPaddress+" is already connected.");
     }
     println("### currently there are "+IPaddressList.list().size()+" remote locations connected.");
 }
