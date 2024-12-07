package fr.uga.miashs.inff3.bataillenavale;

import java.awt.Color;
import javax.swing.JOptionPane;

public class JoueurGraphique extends Joueur {

    private GrilleNavaleGraphique gng;
    private GrilleGraphique gg;

    public JoueurGraphique(GrilleNavaleGraphique gng, GrilleGraphique gg) {
        super(gng.getTaille());
        this.gng = gng;
        this.gg = gg;
    }

    @Override
    protected void retourAttaque(Coordonnee c, int etat) {
        switch (etat) {
            case TOUCHE:
                gg.colorie(c, Color.RED);
                JOptionPane.showMessageDialog(gg, "Bateau touché en " + c);
                break;
            case COULE:
                gg.colorie(c, Color.RED);
                JOptionPane.showMessageDialog(gg, "Bateau coulé en " + c);
                break;
            case A_L_EAU:
                gg.colorie(c, Color.BLUE);
                JOptionPane.showMessageDialog(gg, "À l'eau en " + c);
                break;
            case GAMEOVER:
                gg.colorie(c, Color.RED);
                JOptionPane.showMessageDialog(gg, "GAME OVER");
                break;
        }
    }

    @Override
    protected void retourDefense(Coordonnee c, int etat) {
        switch (etat) {
            case TOUCHE:
                JOptionPane.showMessageDialog(gng.getGrilleGraphique(), "Votre navire a été touché en " + c);
                break;
            case COULE:
                JOptionPane.showMessageDialog(gng.getGrilleGraphique(), "Votre navire a été coulé en " + c);
                break;
            case A_L_EAU:
                JOptionPane.showMessageDialog(gng.getGrilleGraphique(), "L'attaque a manqué en " + c);
                break;
            case GAMEOVER:
                JOptionPane.showMessageDialog(gng.getGrilleGraphique(), "GAME OVER");
                break;
        }
    }

    @Override
    public Coordonnee choisirAttaque() {
        return gg.getCoordonneeSelectionnee();
    }

    @Override
    public int defendre(Coordonnee c) {
        if (gng.estALEau(c)) {
            gng.recoitTir(c);
            return A_L_EAU;
        } else if (gng.recoitTir(c)) {
            if (gng.estCoule(c)) {
                if (gng.perdu()) {
                    return GAMEOVER;
                }
                return COULE;
            }
            return TOUCHE;
        }
        return 0;
    }
}
