package no.donkeylube.donkeyslug;


public class LevelMap {
//    private final static Logger logger = Logger.getLogger(LevelMap.class.getName());
    private final Tile[][] tiles;
//    private MoveListener moveListener = new MoveListener(this);
    
    protected LevelMap(Tile[][] tiles) {
	this.tiles = tiles;
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

    public int getHeight() {
	return tiles.length;
    }
    
    public int getWidth() {
	return tiles[0].length;
    }
}
