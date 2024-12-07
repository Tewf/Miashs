package fr.uga.miashs.inff3.bataillenavale;

import java.util.ArrayList;
import java.util.List;

public class GrilleNavale {

    protected int taille;
    protected List<Navire> navires;
    protected List<Coordonnee> tirsRecus;

    public GrilleNavale(int taille) {
        this.taille = taille;
        this.navires = new ArrayList<Navire>();
        this.tirsRecus = new ArrayList<Coordonnee>();
    }

    public int getTaille() {
        return taille;
    }

    public boolean estDansGrille(Coordonnee c) {
        int ligne = c.getLigne();
        int colonne = c.getColonne();
        return ligne >= 0 && ligne < taille && colonne >= 0 && colonne < taille;
    }

    
    public boolean ajouteNavire(Navire n) {
        if (!estDansGrille(n.getDebut()) || !estDansGrille(n.getFin())) {
            return false; // Ship's start or end is outside the grid
        }
        // Continue with the existing logic for adding ships...
        for (Navire existing : navires) {
            if (n.chevauche(existing) || n.touche(existing)) {
                return false;
            }
        }
        navires.add(n);
        return true;
    }

    public void placementAuto(int[] taillesNavires) {
        for (int tailleNavire : taillesNavires) {
            boolean placed = false;
            while (!placed) {
                int ligne = (int) (Math.random() * taille);
                int colonne = (int) (Math.random() * taille);
                boolean estVertical = Math.random() < 0.5;
                Navire n = new Navire(new Coordonnee(ligne, colonne), tailleNavire, estVertical);
                if (ajouteNavire(n)) {
                    placed = true;
                }
            }
        }
    }

    public boolean recoitTir(Coordonnee c) {
        if (tirsRecus.contains(c)) {
            return false;
        }
        tirsRecus.add(c);
        for (Navire n : navires) {
            if (n.recoitTir(c)) {
                return true;
            }
        }
        return false;
    }

    public boolean estALEau(Coordonnee c) {
        for (Navire n : navires) {
            if (n.contient(c)) {
                return false;
            }
        }
        return true;
    }

    public boolean estTouche(Coordonnee c) {
        for (Navire n : navires) {
            if (n.estTouche(c)) {
                return true;
            }
        }
        return false;
    }

    public boolean estCoule(Coordonnee c) {
        for (Navire n : navires) {
            if (n.contient(c) && n.estCoule()) {
                return true;
            }
        }
        return false;
    }

    public boolean perdu() {
        for (Navire n : navires) {
            if (!n.estCoule()) {
                return false;
            }
        }
        return true;
    }

    public List<Navire> getNavires() {
        return navires;
    }
}
