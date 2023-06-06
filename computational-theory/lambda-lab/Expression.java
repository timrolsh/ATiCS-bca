/*
Tim Rolshud, David Lee
ATiCS Period 3
June 6, 2023
*/


public interface Expression {
    // return an exact copy of this expression
    public Expression copy();

    // substitute variable in for this expression
    public Expression sub(Variable v, Expression e);

    public boolean equals(Expression other);
}
