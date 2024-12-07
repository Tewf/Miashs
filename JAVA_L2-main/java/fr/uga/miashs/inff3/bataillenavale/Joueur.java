package fr.uga.miashs.inff3.bataillenavale;

public abstract class Joueur {

    public static final int TOUCHE = 1;
    public static final int COULE = 2;
    public static final int A_L_EAU = 3;
    public static final int GAMEOVER = 4;

    private int tailleGrille;
    protected Joueur adversaire;

    public Joueur(int taille) {
        this.tailleGrille = taille;
    }

    public int getTaille() {
        return tailleGrille;
    }

    public void jouerAvec(Joueur adversaire) {
        if (this.adversaire != null || adversaire.adversaire != null) {
            throw new RuntimeException("One of the players is already in a game.");
        }

        this.adversaire = adversaire;
        adversaire.adversaire = this;

        Joueur current = this;
        int res;
        do {
            Coordonnee attaque = current.choisirAttaque();
            res = current.adversaire.defendre(attaque);
            current.retourAttaque(attaque, res);
            current.adversaire.retourDefense(attaque, res);

            // Switch turns
            current = (current == this) ? adversaire : this;
        } while (res != GAMEOVER);
    }

    protected abstract void retourAttaque(Coordonnee c, int etat);

    protected abstract void retourDefense(Coordonnee c, int etat);

    public abstract Coordonnee choisirAttaque();

    public abstract int defendre(Coordonnee c);
}
