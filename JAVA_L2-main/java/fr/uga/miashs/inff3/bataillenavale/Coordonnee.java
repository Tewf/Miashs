package fr.uga.miashs.inff3.bataillenavale;

public class Coordonnee {

    private int ligne;
    private int colonne;

    public Coordonnee(String s) {
        char charC = s.charAt(0);
        if (charC >= 'a' && charC <= 'z') {
            this.colonne = charC - 'a';
        } else if (charC >= 'A' && charC <= 'Z') {
            this.colonne = charC - 'A';
        }
        this.ligne = Integer.parseInt(s.substring(1)) - 1;
    }

    public Coordonnee(int l, int c) {
        this.ligne = l;
        this.colonne = c;
    }

    public int getLigne() {
        return ligne;
    }

    public int getColonne() {
        return colonne;
    }

    @Override
    public boolean equals(Object o) {
        if (o instanceof Coordonnee) {
            Coordonnee other = (Coordonnee) o;
            return this.ligne == other.ligne && this.colonne == other.colonne;
        }
        return false;
    }

    public boolean voisine(Coordonnee c) {
        int diffColonne = Math.abs(c.colonne - this.colonne);
        int diffLigne = Math.abs(c.ligne - this.ligne);
        return (diffLigne == 1 && diffColonne == 0) || (diffLigne == 0 && diffColonne == 1);
    }

    public int compareTo(Coordonnee c) {
        int valO = ligne * 10 + colonne;
        int valC = c.ligne * 10 + c.colonne;
        return valO - valC;
    }

    @Override
    public String toString() {
        return String.valueOf((char) (colonne + 'A')) + (ligne + 1);
    }
}
