package fr.uga.miashs.inff3.bataillenavale;

import java.awt.*;
import java.awt.event.*;
import javax.swing.*;

class JButtonCoordonnee extends JButton {
    private Coordonnee c;

    public JButtonCoordonnee(Coordonnee c) {
        this.c = c;
    }

    public Coordonnee getCoordonnee() {
        return c;
    }
}

public class GrilleGraphique extends JPanel implements ActionListener {

    private static final long serialVersionUID = 1L;
    private JButton[][] cases;
    private Coordonnee coordonneeSelectionnee;

    public GrilleGraphique(int taille) {
        this.setLayout(new GridLayout(taille + 1, taille + 1));

        this.add(new JLabel());
        for (int i = 0; i < taille; i++) {
            JLabel lbl = new JLabel(String.valueOf((char) ('A' + i)));
            lbl.setHorizontalAlignment(JLabel.CENTER);
            this.add(lbl);
        }

        cases = new JButton[taille][taille];
        for (int i = 0; i < taille; i++) {
            JLabel lbl = new JLabel(String.valueOf(i + 1));
            lbl.setHorizontalAlignment(JLabel.CENTER);
            this.add(lbl);
            for (int j = 0; j < taille; j++) {
                cases[i][j] = new JButtonCoordonnee(new Coordonnee(i, j));
                this.add(cases[i][j]);
                cases[i][j].addActionListener(this);
            }
        }
    }

    public void colorie(Coordonnee cord, Color color) {
        int row = cord.getLigne();
        int col = cord.getColonne();
        if (row >= 0 && row < cases.length && col >= 0 && col < cases[row].length) {
            cases[row][col].setBackground(color);
        }
    }

    public void colorie(Coordonnee debut, Coordonnee fin, Color color) {
        for (int i = debut.getLigne(); i <= fin.getLigne(); i++) {
            for (int j = debut.getColonne(); j <= fin.getColonne(); j++) {
                if (i >= 0 && i < cases.length && j >= 0 && j < cases[i].length) {
                    cases[i][j].setBackground(color);
                }
            }
        }
    }

    public void setClicActive(boolean active) {
        SwingUtilities.invokeLater(new Runnable() {
            public void run() {
                for (JButton[] ligne : cases) {
                    for (JButton bt : ligne) {
                        bt.setEnabled(active);
                    }
                }
            }
        });
    }

    @Override
    public void actionPerformed(ActionEvent e) {
        this.setClicActive(false);
        coordonneeSelectionnee = ((JButtonCoordonnee) e.getSource()).getCoordonnee();
        synchronized (this) {
            this.notifyAll();
        }
    }

    public synchronized Coordonnee getCoordonneeSelectionnee() {
        this.setClicActive(true);
        try {
            this.wait();
        } catch (InterruptedException ex) {
            throw new RuntimeException(ex);
        }
        return coordonneeSelectionnee;
    }
}
