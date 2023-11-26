import fr.dgac.ivy.*;

public class Recoparole{
  Ivy bus;
  PFont f;
  String message= "";
  
  int state;
  public static final int INIT = 0;
  public static final int ATTENTE = 1;
  public static final int TEXTE = 2;
  public static final int CONCEPT = 3;
  public static final int NON_RECONNU = 4;
  String forme;
  String action;
  String where;
  String couleur;
  String localisation;
  String confidence;
  Boolean received = false;
  Boolean hearing= false;
  
  void setup(){
  f = loadFont("TwCenMT-Regular-24.vlw");
  state = INIT;
  
  textFont(f,18);
  try
  {
    bus = new Ivy("sra_tts_bridge", " sra_tts_bridge is ready", null);
    bus.start("127.255.255.255:2010");
    

    bus.bindMsg("^sra5 Parsed=action=(.*) where=(.*) form=(.*) color=(.*) localisation=(.*) Confidence=(.*) NP=.*", new IvyMessageListener()
    {
      public void receive(IvyClient client,String[] args)
      {
        
        if(hearing == true){
           received=true;
           message = "Vous souhaitez " + args[0] + " un " + args[1];
          action=args[0];
          where=args[1];
          forme=args[2];
          couleur=args[3];
          localisation=args[4];
          confidence=args[5];
          state = TEXTE;
          hearing=false;
        }
         
      }        
    });
    

    bus.bindMsg("^sra5 Event=Speech_Rejected", new IvyMessageListener()
    {
      public void receive(IvyClient client,String[] args)
      {
        message = "Malheureusement, je ne vous ai pas compris.";
        state = NON_RECONNU;
      }        
    });    
  }
  catch (IvyException ie)
  {
  }
}

void draw(){
  switch(state) {
    case INIT:
      message = "Bonjour, que souhaitez vous dessiner  ?";
      try {
          bus.sendMsg("ppilot5 Say=" + message); 
      }
      catch (IvyException e) {}
      state = ATTENTE;
      break;
      
    case ATTENTE:
      // cas normal ...
      break;
      
    case TEXTE :
      try {
          bus.sendMsg("ppilot5 Say=" + message); 
      }
      catch (IvyException e) {}
      state = ATTENTE;
      break;
      
     case CONCEPT:
       // Donne les elements prononce et le taux de confiance lors de la reco
       try {
          bus.sendMsg("ppilot5 Say=" + message);
          print(message);
       }
       catch (IvyException e) {}
       state = ATTENTE;
       break; 
       
     case NON_RECONNU:
       // la commande n'est pas reconnue
       state = ATTENTE;
       try {
          bus.sendMsg("ppilot5 Say=" + message); 
       }
       catch (IvyException e) {}
       state = ATTENTE;
       break;
  }
  
  text("** ETAT COURANT **", 20,20);
  text(state, 20, 50);
  }
 
void nettoyer(){
  state = ATTENTE;
  received=false;
 
}
  
  
}
