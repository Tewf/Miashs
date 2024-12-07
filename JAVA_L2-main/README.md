
---

# **Battleship Game (Bataille Navale)**

A Java-based implementation of the classic Battleship game with both logical and graphical components. This project allows two players to compete by attacking each other’s grids until one player’s ships are completely sunk.

---

## **Project Structure**

The project is organized into the following classes:

### 1. **Coordonnee**
Represents a coordinate on the game grid.

- **Attributes**:
  - `ligne`: The row index of the coordinate.
  - `colonne`: The column index of the coordinate.

- **Key Methods**:
  - `equals(Coordonnee)`: Checks if two coordinates are the same.
  - `contient(Coordonnee)`: Returns `true` if a ship contains this coordinate.

---

### 2. **Navire**
Represents a ship on the grid.

- **Attributes**:
  - `debut`: The starting coordinate of the ship.
  - `fin`: The ending coordinate of the ship.
  - `nbTouchees`: Tracks how many parts of the ship have been hit.

- **Key Methods**:
  - `recoitTir(Coordonnee)`: Records a hit on the ship if the coordinate matches.
  - `estCoule()`: Checks if the entire ship is sunk.
  - `touche(Navire)`: Checks if two ships are touching or overlapping.

---

### 3. **GrilleNavale**
Manages the logical representation of the game grid and ships.

- **Attributes**:
  - `taille`: The size of the grid (e.g., 10x10).
  - `navires`: A list of all ships on the grid.
  - `tirsRecus`: Tracks all received attacks.

- **Key Methods**:
  - `ajouteNavire(Navire)`: Adds a ship to the grid if it doesn’t overlap or touch other ships.
  - `recoitTir(Coordonnee)`: Handles an attack and returns whether it hit a ship.
  - `perdu()`: Returns `true` if all ships are sunk.

---

### 4. **GrilleNavaleGraphique**
Extends `GrilleNavale` to add graphical elements.

- **Attributes**:
  - `gg`: An instance of `GrilleGraphique` (the GUI representation).

- **Key Methods**:
  - `ajouteNavire(Navire)`: Adds a ship to the grid and updates the GUI with a green color.
  - `recoitTir(Coordonnee)`: Updates the GUI to show hits (red) or misses (blue).

---

### 5. **GrilleGraphique**
A graphical representation of the grid, allowing user interaction.

- **Attributes**:
  - `cases`: A 2D array of buttons representing the grid cells.

- **Key Methods**:
  - `colorie(Coordonnee, Color)`: Colors a cell based on the action (hit, miss, or ship placement).
  - `getCoordonneeSelectionnee()`: Waits for the user to click a cell and returns the coordinate.

---

### 6. **Joueur (Abstract)**
Defines the behavior of a player in the game.

- **Attributes**:
  - `tailleGrille`: The size of the player's grid.
  - `adversaire`: Reference to the opposing player.

- **Key Methods**:
  - `jouerAvec(Joueur)`: Alternates turns between two players.
  - `choisirAttaque()`: Abstract method for selecting an attack coordinate.
  - `defendre(Coordonnee)`: Abstract method for handling an attack.

---

### 7. **JoueurGraphique**
Extends `Joueur` to allow graphical gameplay.

- **Attributes**:
  - `gng`: A `GrilleNavaleGraphique` for tracking the player's ships.
  - `gg`: A `GrilleGraphique` for tracking the player's attacks.

- **Key Methods**:
  - `choisirAttaque()`: Allows the player to click on the grid to select an attack.
  - `defendre(Coordonnee)`: Updates the grid based on the result of the opponent’s attack.

---

### 8. **BatailleNavale (Main Class)**
Manages the game flow, including player initialization and GUI setup.

- **Key Methods**:
  - `initFenetre(String, GrilleGraphique, GrilleGraphique)`: Creates the GUI window for a player.
  - `initJoueur(String)`: Creates and initializes a graphical player.
  - `main(String[])`: Starts the game with two players taking turns.

---

## **How to Run**

1. **Compile the Project**:
   ```bash
   javac -d build src/fr/uga/miashs/inff3/bataillenavale/*.java
   ```

2. **Run the Game**:
   ```bash
   java -cp build fr.uga.miashs.inff3.bataillenavale.BatailleNavale
   ```

---

## **Gameplay Instructions**

1. Each player takes turns selecting a coordinate on the attack grid.
2. The game provides feedback on hits, misses, and when ships are sunk.
3. The game ends when one player’s fleet is completely destroyed.
