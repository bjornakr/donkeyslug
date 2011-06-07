package no.donkeylube.donkeyslug;

public class Coordinates {
    private final int x;
    private final int y;
    
    public Coordinates(int x, int y) {
	this.x = x;
	this.y = y;	
    }
    
    public int getX() {
	return x;
    }
    
    public int getY() {
	return y;
    }
    
    @Override
    public String toString() {
	return ("Coordinates: (" + x + ", " + y + ")");
    }
    
    @Override
    public boolean equals(Object comparisonObject) {
	if (!(comparisonObject instanceof Coordinates)) {
	    return false;
	}
	Coordinates comparisonCoordinates = (Coordinates) comparisonObject;
	return (x == comparisonCoordinates.getX() && y == comparisonCoordinates.getY());
    }
    
    @Override
    public int hashCode() {
	Integer xInteger = new Integer(x);
	Integer yInteger = new Integer(y);	
	int xHash = xInteger.hashCode();
	int yHash = yInteger.hashCode();	
	return xHash^yHash;
    }
}
