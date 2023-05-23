/*
Tim Rolshud, David Lee
ATiCS Period 3
June 5, 2023
*/

public class Function implements Expression {
    public Variable variable;
    public Expression expression;

    public Function(Variable variable, Expression expression) {
        this.variable = variable;
        this.expression = expression;
    }

    public String toString() {
        return "(λ" + variable + "." + expression.toString() + ")";
    }

}
