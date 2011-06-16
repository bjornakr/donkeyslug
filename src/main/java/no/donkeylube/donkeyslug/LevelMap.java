package no.donkeylube.donkeyslug;

public class LevelMap {
    private final Tile[][] tiles;
    private final TileUtils tileUtils;

    protected LevelMap(Tile[][] tiles) {
	this.tiles = tiles;
	tileUtils = new TileUtils(tiles);
    }

    public void addPlaceableAt(Placeable placeable, Coordinates coordinates) {
	if (placeable instanceof Movable) {
	    ((Movable) placeable).createMovableMover(this);	    
	}
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

    public void addPlaceableToRandomFloorTile(Placeable placeable) {
	Tile randomTile = tileUtils.findRandomTile(Tile.Type.FLOOR);
	addPlaceableAt(placeable, randomTile.coordinates());
    }
}
