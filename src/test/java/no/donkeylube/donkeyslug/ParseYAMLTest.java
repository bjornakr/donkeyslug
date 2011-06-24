package no.donkeylube.donkeyslug;

import static org.junit.Assert.assertTrue;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;

import org.junit.Test;
import org.yaml.snakeyaml.TypeDescription;
import org.yaml.snakeyaml.Yaml;
import org.yaml.snakeyaml.constructor.Constructor;

public class ParseYAMLTest {
    

    @Test
    public void testParseYAMLFile() {
//	Yaml yaml = new Yaml(new Constructor(Waffen.class));
	Yaml yaml = new Yaml();
	TypeDescription waffenDescription = new TypeDescription(Waffen.class);
	waffenDescription.putListPropertyType("", Waffen.class);
	BufferedReader bufferedYAMLFile;
	Object o = null;
	try {
	    bufferedYAMLFile = new BufferedReader(new FileReader(new File("src/test/resources/weapons.yaml")));
	    o = yaml.load(bufferedYAMLFile);
	}
	catch (FileNotFoundException e) {
	    e.printStackTrace();
	} 
	System.out.println(o);
	assertTrue(o instanceof Waffen);
	System.out.println((Waffen) o);
    }
}
