/*
Tim Rolshud, David Lee
ATiCS Period 3
June 6, 2023
*/


public class Function implements Expression {
    public Variable variable;
    public Expression expression;

    public Function(Variable variable, Expression expression) {
        this.variable = variable;
        this.expression = expression;
    }

    public Function copy() {
        return new Function(variable.copy(), expression.copy());
    }

    public Expression sub(Variable oldVar, Expression newExp) {
        if (this.variable.equals(oldVar)) {
            return this;
        } else {
            Function func = this.copy();
            // bounded variable found that matches name of freevar, needs to be swapped
            if (newExp instanceof Variable var && Runner.freeVarNames.contains(var.name)) {
                String newVarName = this.variable.name;
                int counter = 0;
                while (Runner.freeVarNames.contains(newVarName)) {
                    ++counter;
                    newVarName = this.variable.name + counter;
                }
                func.variable.name = newVarName;
                func.expression = func.expression.sub(this.variable, new Variable(newVarName));
            }
            func.expression = func.expression.sub(oldVar, newExp);
            return func;
        }
    }

    public String toString() {
        return "(λ" + variable + "." + expression + ")";
    }

    public boolean equals(Expression other) {
        if (other instanceof Function func) {
            return this.variable.equals(func.variable) && this.expression.equals(func.expression);
        }
        return false;
    }
}
