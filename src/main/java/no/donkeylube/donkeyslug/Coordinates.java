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

    public static Coordinates getInstanceWithCutoffs(int x, int y, int height, int width) {
	x = cutoff(x, width-1);
	y = cutoff(y, height-1);
	return new Coordinates(x, y);
    }
    
    private static int cutoff(int value, int max) {
	if (value < 0) {
	    return 0;
	}
	else if (value > max) {
	    return max;
	}
	else {
	    return value;
	}
    }
}
