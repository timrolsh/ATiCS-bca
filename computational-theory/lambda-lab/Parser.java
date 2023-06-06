/*
Tim Rolshud, David Lee
ATiCS Period 3
June 6, 2023
*/

import java.text.ParseException;
import java.util.ArrayList;
import java.util.HashMap;

public class Parser {
    public static final HashMap<String, Expression> storedVars = new HashMap<>();
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
        for (int index = 0; index < tokens.size(); ++index) {
            // scan lambda if it does not have a left paren to the left of it
            if (tokens.get(index).equals("\\") && (index == 0 || !tokens.get(index - 1).equals("("))) {
                lambdaScanner(index);
            }
        }
    }

    /*
     * Given a string, if this string corresponds to an already declared variable,
     * substitute that variable for this string. Otherwise, create a new variable
     * that represents this string.
     */
    private Expression variableScanner(String s) {
        // this isn't just a variable, this is a stored variable
        if (storedVars.containsKey(s)) {
            return storedVars.get(s);
        }
        return new Variable(s);
    }

    /*
     * Main helper method for parse. Executes after the pre-parser has been called.
     */
    private Expression parseHelper(int start, int end) {
        // if it is a lambda
        if (tokens.get(start).equals("\\")) {
            // most likely not be a case where variable here will point to something else
            return new Function(new Variable(tokens.get(start + 1)), parseHelper(start + 3, end));
        }
        // not a range to look at, just one index --> it is a variable
        else if (start == end) {
            return variableScanner(tokens.get(start));
        }
        // all other kinds of expressions
        else {
            int oldEnd = end;
            // look right to left and find one "thing" on the right, then recurse with a new
            // application with the range on the left and the one thing on rhe right
            int parenCounter = 0;
            int rightPartStart = end;
            for (int index = end; index >= start; --index) {
                String currentToken = tokens.get(index);
                if (currentToken.equals(")")) {
                    if (parenCounter == 0) {
                        end = index;
                    }
                    ++parenCounter;
                } else if (currentToken.equals("(")) {
                    --parenCounter;
                    if (parenCounter == 0) {
                        rightPartStart = index;
                        break;
                    }
                } else if (parenCounter == 0) {
                    rightPartStart = index;
                    break;
                }
            }
            // one variable is the thing on the right
            if (rightPartStart == end) {
                return new Application(parseHelper(start, rightPartStart - 1), variableScanner(tokens.get(end)));
            }
            // the entire thing was one expression
            else if (rightPartStart == start && end == oldEnd) {
                return parseHelper(start + 1, end - 1);
            } else {
                return new Application(parseHelper(start, rightPartStart - 1),
                        parseHelper(rightPartStart + 1, end - 1));
            }
        }
    }

    /*
     * Main parser method
     */
    public Expression parse(ArrayList<String> tokens) throws ParseException {
        this.tokens = tokens;
        // if the user attempts to assign this expression to a variable, then the
        // variable
        // name is going to be at index 0 and the equal sign is going to be at variable
        // 1
        if (tokens.size() >= 3 && tokens.get(1).equals("=")) {
            String key = tokens.get(0);
            // if the value is already stored in the map, exit without parsing
            if (storedVars.containsKey(key)) {
                return null;
            }
            // otherwise, parse, store parsed expression in map, return parsed expression
            else {
                tokens.remove(0);
                tokens.remove(0);
                // if user is asking to run this function
                boolean isRunning = tokens.get(0).equals("run");
                if (isRunning) {
                    tokens.remove(0);
                }
                preParse();
                Expression value = parseHelper(0, tokens.size() - 1);
                if (isRunning) {
                    value = Runner.run(value);
                }
                storedVars.put(key, value);
                return value;
            }
        }
        // if user is asking to run this function
        boolean isRunning = tokens.get(0).equals("run");
        if (isRunning) {
            tokens.remove(0);
        }
        preParse();
        Expression value = parseHelper(0, tokens.size() - 1);
        if (isRunning) {
            value = Runner.run(value);
        }
        return value;
    }
}
