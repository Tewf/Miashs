package fr.uga.miashs.inff3.bataillenavale;

import java.awt.GridLayout;
import javax.swing.BorderFactory;
import javax.swing.JFrame;
import javax.swing.SwingUtilities;

public class BatailleNavale {

    public static void initFenetre(final String titreFenetre, final GrilleGraphique grilleTir, final GrilleGraphique grilleJeu) {
        SwingUtilities.invokeLater(new Runnable() {
            public void run() {
                JFrame fenetre = new JFrame(titreFenetre);
                fenetre.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
                fenetre.getContentPane().setLayout(new GridLayout(1, 2));
                grilleTir.setBorder(BorderFactory.createTitledBorder("Grille de tirs"));
                grilleJeu.setBorder(BorderFactory.createTitledBorder("Grille de jeu"));
                grilleJeu.setClicActive(false);
                fenetre.getContentPane().add(grilleTir);
                fenetre.getContentPane().add(grilleJeu);
                fenetre.pack();
                fenetre.setVisible(true);
            }
        });
    }

    public static JoueurGraphique initJoueur(String nomJoueur) {
        GrilleGraphique grilleAttaque = new GrilleGraphique(10);
        GrilleNavaleGraphique grilleJoueur = new GrilleNavaleGraphique(10);
        grilleJoueur.placementAuto(new int[]{5, 4, 3, 3, 2, 2});
        initFenetre(nomJoueur, grilleAttaque, grilleJoueur.getGrilleGraphique());
        return new JoueurGraphique(grilleJoueur, grilleAttaque);
    }

    public static void main(String[] args) {
        Joueur j1 = initJoueur("Joueur 1");
        Joueur j2 = initJoueur("Joueur 2");
        j1.jouerAvec(j2);
    }
}
