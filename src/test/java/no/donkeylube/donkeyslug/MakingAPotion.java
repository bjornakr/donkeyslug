package no.donkeylube.donkeyslug;

import java.util.LinkedList;
import java.util.List;

import no.donkeylube.donkeyslug.items.Consumable;
import no.donkeylube.donkeyslug.items.ConsumationEffect;
import no.donkeylube.donkeyslug.items.Ingredient;

import org.junit.Before;
import org.junit.Test;
import static org.junit.Assert.*;
import static no.donkeylube.donkeyslug.items.Ingredient.Type.*;

public class MakingAPotion {
    private Creature alchemist;
    
    @Before
    public void initializeCreature() {
	CreatureStatistics stats = new CreatureStatistics.Builder(10, 10).hitPoints(100).build();
	alchemist = new Creature("Alchemist", stats);	
    }
    
    @Test
    public void combiningHerbsIntoHealthPotion() {
	Consumable healthPotion = alchemist.alchemize(ingredientsForHealthPotion(), createHealthPotionRecipe());
	alchemist.consume(healthPotion);
	assertEquals(125, alchemist.getStatistics().getHitPoints());
	assertFalse("Consumed potion removed from inventory", alchemist.hasItem(healthPotion));
    }

    
    private Recipe createHealthPotionRecipe() {
	return new Recipe("Minor health potion", ingredientTypesRequiredForHealthPotion(),
		consumationEffectThatIncreasesLifeBy25Percent());
	
    }
    
    private Ingredient.Type[] ingredientTypesRequiredForHealthPotion() {
	Ingredient.Type[] ingredientTypesRequiredForHealthPotion = {GREEN, GREEN, RED};
	return ingredientTypesRequiredForHealthPotion;
    }

    private ConsumationEffect consumationEffectThatIncreasesLifeBy25Percent() {
	return ConsumationEffectFactory.createModifyHealthEffect(0.25);
    }

    private List<Ingredient> ingredientsForHealthPotion() {
	List<Ingredient> ingredientsForHealthPotion = new LinkedList<Ingredient>();
	ingredientsForHealthPotion.add(new Ingredient("Inky cap", Ingredient.Type.GREEN));
	ingredientsForHealthPotion.add(new Ingredient("Rose moss", Ingredient.Type.GREEN));
	ingredientsForHealthPotion.add(new Ingredient("Wine", Ingredient.Type.RED));
	for (Ingredient ingredient : ingredientsForHealthPotion) {
	    alchemist.give(ingredient);
	}
	return ingredientsForHealthPotion;
    }
}
