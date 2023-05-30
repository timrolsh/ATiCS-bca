/*
Tim Rolshud, David Lee
ATiCS Period 3
June 5, 2023
*/

import java.util.ArrayList;
import java.util.Arrays;

public class Lexer {
    static final ArrayList<String> characters = new ArrayList<>(Arrays.asList("\\", ".", "(", ")", "λ", "="));
    static final String spaceString = " ";

    /*
     * A lexer (or "tokenizer") converts an input into tokens that
     * eventually need to be interpreted.
     *
     * Given the input
     * (\bat .bat flies)cat λg.joy! )
     * you should output the ArrayList of strings
     * [(, \, bat, ., bat, flies, ), cat, \, g, ., joy!, )]
     *
     */
    public ArrayList<String> tokenize(String input) {
        ArrayList<String> tokens = new ArrayList<>();
        for (int index = 0; index < input.length() && input.charAt(index) != ';'; ) {
            String current = input.substring(index, index + 1);
            if (current.equals(";")) {
                break;
            } else if (current.equals(spaceString)) {
                ++index;
            } else if (characters.contains(current)) {
                if (current.equals("λ")) {
                    tokens.add("\\");
                } else {
                    tokens.add(current);
                }
                ++index;
            } else {
                int start = index;
                while (!(index == input.length() || input.charAt(index) == ' ' || characters.contains(input.substring(index, index + 1)))) {
                    ++index;
                }
                tokens.add(input.substring(start, index));
            }
        }
        return tokens;
    }
}
