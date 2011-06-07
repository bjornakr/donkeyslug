package no.donkeylube.donkeyslug;

public class LevelMapTextRenderer {
    private final LevelMap levelMap;
    
    public LevelMapTextRenderer(LevelMap levelMap) {
	this.levelMap = levelMap;
    }
    
    public String render() {
	String map = "";
	for (int y = 0; y < levelMap.getHeight(); y++) {
	    for (int x = 0; x < levelMap.getWidth(); x++) {
		map += createStringRepresentationOfTile(levelMap.getTile(new Coordinates(x, y)));
	    }
	    map += "\n";
	}
	return map;
    }

    private String createStringRepresentationOfTile(Tile tile) {
	if (tile.isWall()) {
	    return "#";
	}
	else if (tile.hasPlayer()) {
	    return "P";
	}
	else {
	    return " ";
	}
    }
}
