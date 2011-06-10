package no.donkeylube.donkeyslug.view;

import java.awt.Color;
import java.awt.Dimension;
import java.awt.Graphics;
import java.awt.Graphics2D;
import java.util.HashMap;

import javax.swing.JPanel;

import no.donkeylube.donkeyslug.Coordinates;
import no.donkeylube.donkeyslug.Movable;
import no.donkeylube.donkeyslug.Tile;

public class LevelMapPainter extends JPanel {
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
		    g2.setColor(Color.DARK_GRAY);
		}
		else if (tile.isFloor()) {
		    g2.setColor(Color.GRAY);
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

	int sizeRedux = BLOCKSIZE / 4;
	for (Tile[] tileRow : tiles) {
	    for (Tile tile : tileRow) {
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
		else if (tile.getAttackable() != null) {
		    if (tile.getAttackable().isDead()) {
			g2.setColor(Color.BLACK);
		    }
		    else {
			g2.setColor(Color.RED);
		    }
		    g2.fillOval(brushPosX + sizeRedux, brushPosY + sizeRedux,
			    BLOCKSIZE - sizeRedux * 2, BLOCKSIZE - sizeRedux * 2);
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
}
