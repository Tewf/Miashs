package fr.uga.miashs.inff3.bataillenavale;

public class Navire {

    private Coordonnee debut;
    private Coordonnee fin;
    private Coordonnee[] partiesTouchees;
    private int nbTouchees;

    public Navire(Coordonnee debut, int longueur, boolean estVertical) {
        this.debut = debut;
        if (estVertical) {
            this.fin = new Coordonnee(debut.getLigne() + longueur - 1, debut.getColonne());
        } else {
            this.fin = new Coordonnee(debut.getLigne(), debut.getColonne() + longueur - 1);
        }
        this.partiesTouchees = new Coordonnee[longueur];
        this.nbTouchees = 0;
    }

    public Coordonnee getDebut() {
        return debut;
    }

    public Coordonnee getFin() {
        return fin;
    }

    public boolean contient(Coordonnee c) {
        return c.getLigne() >= debut.getLigne() && c.getLigne() <= fin.getLigne()
                && c.getColonne() >= debut.getColonne() && c.getColonne() <= fin.getColonne();
    }

    public boolean chevauche(Navire n) {
        return intersectionNonVide(debut.getLigne(), fin.getLigne(), n.debut.getLigne(), n.fin.getLigne())
                && intersectionNonVide(debut.getColonne(), fin.getColonne(), n.debut.getColonne(), n.fin.getColonne());
    }

    public boolean touche(Navire n) {
        boolean toucheHorizontalement = intersectionNonVide(debut.getLigne(), fin.getLigne(), n.debut.getLigne(), n.fin.getLigne())
                && (Math.abs(debut.getColonne() - n.fin.getColonne()) == 1 || Math.abs(fin.getColonne() - n.debut.getColonne()) == 1);

        boolean toucheVerticalement = intersectionNonVide(debut.getColonne(), fin.getColonne(), n.debut.getColonne(), n.fin.getColonne())
                && (Math.abs(debut.getLigne() - n.fin.getLigne()) == 1 || Math.abs(fin.getLigne() - n.debut.getLigne()) == 1);

        return toucheHorizontalement || toucheVerticalement;
    }

    public boolean estTouche(Coordonnee c) {
        for (int i = 0; i < nbTouchees; i++) {
            if (partiesTouchees[i].equals(c)) {
                return true;
            }
        }
        return false;
    }

    public boolean recoitTir(Coordonnee c) {
        if (contient(c) && !estTouche(c)) {
            partiesTouchees[nbTouchees] = c;
            nbTouchees++;
            return true;
        }
        return false;
    }

    public boolean estTouche() {
        return nbTouchees > 0;
    }

    public boolean estCoule() {
        int longueur = Math.max(fin.getLigne() - debut.getLigne(), fin.getColonne() - debut.getColonne()) + 1;
        return nbTouchees == longueur;
    }

    public double distance() {
        return Math.sqrt(Math.pow(fin.getLigne() - debut.getLigne(), 2) + Math.pow(fin.getColonne() - debut.getColonne(), 2));
    }

    private static boolean intersectionNonVide(int d1, int f1, int d2, int f2) {
        return (d1 <= f2 && f1 >= d2);
    }

    @Override
    public String toString() {
        return "Navire de " + debut + " à " + fin + ", touché " + nbTouchees + " fois.";
    }
}
