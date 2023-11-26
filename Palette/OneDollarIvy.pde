import fr.dgac.ivy.*;

public class OneDollarIvy{
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
  String confidence;
  Boolean received =false;
  
  void setup(){
  f = loadFont("TwCenMT-Regular-24.vlw");
  state = INIT;
  
  textFont(f,18);
  try
  {
    bus = new Ivy("sra_tts_bridge2", " sra_tts_bridge2 is ready", null);
    bus.start("127.255.255.255:2010");
    
    bus.bindMsg("^OneDolarIvy Template=(.*) Confidence=(.*)", new IvyMessageListener()
    {
      public void receive(IvyClient client,String[] args)
      {
        message = "Vous avez dessiné un " + args[0] ;
        forme=args[0];
        confidence=args[1];
        state = TEXTE;
        received=true;
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
      message = "Bonjour, que souhaitez vous dessiner?";
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
          bus.sendMsg("ppilot5 Say= dollar ivy" + message);
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
