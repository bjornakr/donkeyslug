package no.donkeylube.donkeyslug;

import org.junit.Test;
import static org.junit.Assert.*;

public class AutomaticLevelMapGeneratorTest {

    @Test
    public void generatedLevelMapShouldHaveNoInaccessibleTiles() {
	LevelMap levelMap = LevelMapFactory.generateLevelMap(40, 17);
	LevelMapTextRenderer renderer = new LevelMapTextRenderer(levelMap);
	System.out.println(renderer.render());
	assertTrue(levelMap.allFloorTilesAreAccessible());
    }
}
