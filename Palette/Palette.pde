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

public  final color RED = color(255,0,0);
public  final color ORANGE = color(255,180,0);
public  final color YELLOW = color(255,255,0);
public  final color GREEN = color(0,255,0);
public  final color BLUE = color(0,0,255);
public  final color PURPLE = color(255,0,255);
public final color DARK = color(255,255,255);

void setup() { 
  reco_parole.setup();
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
  background(0);
  //println("MAE : " + mae + " indice forme active ; " + indice_forme);
  Point p = new Point(mouseX,mouseY);
  switch (mae) {
    case INITIAL:  // Etat INITIAL
      background(255);
      fill(0);
      text("Etat initial (c(ercle)/l(osange)/r(ectangle)/t(riangle) pour créer la forme à la position courante)", 50,50);
      text("m(ove)+ click pour sélectionner un objet et click pour sa nouvelle position", 50,80);
      text("click sur un objet pour changer sa couleur de manière aléatoire", 50,110);
      break;
      
    case AFFICHER_FORMES:  // 
    case DEPLACER_FORMES_SELECTION: 
      for (int i=0;i<formes.size();i++) { // we're trying every object in the list        
          if ((formes.get(i)).isClicked(p)) {
            indice_forme = i;
            mae = FSM.DEPLACER_FORMES_DESTINATION;
          }         
       }
       if (indice_forme == -1)
         mae= FSM.AFFICHER_FORMES;
       break;
    case DEPLACER_FORMES_DESTINATION: 
      affiche();
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
  Point p = new Point(mouseX,mouseY);
  
  switch (mae) {
    case AFFICHER_FORMES:
      for (int i=0;i<formes.size();i++) { // we're trying every object in the list
        // println((formes.get(i)).isClicked(p));
        if ((formes.get(i)).isClicked(p)) {
          (formes.get(i)).setColor(color(random(0,255),random(0,255),random(0,255)));
        }
      } 
      break;
      
   case DEPLACER_FORMES_SELECTION:
     
     
   case DEPLACER_FORMES_DESTINATION:
     if (indice_forme !=-1)
       (formes.get(indice_forme)).setLocation(new Point(mouseX,mouseY));
     indice_forme=-1;
     mae=FSM.AFFICHER_FORMES;
     break;
     
    default:
      break;
  }
}

void keyReleased() {
  Point p = new Point(mouseX,mouseY);
  if (key==' '){
    println(reco_parole.action);
    switch(reco_parole.action){ // we look at the action, CREATE, MOVE, ...       
      case "CREATE":
        addingShape(p); // function to add the shape with the specified color
        println("Creating a shape");
        break;
          
      case "MOVE": // we move a shape
         mae = FSM.DEPLACER_FORMES_SELECTION;
         println("Moving an object");
         break;
           
       default:
         println("no action reconized");
         break;
    }
  }
}

void addingShape(Point p){
  //switch forme
  switch(reco_parole.forme) { // Draw shapes 
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
    println("no shape reconized");
      break;
  }
  
  if (formes.isEmpty()) return;
  
  //switch color
  switch(reco_parole.couleur) { // adding color
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
      (formes.get(formes.size()-1)).setColor(DARK);
      break;
    }
}
