package no.donkeylube.donkeyslug;

public class Tile {
    enum Type {WALL, FLOOR};
    
    private Type type; 
    
    public Tile(Type type) {
	this.type = type;
    }
    
    public boolean isWall() {
	return type == Type.WALL;
    }
}
