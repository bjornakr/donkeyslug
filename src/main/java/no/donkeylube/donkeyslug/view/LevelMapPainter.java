package no.donkeylube.donkeyslug.view;

import java.awt.Color;
import java.awt.Dimension;
import java.awt.Graphics;
import java.awt.Graphics2D;
import java.util.HashMap;

import javax.swing.JPanel;

import no.donkeylube.donkeyslug.AttackListener;
import no.donkeylube.donkeyslug.AttackReport;
import no.donkeylube.donkeyslug.Coordinates;
import no.donkeylube.donkeyslug.Movable;
import no.donkeylube.donkeyslug.Player;
import no.donkeylube.donkeyslug.Tile;
import no.donkeylube.donkeyslug.items.Armor;
import no.donkeylube.donkeyslug.items.Consumable;
import no.donkeylube.donkeyslug.items.Item;
import no.donkeylube.donkeyslug.items.Weapon;

public class LevelMapPainter extends JPanel implements AttackListener {
    private static final long serialVersionUID = 1L;
    private final int BLOCKSIZE = 20;
    private Tile[][] tiles;
    private boolean movablesAreMoving = false;
    HashMap<Movable, Coordinates> movableCoordinates = new HashMap<Movable, Coordinates>();

    public LevelMapPainter(Tile[][] tiles) {
	this.tiles = tiles;
	setPreferredSize(new Dimension(BLOCKSIZE * tiles[0].length, BLOCKSIZE * tiles.length));
    }

    public void paintComponent(Graphics g) {
	Graphics2D g2 = (Graphics2D) g;
	paintLevel(g2);
	paintMovables(g2);
    }

    private void paintLevel(Graphics2D g2) {
	int brushPosX = 0;
	int brushPosY = 0;
	for (Tile[] tileRow : tiles) {
	    for (Tile tile : tileRow) {
		if (tile.isWall()) {
		    g2.setColor(new Color(0x30291D));
		}
		else if (tile.isFloor()) {
		    g2.setColor(new Color(0xA18C6C));
		}
		g2.fillRect(brushPosX, brushPosY, BLOCKSIZE, BLOCKSIZE);

		brushPosX += BLOCKSIZE;
	    }
	    brushPosX = 0;
	    brushPosY += BLOCKSIZE;
	}
    }

    private void paintMovables(Graphics2D g2) {
	int brushPosX = 0;
	int brushPosY = 0;

	for (Tile[] tileRow : tiles) {
	    for (Tile tile : tileRow) {
		int sizeRedux = BLOCKSIZE / 4;
		if (tile.getItems().size() > 0) {
		    g2.setColor(Color.ORANGE);
		    g2.fillRect(brushPosX + sizeRedux, brushPosY + sizeRedux, BLOCKSIZE - sizeRedux*2, BLOCKSIZE - sizeRedux*2);
		    Item item = tile.getItems().get(0);
		    if (item instanceof Weapon) {
			sizeRedux += 3;
			g2.setColor(Color.GRAY);
			g2.fillRect(brushPosX + sizeRedux, brushPosY + sizeRedux, BLOCKSIZE - sizeRedux*2, BLOCKSIZE - sizeRedux*2);
		    }
		    if (item instanceof Consumable) {
			sizeRedux += 3;
			g2.setColor(Color.RED);
			g2.fillRect(brushPosX + sizeRedux, brushPosY + sizeRedux, BLOCKSIZE - sizeRedux*2, BLOCKSIZE - sizeRedux*2);
		    }
		    if (item instanceof Armor) {
			sizeRedux += 3;
			g2.setColor(Color.WHITE);
			g2.fillRect(brushPosX + sizeRedux, brushPosY + sizeRedux, BLOCKSIZE - sizeRedux*2, BLOCKSIZE - sizeRedux*2);
		    }
		}
		else if (tile.getAttackable() != null && !(tile.getAttackable() instanceof Player)) {
		    if (tile.getAttackable().isDead()) {
			g2.setColor(Color.BLACK);
			sizeRedux = BLOCKSIZE / 3;
		    }
		    else {
			g2.setColor(Color.RED);
		    }
		    g2.fillOval(brushPosX + sizeRedux, brushPosY + sizeRedux,
			    BLOCKSIZE - sizeRedux * 2, BLOCKSIZE - sizeRedux * 2);
		}
		if (tile.hasPlayer()) {
		    int newXForMovable = 0;
		    int newYForMovable = 0;
		    g2.setColor(Color.YELLOW);
		    if (movableCoordinates.get(tile.getMovable()) == null) {
			movableCoordinates.put(tile.getMovable(), new Coordinates(brushPosX, brushPosY));
		    }
		    Coordinates oldCoordingatesForMovable = movableCoordinates.get(tile.getMovable());
		    newXForMovable = determineNewBrushPositionForMovable(brushPosX, oldCoordingatesForMovable.getX());
		    newYForMovable = determineNewBrushPositionForMovable(brushPosY, oldCoordingatesForMovable.getY());

		    if (newXForMovable == brushPosX && newYForMovable == brushPosY) {
			movablesAreMoving = false;
		    }

		    g2.fillOval(newXForMovable + sizeRedux, newYForMovable + sizeRedux,
			    BLOCKSIZE - (sizeRedux * 2), BLOCKSIZE - sizeRedux * 2);
		    movableCoordinates.put(tile.getMovable(), new Coordinates(newXForMovable, newYForMovable));
		}
		brushPosX += BLOCKSIZE;
	    }
	    brushPosX = 0;
	    brushPosY += BLOCKSIZE;
	}
    }

    private int determineNewBrushPositionForMovable(int currentBrushPosition, int currentCoordinatesForMovable) {
	final int MOVEMENT = 4;

	if (currentBrushPosition == currentCoordinatesForMovable) {
	    return currentBrushPosition;
	}
	movablesAreMoving = true;
	int newBrushPosistion = 0;

	if (currentBrushPosition < currentCoordinatesForMovable) {
	    newBrushPosistion = currentCoordinatesForMovable - MOVEMENT;
	    if (newBrushPosistion < currentBrushPosition) {
		newBrushPosistion = currentBrushPosition;
	    }
	}
	else if (currentBrushPosition > currentCoordinatesForMovable) {
	    newBrushPosistion = currentCoordinatesForMovable + MOVEMENT;
	    if (newBrushPosistion > currentBrushPosition) {
		newBrushPosistion = currentBrushPosition;
	    }
	}
	return newBrushPosistion;
    }

    public boolean finishedMovingMovables() {
	return !movablesAreMoving;
    }

    @Override
    public void attackPerformed(AttackReport attackReport) {
	
    }
}
