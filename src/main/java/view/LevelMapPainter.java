package view;

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

		int brushPosX = 0;
		int brushPosY = 0;
		for (Tile[] tileRow : tiles) {
			for (Tile tile : tileRow) {
				if (tile.isWall()) {
					g2.setColor(Color.DARK_GRAY);
				} else if (tile.isFloor()) {
					g2.setColor(Color.GRAY);
				}
				g2.fillRect(brushPosX, brushPosY, BLOCKSIZE, BLOCKSIZE);

				brushPosX += BLOCKSIZE;
			}
			brushPosX = 0;
			brushPosY += BLOCKSIZE;
		}
		paintPlaceables(g2);
	}

	private void paintPlaceables(Graphics2D g2) {
		int brushPosX = 0;
		int brushPosY = 0;

		int cutoff = BLOCKSIZE / 4;
		for (Tile[] tileRow : tiles) {
			for (Tile tile : tileRow) {
				int newX = 0;
				int newY = 0;
				if (tile.hasPlayer()) {
					g2.setColor(Color.YELLOW);
					if (movableCoordinates.get(tile.getMovable()) == null) {
						movableCoordinates.put(tile.getMovable(), new Coordinates(brushPosX, brushPosY));
					}
					Coordinates oldCoordingatesForMovable = movableCoordinates.get(tile.getMovable());
					if (brushPosX < oldCoordingatesForMovable.getX()) {
						movablesAreMoving = true;
						newX = oldCoordingatesForMovable.getX() - 4;
						if (newX < brushPosX)
							newX = brushPosX;
					} else if (brushPosX > oldCoordingatesForMovable.getX()) {
						movablesAreMoving = true;
						newX = oldCoordingatesForMovable.getX() + 4;
						if (newX > brushPosX)
							newX = brushPosX;
					} else {
						newX = brushPosX;
//						movablesAreMoving = false;
					}
					if (brushPosY < oldCoordingatesForMovable.getY()) {
						movablesAreMoving = true;
						newY = oldCoordingatesForMovable.getY() - 4;
						if (newY < brushPosY) {
							newY = brushPosY;
						}
					}
					else if (brushPosY > oldCoordingatesForMovable.getY()) {
						movablesAreMoving = true;
						newY = oldCoordingatesForMovable.getY() + 4;
						if (newY > brushPosY) {
							newY = brushPosY;
						}
					}
					else {
						newY = brushPosY;
					}
					if (newX == brushPosX && newY == brushPosY) {
						movablesAreMoving = false;
					}
					
					
					g2.fillOval(newX + cutoff, newY + cutoff, BLOCKSIZE - (cutoff * 2), BLOCKSIZE - cutoff * 2);
					movableCoordinates.put(tile.getMovable(), new Coordinates(newX, newY));
				}
				else if (tile.getAttackable() != null) {
					if (tile.getAttackable().isDead()) {
						g2.setColor(Color.BLACK);
					} else {
						g2.setColor(Color.RED);
					}
					g2.fillOval(brushPosX + cutoff, brushPosY + cutoff, BLOCKSIZE - cutoff * 2, BLOCKSIZE - cutoff * 2);
				}
				brushPosX += BLOCKSIZE;
			}
			brushPosX = 0;
			brushPosY += BLOCKSIZE;
		}
	}

	public boolean finishedMovingMovables() {
		return !movablesAreMoving;
	}
}
