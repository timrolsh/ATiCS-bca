
import java.text.ParseException;
import java.util.ArrayList;

public class Parser {
    // wrap all the lambda functions that aren't already in parentheses in paraetheses to make it easier for the parser to work with
    void preParse(ArrayList<String> tokens) {
        System.out.println("made it here");
        for (int index = 0; index < tokens.size();) {
            if (tokens.get(index))
        }

    }

    /*
     * Turns a set of tokens into an expression. Comment this back in when you're
     * ready.
     */
    public Expression parse(ArrayList<String> tokens) throws ParseException {
        preParse(tokens);
        Variable var = new Variable(tokens.get(0));

        // This is nonsense code, just to show you how to thrown an Exception.
        // To throw it, type "error" at the console.
        if (var.toString().equals("error")) {
            throw new ParseException("User typed \"Error\" as the input!", 0);
        }

        return var;
    }
}
