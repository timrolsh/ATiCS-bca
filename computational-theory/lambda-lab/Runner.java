public class Runner {
    private static int replacementsMade = 1;
    // the variable that you will be substituing for
    private static Variable subVar;
    // the expression that you will be substituting in for the variable
    private static Expression subExp;

    // TODO write method description
    private static Expression substituteHelper(Expression exp) {

        if (exp instanceof Application subApp) {
            if (subApp.left instanceof Variable variable && variable.equals(subVar)) {
                subApp.left = subExp.copy();
                ++replacementsMade;
            } else {
                subApp.left = substituteHelper(subApp.left);
            }
            if (subApp.right instanceof Variable variable && variable.equals(subVar)) {
                subApp.right = subExp.copy();
                ++replacementsMade;
            } else {
                subApp.right = substituteHelper(subApp.right);
            }
            return subApp;
        }
        // function
        else if (exp instanceof Function subFunc) {
            subFunc.expression = substituteHelper(subFunc.expression);
        }
        // check if its just a variable that that variable is the same as subVar
        else if (exp instanceof Variable subVariable && subVariable.equals(subVar)) {
            return subExp;
        }
        return exp;
    }

    // do a preorder traversal of the tree made from
    private static Expression runHelper(Expression expression) {
        // if we encounter a redex (current node is an application and its left child
        // exists and is a function)
        if (expression instanceof Application application && application.left instanceof Function function) {
            Variable variable = function.variable;
            if (function.expression instanceof Application funcApp) {
                runHelper(funcApp);
                subVar = variable;
                subExp = application.right;
                expression = substituteHelper(funcApp);
            }
            // variable
            else if (function.expression instanceof Variable funcVar && funcVar.equals(variable)) {
                ++replacementsMade;
                return application.right;
            }
            // function, cannot substitute anything into it in this scope, just bring out the function
            else if (function.expression instanceof Function){
                expression = function.expression;
            }

        }
        // if expression is application, recurse through the left and right of it to
        // check for things in more inner scopes to evaluate
        else if (expression instanceof Application application) {
            application.left = runHelper(application.left);
            application.right = runHelper(application.right);
        }
        if (expression instanceof Application application && application.right == null) {
            return application.left;
        }
        return expression;
    }

    // the only things that change when they run are applications with left being a
    // function
    public static Expression run(Expression expression) {
        replacementsMade = 1;
        while (replacementsMade != 0) {
            replacementsMade = 0;
            expression = runHelper(expression);
        }
        return expression;
    }

}
