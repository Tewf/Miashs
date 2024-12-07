package fr.uga.miashs.inff3.bataillenavale;

public class TestBatailleNavale {

    public static void main(String[] args) {
        // Test Coordonnee Class
        testCoordonnee();

        // Test Navire Class
        testNavire();

        // Test GrilleNavale Class
        testGrilleNavale();

        System.out.println("All tests passed!");
    }

    private static void testCoordonnee() {
        System.out.println("Testing Coordonnee...");
        Coordonnee c1 = new Coordonnee("A1");
        assert c1.getLigne() == 0 : "Ligne should be 0 for A1";
        assert c1.getColonne() == 0 : "Colonne should be 0 for A1";

        Coordonnee c2 = new Coordonnee(1, 2);
        assert c2.toString().equals("C2") : "String representation should be C2";

        assert c1.voisine(new Coordonnee(0, 1)) : "A1 should be a neighbor of B1";
        assert !c1.voisine(new Coordonnee(2, 2)) : "A1 should not be a neighbor of C3";

        assert c1.equals(new Coordonnee("A1")) : "A1 should equal another A1";
        assert !c1.equals(c2) : "A1 should not equal C2";

        System.out.println("Coordonnee tests passed!");
    }

    private static void testNavire() {
        System.out.println("Testing Navire...");
        Navire navire = new Navire(new Coordonnee(0, 0), 3, true); // Vertical ship

        assert navire.getDebut().equals(new Coordonnee(0, 0)) : "Start should be A1";
        assert navire.getFin().equals(new Coordonnee(2, 0)) : "End should be A3";

        assert navire.contient(new Coordonnee(1, 0)) : "Ship should contain B1";
        assert !navire.contient(new Coordonnee(3, 0)) : "Ship should not contain D1";

        assert navire.recoitTir(new Coordonnee(1, 0)) : "B1 should be a valid hit";
        assert !navire.recoitTir(new Coordonnee(1, 0)) : "B1 should not register as a hit again";
        assert navire.estTouche() : "Ship should be touched after a hit";

        assert !navire.estCoule() : "Ship should not be sunk yet";
        navire.recoitTir(new Coordonnee(0, 0));
        navire.recoitTir(new Coordonnee(2, 0));
        assert navire.estCoule() : "Ship should be sunk after all parts are hit";

        System.out.println("Navire tests passed!");
    }

    private static void testGrilleNavale() {
        System.out.println("Testing GrilleNavale...");
        GrilleNavale grille = new GrilleNavale(5); // 5x5 grid
        Navire navire1 = new Navire(new Coordonnee(0, 0), 3, true); // Vertical ship
        Navire navire2 = new Navire(new Coordonnee(1, 1), 2, false); // Horizontal ship

        assert grille.ajouteNavire(navire1) : "Navire1 should be added successfully";
        assert !grille.ajouteNavire(navire1) : "Navire1 should not be added again";

        assert grille.ajouteNavire(navire2) : "Navire2 should be added successfully";
        assert !grille.ajouteNavire(new Navire(new Coordonnee(0, 0), 4, true)) : "Overlapping ships should not be added";

        assert grille.estDansGrille(new Coordonnee(4, 4)) : "4,4 should be within the grid";
        assert !grille.estDansGrille(new Coordonnee(5, 5)) : "5,5 should be outside the grid";

        assert grille.recoitTir(new Coordonnee(0, 0)) : "A1 should be a valid hit";
        assert grille.recoitTir(new Coordonnee(0, 1)) == false : "A2 should be a miss";

        assert !grille.perdu() : "Grid should not be lost yet";
        grille.recoitTir(new Coordonnee(1, 0));
        grille.recoitTir(new Coordonnee(2, 0)); // Sink navire1
        grille.recoitTir(new Coordonnee(1, 1));
        grille.recoitTir(new Coordonnee(1, 2)); // Sink navire2
        assert grille.perdu() : "Grid should be lost after all ships are sunk";

        System.out.println("GrilleNavale tests passed!");
    }
}
