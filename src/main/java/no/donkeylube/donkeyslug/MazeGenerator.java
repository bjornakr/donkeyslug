package no.donkeylube.donkeyslug;

import static no.donkeylube.donkeyslug.Tile.Type.FLOOR;
import static no.donkeylube.donkeyslug.Tile.Type.WALL;

import java.util.Collections;
import java.util.LinkedList;
import java.util.List;

import no.donkeylube.donkeyslug.Tile.Type;

public class MazeGenerator {
    private Tile[][] tiles;
    private TileUtils tileUtils;
    private final List<Tile> visited = new LinkedList<Tile>();

    public LevelMap generate(int height, int width) {
	tiles = new Tile[height][width];
	tileUtils = new TileUtils(tiles);
	tileUtils.fillRectangle(WALL, new Coordinates(0, 0), new Coordinates(width, height));
	findNextTile(tileUtils.findRandomTile(WALL));
	return new LevelMap(tiles);
    }

    private void findNextTile(Tile currentTile) {
	visited.add(currentTile);
	int adjacentFloorCount = 0;
	for (Tile adjacentTile : tileUtils.getAdjacentTiles(currentTile)) {
	    if (adjacentTile.isFloor()) {
		adjacentFloorCount++;
	    }
	}
	if (adjacentFloorCount >= 2 || !legalFloor(currentTile)) {
	    return;	    
	}
	currentTile.changeTypeTo(FLOOR);
	List<Tile> adjacentTiles = tileUtils.getAdjacentTiles(currentTile, Type.WALL);
	Collections.shuffle(adjacentTiles);
	for (Tile adjacentTile : adjacentTiles) {	    
	    if (!visited.contains(adjacentTile)) {
		findNextTile(adjacentTile);
	    }
	}
    }

    private boolean legalFloor(Tile currentTile) {
	int baseX = currentTile.coordinates().getX();
	int baseY = currentTile.coordinates().getY();
	if (baseX == 0 || baseY == 0 || baseX == tiles[0].length-1 || baseY == tiles.length-1) {
	    return true;
	}
	if (tiles[baseY-1][baseX-1].isFloor()
		&& tiles[baseY-1][baseX].isWall()
		&& tiles[baseY][baseX-1].isWall()) {
	    return false;
	}
	else if (tiles[baseY-1][baseX+1].isFloor()
		&& tiles[baseY-1][baseX].isWall()
		&& tiles[baseY][baseX+1].isWall()) {
	    return false;
	}
	else if (tiles[baseY+1][baseX+1].isFloor()
		&& tiles[baseY+1][baseX].isWall()
		&& tiles[baseY][baseX+1].isWall()) {
	    return false;
	}
	else if (tiles[baseY+1][baseX-1].isFloor()
		&& tiles[baseY+1][baseX].isWall()
		&& tiles[baseY][baseX-1].isWall()) {
	    return false;
	}

	return true;
    }
}
