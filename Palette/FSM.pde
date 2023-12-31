/*
 * Enumération de a Machine à Etats (Finite State Machine)
 *
 *
 */
 
public enum FSM {
  INITIAL, /* Etat Initial */ 
  AFFICHER_FORMES, 
  DEPLACER_FORMES_SELECTION,
  DEPLACER_FORMES_DESTINATION,
  DELAY,
  ATTENTE,
  TRAITEMENT_PAROLE,
  TRAITEMENT_DESSIN,
  ATTENTE_COMPLEMENT_PAROLE,
  MIX_DESSIN_VOC,
  ATTENTE_LOCALISATION,
  CREATION,
  VOC_CREATE,
  VOC_MOVE,
  VOC_CREATE_LOC,
  ATTENTE_COMPLEMENT_CREATE,
  MIX_VOC_DESSIN,
  MIX_VOC_CLICK,
  DOUZE,
  TREIZE,
  SUPPRIMER
}
