package fr.uga.miashs.inff3.bataillenavale;

import java.util.Random;

public class Bot extends Joueur {

    private GrilleNavaleGraphique gng;
    private boolean[][] tirsEnvoyes;

    public Bot(GrilleNavaleGraphique gng) {
        super(gng.getTaille());
        this.gng = gng;
        this.tirsEnvoyes = new boolean[gng.getTaille()][gng.getTaille()];
    }

    @Override
    protected void retourAttaque(Coordonnee c, int etat) {
        // No action needed for Bot
    }

    @Override
    protected void retourDefense(Coordonnee c, int etat) {
        // No action needed for Bot
    }

    @Override
    public Coordonnee choisirAttaque() {
        Random rand = new Random();
        int taille = gng.getTaille();
        int ligne, colonne;
        do {
            ligne = rand.nextInt(taille);
            colonne = rand.nextInt(taille);
        } while (tirsEnvoyes[ligne][colonne]);

        tirsEnvoyes[ligne][colonne] = true;
        return new Coordonnee(ligne, colonne);
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
