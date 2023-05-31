// TODO code is a mess clean it up and clean up the comments
import java.util.HashSet;

public class Runner {
    private static int replacementsMade = 1;
    // the variable that you will be substituting for
    private static Variable subVar;
    // the expression that you will be substituting in for the variable
    private static Expression subExp;
    // the set of free variables of outer scopes
    private static HashSet<String> freeVarNames = new HashSet<>();

    private static void addFreeVars(Expression expression) {
        if (expression instanceof Variable variable) {
            freeVarNames.add(variable.name);
        } else if (expression instanceof Application application) {
            addFreeVars(application.left);
            addFreeVars(application.right);
        } else if (expression instanceof Function function) {
            freeVarNames.add(function.variable.name);
            addFreeVars(function.expression);
        }

    }

    // TODO add method description
    private static Expression fvppSubHelper(Expression expression, Variable originalVar, Variable subVar) {
        if (expression instanceof Application subApp) {
            if (subApp.left instanceof Variable variable && variable.equals(originalVar)) {
                subApp.left = subVar.copy();
            } else {
                subApp.left = fvppSubHelper(subApp.left, originalVar, subVar);
            }
            if (subApp.right instanceof Variable variable && variable.equals(originalVar)) {
                subApp.right = subVar.copy();
            } else {
                subApp.right = fvppSubHelper(subApp.right, originalVar, subVar);
            }
            return subApp;
        }
        // function, but variables inside inner sub function should not be touched by
        // this scope
        else if (expression instanceof Function subFunc && !subFunc.variable.equals(originalVar)) {
            subFunc.expression = fvppSubHelper(subFunc.expression, originalVar, subVar);
        }
        // check if its just a variable that that variable is the same as subVar
        else if (expression instanceof Variable subVariable && subVariable.equals(originalVar)) {
            return subVar;
        }
        return expression;
    }

    // TODO write method description. this is implemented as an intermediate step as
    // opposed to an on the go thing during execution of runHelper. runHelper will
    // only work after this has preprocessed everything
    private static Expression freeVarPreParse(Expression expression) {
        // TODO this is broken and does not properly do step 24, run (λy.λx.(x y)) (x x) results in (λx.(x (x x))) and that is the wrong answer
        // if you encounter a redex and application.right is a variable, add that to the
        // set of free variables
        // if you encounter a function and its variable is the same as something in the
        // freeVariables set, replace every instance of that functions local variable
        // with a substituted variable and do a while loop to find an available name
        if (expression instanceof Application application && application.left instanceof Function function) {
            addFreeVars(expression);
            application.left = freeVarPreParse(application.left);
            application.right = freeVarPreParse(application.right);
        } else if (expression instanceof Function function && freeVarNames.contains(function.variable.name)) {
            String oldName = function.variable.name;
            // the new name that will be assigned to the local variable within this function
            String subName = oldName;
            int number = 1;
            while (freeVarNames.contains(subName + number)) {
                ++number;
            }
            subName += number;
            function.expression = fvppSubHelper(function.expression, function.variable, new Variable(subName));
            function.variable = new Variable(subName);
        } else if (expression instanceof Function function) {
            function.expression = freeVarPreParse(function.expression);
        } else if (expression instanceof Application application) {
            application.left = freeVarPreParse(application.left);
            application.right = freeVarPreParse(application.right);
        }
        return expression;
    }

    // TODO write method description
    private static Expression subHelper(Expression exp) {
        if (exp instanceof Application subApp) {
            if (subApp.left instanceof Variable variable && variable.equals(subVar)) {
                subApp.left = subExp.copy();
                ++replacementsMade;
            } else {
                subApp.left = subHelper(subApp.left);
            }
            if (subApp.right instanceof Variable variable && variable.equals(subVar)) {
                subApp.right = subExp.copy();
                ++replacementsMade;
            } else {
                subApp.right = subHelper(subApp.right);
            }
            return subApp;
        }
        // function, but variables inside inner sub function should not be touched by
        // this scope
        else if (exp instanceof Function subFunc && !subFunc.variable.equals(subVar)) {
            subFunc.expression = subHelper(subFunc.expression);
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
            subVar = function.variable;
            subExp = application.right;
            function.expression = runHelper(function.expression);
            expression = subHelper(function.expression);
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
        freeVarNames.clear();
        expression = freeVarPreParse(expression);
        replacementsMade = 1;
        while (replacementsMade != 0) {
            replacementsMade = 0;
            expression = runHelper(expression);
        }
        return expression;
    }
}
