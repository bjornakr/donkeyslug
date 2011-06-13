package no.donkeylube.donkeyslug;

public class MapGenerator {
    enum Type {WALL, FLOOR};
    private Type[][] map;
    
    
    public Type[][] generate(int height, int width) {
	map = new Type[height][width];
	fillRectangle(Type.WALL, 0, 0, height, width);
	
	return map;
    }
    
    
    private void fillRectangle(Type type, int startX, int startY, int endX, int endY) {
	for (int y = startY; y < endY; y++) {
	    for (int x = startX; x < endX; x++) {
		map[y][x] = type;
	    }
	}
    }
}
