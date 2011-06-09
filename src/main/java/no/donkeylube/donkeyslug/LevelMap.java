package no.donkeylube.donkeyslug;

import java.util.LinkedList;
import java.util.List;
import java.util.Random;

public class LevelMap {
	// private final static Logger logger =
	// Logger.getLogger(LevelMap.class.getName());
	private final Tile[][] tiles;

	// private MoveListener moveListener = new MoveListener(this);

	protected LevelMap(Tile[][] tiles) {
		this.tiles = tiles;
		if (countAllFloorTiles() == 0) {
			throw new IllegalStateException("Cannot create level map without floor tiles.");
		}
	}

	public void addPlaceableAt(Placeable placeable, Coordinates coordinates) {
		tiles[coordinates.getY()][coordinates.getX()].add(placeable);
	}

	public boolean hasPlaceableAt(Placeable placeable, Coordinates coordinates) {
		return tiles[coordinates.getY()][coordinates.getX()].contains(placeable);
	}

	public Tile getTile(Coordinates coordinates) {
		return tiles[coordinates.getY()][coordinates.getX()];
	}
	
	public Tile[][] getTiles() {
		return tiles;
	}

	public Coordinates getCoordinatesFor(Placeable placeable) {
		for (int y = 0; y < getHeight(); y++) {
			for (int x = 0; x < getWidth(); x++) {
				if (tiles[y][x].contains(placeable)) {
					return new Coordinates(x, y);
				}
			}
		}
		return null;
	}

	public Coordinates getCoordinatesFor(Tile tile) {
		for (int y = 0; y < getHeight(); y++) {
			for (int x = 0; x < getWidth(); x++) {
				if (tiles[y][x].equals(tile)) {
					return new Coordinates(x, y);
				}
			}
		}
		return null;
	}

	public int getHeight() {
		return tiles.length;
	}

	public int getWidth() {
		return tiles[0].length;
	}

	public boolean allFloorTilesAreAccessible() {
		int totalNoOfFloorTiles = countAllFloorTiles();
		Tile firstFloorTile = findFirstFloorTile();
		int noOfReachableFloorTiles = countNoOfReachableFloorTiles(firstFloorTile, new LinkedList<Tile>());
		return (totalNoOfFloorTiles == noOfReachableFloorTiles);
	}

	private int countNoOfReachableFloorTiles(Tile baseTile, List<Tile> checkedTiles) {
		if (baseTile.isWall()) {
			throw new IllegalArgumentException("Base tile cannot be a wall.");
		}
		int noOfReachableFloorTilesCount = 1;
		checkedTiles.add(baseTile);
		for (Tile adjacentFloorTile : getAdjacentFloorTiles(baseTile)) {
			if (!checkedTiles.contains(adjacentFloorTile)) {
				noOfReachableFloorTilesCount += countNoOfReachableFloorTiles(adjacentFloorTile, checkedTiles);
			}
		}
		return noOfReachableFloorTilesCount;
	}

	private int countAllFloorTiles() {
		int totalNoOfFloorTiles = 0;
		for (Tile[] tileRows : tiles) {
			for (Tile tile : tileRows) {
				if (!tile.isWall()) {
					totalNoOfFloorTiles++;
				}
			}
		}

		return totalNoOfFloorTiles;
	}

	private Tile findFirstFloorTile() {
		for (Tile[] tileRows : tiles) {
			for (Tile tile : tileRows) {
				if (!tile.isWall()) {
					return tile;
				}
			}
		}
		throw new IllegalStateException("LevelMap contains no floor tiles.");
	}

	private List<Tile> getAdjacentFloorTiles(Tile baseTile) {
		List<Tile> adjacentFloorTiles = new LinkedList<Tile>();
		Coordinates baseTileCoordinates = getCoordinatesFor(baseTile);
		for (Coordinates adjacentCoordinate : getAdjacentCoordinates(baseTileCoordinates)) {
			if (!getTile(adjacentCoordinate).isWall()) {
				adjacentFloorTiles.add(getTile(adjacentCoordinate));
			}
		}
		return adjacentFloorTiles;
	}

	public List<Coordinates> getAdjacentCoordinates(Coordinates baseCoordinates) {
		int x = baseCoordinates.getX();
		int y = baseCoordinates.getY();

		List<Coordinates> adjacentCoordinates = new LinkedList<Coordinates>();
		if (x - 1 >= 0) {
			adjacentCoordinates.add(new Coordinates(x - 1, y));
		}
		if (x < tiles[0].length-1) {
			adjacentCoordinates.add(new Coordinates(x + 1, y));
		}
		if (y - 1 >= 0) {
			adjacentCoordinates.add(new Coordinates(x, y - 1));
		}
		if (y < tiles.length-1) {
			adjacentCoordinates.add(new Coordinates(x, y + 1));
		}
		return adjacentCoordinates;
	}

	public Tile findRandomFloorTile() {
		Random random = new Random();
		int x = random.nextInt(getWidth());
		int y = random.nextInt(getHeight());

		while (!tiles[y][x].isFloor()) {
			x++;
			if (x >= getWidth()) {
				x = 1;
				y++;
				if (y >= getHeight()) {
					y = 1;
				}
			}
		}

		return tiles[y][x];
	}
}
