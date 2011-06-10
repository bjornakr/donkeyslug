package no.donkeylube.donkeyslug.helpers;

import java.util.Random;

public class RandomDistributor {
    
    public static int walk(int base, int steps, double chanceOfWalk) {
	if (chanceOfWalk >= 1 || chanceOfWalk < 0) {
	    throw new IllegalArgumentException("Chance of walk must be between 0-1, 1 exclusive.");
	}
	double random = Math.random();
	if (random < chanceOfWalk) {
	    return walk(base+steps, steps, chanceOfWalk);
	}
	else {
	    boolean positive = new Random().nextBoolean();
	    return (positive ? base : -base);
	}
    }    
    
    public static void main(String[] args) {
	for (int i=0; i < 10; i++) {
	    System.out.println(walk(0, 1, 0.9));
	}
    }
}
