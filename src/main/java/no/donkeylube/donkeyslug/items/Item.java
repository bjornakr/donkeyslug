package no.donkeylube.donkeyslug.items;

import no.donkeylube.donkeyslug.Coordinates;
import no.donkeylube.donkeyslug.Placeable;

public abstract class Item implements Placeable {
    private Coordinates coordinates;
    private String name;
    
    public Item(String name) {
	this.name = name;
    }
    
    public String name() {
	return name;
    }
    
    @Override
    public Coordinates getCoordinates() {
	return coordinates;
    }

    @Override
    public void setCoordinates(Coordinates coordinates) {
	this.coordinates = coordinates;
    }
}
