/*
 * Palette Graphique - prélude au projet multimodal 3A SRI
 * 4 objets gérés : cercle, rectangle(carré), losange et triangle
 * (c) 05/11/2019
 * Dernière révision : 28/04/2020
 */
 
import java.awt.Point;

ArrayList<Forme> formes; // liste de formes stockées
FSM mae; // Finite Sate Machine
int indice_forme;
int Nb_forme;
PImage sketch_icon;

Recoparole reco_parole = new Recoparole();
OneDollarIvy one_dollar = new OneDollarIvy();

public  final color RED = color(255,0,0);
  public  final color ORANGE = color(255,180,0);
  public  final color YELLOW = color(255,255,0);
  public  final color GREEN = color(0,255,0);
  public  final color BLUE = color(0,0,255);
  public  final color PURPLE = color(255,0,255);
  public final color DARK = color(255,255,255);
  public final float seuil = 0.85;
  
  public String forme_current= null;
  public Point p = new Point(0,0);
  public Point loc_point = new Point(0,0);
  public Boolean loc_selected = false;
  public Boolean forme_selected=false;
void setup() { 
  reco_parole.setup();
  one_dollar.setup();
  size(800,600);
  surface.setResizable(true);
  surface.setTitle("Palette multimodale");
  surface.setLocation(20,20);
  sketch_icon = loadImage("Palette.jpg");
  surface.setIcon(sketch_icon);
  
  
  formes= new ArrayList(); // nous créons une liste vide
  noStroke();
  mae = FSM.INITIAL;
  indice_forme = -1;
  Nb_forme = -1;
}

void draw() {
 
  
  
  reco_parole.draw();
  one_dollar.draw();
  switch (mae) {
    case INITIAL:  // Etat INITIAL
      background(255);
      fill(0);
      text("Etat initial appuyer sur T pour commencer la reconnaisance vocale)", 50,50);
      text("m(ove)+ click pour sélectionner un objet et click pour sa nouvelle position", 50,80);
      text("click sur un objet pour changer sa couleur de manière aléatoire", 50,110);
      break;
      
    case AFFICHER_FORMES: 
     //println(mae);
      affiche();
      one_dollar.nettoyer();
      reco_parole.nettoyer();
      loc_selected=false;
      forme_selected=false;
      // mae = FSM.ATTENTE;
      break;
      
    case ATTENTE:
      if(reco_parole.received){ //<>//
        mae=FSM.TRAITEMENT_PAROLE;
      }
      if(one_dollar.received){
        mae=FSM.TRAITEMENT_DESSIN;
      }
      // println(mae);
      break;
      
      
     case TRAITEMENT_PAROLE:
       println(reco_parole.action);
       if(reco_parole.action.equals("undefined")){
         mae=FSM.AFFICHER_FORMES;
         one_dollar.nettoyer();
         reco_parole.nettoyer();
       }
       else{
         if(reco_parole.action.equals("CREATE")){
           // print("go create");
           mae=FSM.VOC_CREATE;
         }
         else{
           if(reco_parole.action.equals("MOVE")){
           mae=FSM.VOC_MOVE;
           }
           else if(reco_parole.action.equals("DELETE")){
           mae=FSM.SUPPRIMER;
           }
           else{
            mae=FSM.AFFICHER_FORMES;
            one_dollar.nettoyer();
            reco_parole.nettoyer();
            loc_selected=false;
            forme_selected=false;
           }
         }
       }
       break;
        
        
        
       case VOC_CREATE:
        if(reco_parole.forme.equals("undefined") && reco_parole.where.equals("THIS") ){
         mae=FSM.ATTENTE_COMPLEMENT_CREATE;
       }
       else{
         forme_current=reco_parole.forme;
         mae=FSM.VOC_CREATE_LOC;
       }
       break;
       
       
       
       case VOC_MOVE:
         println(mae);
         
         mae = FSM.DEPLACER_FORMES_SELECTION;
       break;
       
       // récupère l'indice de la forme survolé par la souris
       case DEPLACER_FORMES_SELECTION:
         println(mae);
         p = new Point(mouseX, mouseY);
         // println(p);
         for (int i=0;i<formes.size();i++) { // we're trying every object in the list        
           if ((formes.get(i)).isClicked(p)) {
             indice_forme = i;
             mae = FSM.DELAY;
           }
         }         
        break;
       
       case DELAY:
         println(mae);
         delay(2000);
         mae = FSM.DEPLACER_FORMES_DESTINATION;
         break;
         
       case DEPLACER_FORMES_DESTINATION: 
         // println(mae);
         p = new Point(mouseX, mouseY);
         // println(p);
         if (indice_forme !=-1){
           (formes.get(indice_forme)).setLocation(p);
         }
         indice_forme=-1;
         mae=FSM.AFFICHER_FORMES;
         
        break; 
        
        
        // récupère l'indice de la forme survolé par la souris
        case SUPPRIMER:
         p = new Point(mouseX, mouseY);
         for (int i=0;i<formes.size();i++) { // we're trying every object in the list        
           if ((formes.get(i)).isClicked(p)) {
             indice_forme = i;
             mae = FSM.AFFICHER_FORMES;
           }
         }
         formes.remove(indice_forme);
        break;
        
       
       case VOC_CREATE_LOC:
       if(!reco_parole.localisation.equals("THERE")){
        mae=FSM.AFFICHER_FORMES;
         one_dollar.nettoyer();
         reco_parole.nettoyer();
      }
      else{
        mae=FSM.ATTENTE_LOCALISATION;
      }
     break;
     
     case ATTENTE_COMPLEMENT_CREATE:
      // println(mae);
       if(one_dollar.received){
        mae=FSM.MIX_VOC_DESSIN;
      }
      if(forme_selected){
        mae=FSM.MIX_VOC_CLICK;
      }
     break;
     
     case MIX_VOC_DESSIN:
      // println(mae);
      if(one_dollar.forme.equals("NONE")){
        mae=FSM.AFFICHER_FORMES;
         one_dollar.nettoyer();
         reco_parole.nettoyer();
      }
      else{
         forme_current=one_dollar.forme;
        if(reco_parole.localisation.equals("THERE")){
            mae=FSM.ATTENTE_LOCALISATION;
        }
        else{
            loc_point =new Point((int)(Math.random()*800),(int)Math.random()*600);
           mae=FSM.CREATION;
        }
      }
      break;
     
     case MIX_VOC_CLICK:
      // print(mae);
     if(reco_parole.localisation.equals("THERE")){
            mae=FSM.ATTENTE_LOCALISATION;
     }
     else{
            loc_point =new Point((int)(Math.random()*800),(int)Math.random()*600);
           mae=FSM.CREATION;
        }
     break;
     
     case TRAITEMENT_DESSIN:
          
          if(one_dollar.forme.equals("NONE")){
             mae=FSM.AFFICHER_FORMES;
             one_dollar.nettoyer();
             reco_parole.nettoyer();
          }
          else{
            forme_current=one_dollar.forme;
             mae=FSM.ATTENTE_COMPLEMENT_PAROLE;
            // println(mae);
          }
          break;
          
     case ATTENTE_COMPLEMENT_PAROLE:
       // println(mae);
       if(reco_parole.received){
        mae=FSM.MIX_DESSIN_VOC;
      }
        break;
     
      case MIX_DESSIN_VOC:
      // println(mae);
      if(!reco_parole.where.equals("THIS") || !reco_parole.action.equals("CREATE")){
        mae=FSM.AFFICHER_FORMES;
         one_dollar.nettoyer();
         reco_parole.nettoyer();
      }
      else{
        if(reco_parole.localisation.equals("THERE")){
            mae=FSM.ATTENTE_LOCALISATION;
        }
        else{
            loc_point =new Point((int)(Math.random()*800),(int)Math.random()*600);
           mae=FSM.CREATION;
        }
      }
      break;
      
     case ATTENTE_LOCALISATION:
      // print("click quelque part");
      if(loc_selected){
        mae=FSM.CREATION;
      }
      
      // println(mae);
     break;
     
     case CREATION:
      // println(mae);
     create(loc_point);
     mae=FSM.AFFICHER_FORMES;
     break;
      
          
      
      
    default:
      break;
  }  
}

// fonction d'affichage des formes m
void affiche() {
  background(255);
  /* afficher tous les objets */
  for (int i=0;i<formes.size();i++) // on affiche les objets de la liste
    (formes.get(i)).update();
}

void mousePressed() { // sur l'événement clic
  p = new Point(mouseX,mouseY);
  switch (mae) {
    case AFFICHER_FORMES:
      for (int i=0;i<formes.size();i++) { // we're trying every object in the list
        // println((formes.get(i)).isClicked(p));
        if ((formes.get(i)).isClicked(p)) {
          (formes.get(i)).setColor(color(random(0,255),random(0,255),random(0,255)));
        }
      } 
      break;

    case ATTENTE_LOCALISATION:
         loc_point = new Point(mouseX,mouseY);
         loc_selected=true;
         break;
         
    case ATTENTE_COMPLEMENT_CREATE:
     for (int i=0;i<formes.size();i++) { // we're trying every object in the list
        // println((formes.get(i)).isClicked(p));
        if ((formes.get(i)).isClicked(p)) {
          Forme forme_click=formes.get(i);
          if(forme_click instanceof Rectangle){
            forme_current="RECTANGLE";
          }
          if(forme_click instanceof Cercle){
            forme_current="CIRCLE";
          }
          if(forme_click instanceof Triangle){
            forme_current="TRIANGLE";
          }
          if(forme_click instanceof Losange){
            forme_current="DIAMOND";
          }
          forme_selected=true;
        }
      } 
      break;
    
    default:
      break;
  }
}


void keyPressed() { // sur l'événement clic
  
   if (key=='t'){
     mae=FSM.ATTENTE;
     reco_parole.nettoyer();
     one_dollar.nettoyer();
     reco_parole.hearing=true;
      } 
}

void create(Point p) {
    //switch forme
   switch(forme_current) {
    case "RECTANGLE":
      Forme f= new Rectangle(p);
      formes.add(f);
      mae=FSM.AFFICHER_FORMES;
      Nb_forme=+1;
      break;
      
    case "CIRCLE":
      Forme f2=new Cercle(p);
      formes.add(f2);
      mae=FSM.AFFICHER_FORMES;
      Nb_forme=+1;
      break;
    
    case "TRIANGLE":
      Forme f3=new Triangle(p);
      formes.add(f3);
      mae=FSM.AFFICHER_FORMES;
      Nb_forme=+1;
      break;  
      
    case "DIAMOND":
      Forme f4=new Losange(p);
      formes.add(f4);
      mae=FSM.AFFICHER_FORMES;
      Nb_forme=+1;
      break;    
      
    default:
      break;
    }
    
  //switch color
  switch(reco_parole.couleur) {
    case "RED":
      (formes.get(formes.size()-1)).setColor(RED);
      break;
      
    case "ORANGE":
       (formes.get(formes.size()-1)).setColor(ORANGE);
      break;
    
    case "YELLOW":
       (formes.get(formes.size()-1)).setColor(YELLOW);
      break;
    case "GREEN":
       (formes.get(formes.size()-1)).setColor(GREEN);
      break;   
    case "BLUE":
       (formes.get(formes.size()-1)).setColor(BLUE);
      break;
    case "PURPLE":
       (formes.get(formes.size()-1)).setColor(PURPLE);
      break;
    case "DARK":
       (formes.get(formes.size()-1)).setColor(DARK);
      break;
    default:
      break;
    }
}
