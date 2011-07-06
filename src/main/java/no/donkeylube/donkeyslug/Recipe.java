package no.donkeylube.donkeyslug;

import no.donkeylube.donkeyslug.items.ConsumationEffect;
import no.donkeylube.donkeyslug.items.Ingredient.Type;

public class Recipe {
    private String name;
    private ConsumationEffect consumationEffect;
    
    public Recipe(String name, Type[] ingredientTypesRequired,
	    ConsumationEffect consumationEffect) {
	this.name = name;
	this.consumationEffect = consumationEffect;
    }

    public String name() {
	return name;
    }
    
    public ConsumationEffect consumationEffect() {
	return consumationEffect;
    }
}
