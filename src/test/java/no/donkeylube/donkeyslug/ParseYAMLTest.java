package no.donkeylube.donkeyslug;

import static org.junit.Assert.assertTrue;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;

import no.donkeylube.donkeyslug.items.Weapon;

import org.junit.Test;
import org.yaml.snakeyaml.Yaml;
import org.yaml.snakeyaml.constructor.Constructor;

public class ParseYAMLTest {
    

    @Test
    public void testParseYAMLFile() {
	Yaml yaml = new Yaml(new Constructor(Weapon.class));
	BufferedReader bufferedYAMLFile;
	Iterable<Object> o = null;
	try {
	    bufferedYAMLFile = new BufferedReader(new FileReader(new File("src/test/resources/weapons.yaml")));
	    o = yaml.loadAll(bufferedYAMLFile);
	}
	catch (FileNotFoundException e) {
	    e.printStackTrace();
	}
	for (Object waffen : o) {
	    assertTrue(waffen instanceof Weapon);
	    System.out.println((Weapon)waffen);	    
	}
    }
}
