package no.donkeylube.donkeyslug;

public class CoordinatesWrapper<T> {
    private final T wrapped;
    private final Coordinates coordinates;
    
    public CoordinatesWrapper(T objectToWrap, Coordinates coordinates) {
	wrapped = objectToWrap;
	this.coordinates = coordinates;
    }
    
    public T get() {
	return wrapped;
    }
    
    public int getX() {
	return coordinates.getX();
    }
    public int getY() {
	return coordinates.getY();
    }
}
