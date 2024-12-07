package fr.uga.miashs.inff3.bataillenavale;

import java.awt.Color;

public class GrilleNavaleGraphique extends GrilleNavale {

    private GrilleGraphique gg;

    public GrilleNavaleGraphique(int taille) {
        super(taille);
        this.gg = new GrilleGraphique(taille);
    }

    public GrilleGraphique getGrilleGraphique() {
        return gg;
    }

    @Override
    public boolean ajouteNavire(Navire n) {
        boolean success = super.ajouteNavire(n);
        if (success) {
            gg.colorie(n.getDebut(), n.getFin(), Color.GREEN);
        }
        return success;
    }

    @Override
    public boolean recoitTir(Coordonnee c) {
        boolean hit = super.recoitTir(c);
        if (hit) {
            gg.colorie(c, Color.RED);
        } else {
            gg.colorie(c, Color.BLUE);
        }
        return hit;
    }
    public boolean perdu() {
        for (Navire navire : navires) {
            if (!navire.estCoule()) {
                return false; // At least one ship is still afloat
            }
        }
        return true; // All ships are sunk
    }

    public boolean estCoule(Coordonnee c) {
        for (Navire navire : navires) {
            if (navire.contient(c) && navire.estCoule()) {
                return true;
            }
        }
        return false;
    }
    public boolean estALEau(Coordonnee c) {
        for (Navire navire : navires) {
            if (navire.contient(c)) {
                return false; // The coordinate is part of a ship
            }
        }
        return true; // The coordinate is not part of any ship
    }

}
