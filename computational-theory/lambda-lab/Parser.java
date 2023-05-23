/*
Tim Rolshud, David Lee
ATiCS Period 3
June 5, 2023
*/

import java.text.ParseException;
import java.util.ArrayList;

public class Parser {
    private ArrayList<String> tokens;

    /*
     * Given an index where a lambda starts, find where the context of the lambda
     * ends and surround this lambda function
     * (known to be without parentheses) with parentheses. A lambda function extends
     * out as far right as possible within
     * its own context.
     */
    private void lambdaScanner(int index) throws ParseException {
        // insert opening paren here
        int start = index;
        int parenCounter = 0;
        while (index < tokens.size()) {
            String currentToken = tokens.get(index);
            if (currentToken.equals("(")) {
                ++parenCounter;
            } else if (currentToken.equals(")")) {
                --parenCounter;
                /*
                 * This lambda's "own context" would be where parenCounter is -1 because you
                 * have a lambda with no opening
                 * paren running into something of a larger context
                 * Example: (a \b.c d) e)
                 */
                if (parenCounter < -1) {
                    throw new ParseException("scope closed without being opened", index);
                } else if (parenCounter == -1) {
                    tokens.add(start, "(");
                    // increment index by 1 because opening paren was added
                    tokens.add(++index, ")");
                    return;

                }
            }
            ++index;
        }
        /*
         * Once we've reached the end, there is no closing paren to run into, the
         * lambda's own context would be where parenCounter is 0
         * Example: a \b.c d
         */
        if (parenCounter < 0) {
            throw new ParseException("scope closed without being opened", index);
        } else if (parenCounter == 0) {
            tokens.add(start, "(");
            tokens.add(++index, ")");
        }

    }

    /*
     * Add parentheses around all lambda functions that currently do not have
     * parentheses around them. Easier for the parser to then process tokens.
     */
    private void preParse() throws ParseException {
        for (int index = 0; index < tokens.size();) {
            // scan lambda if it does not have a left paren to the left of it
            if (tokens.get(index).equals("\\") && (index == 0 || !tokens.get(index - 1).equals("("))) {
                lambdaScanner(index);
            }
            ++index;
        }

    }

    public Expression parse(ArrayList<String> tokens) throws ParseException {
        this.tokens = tokens;
        preParse();
        return null;

    }
}
