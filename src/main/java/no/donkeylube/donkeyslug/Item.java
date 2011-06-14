package no.donkeylube.donkeyslug;

public class Item implements Placeable {
    private Coordinates coordinates;
    
    @Override
    public Coordinates getCoordinates() {
	return coordinates;
    }

    @Override
    public void setCoordinates(Coordinates coordinates) {
	this.coordinates = coordinates;
    }
}
