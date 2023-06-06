/*
Tim Rolshud, David Lee
ATiCS Period 3
June 6, 2023
*/

public interface Expression {
    // return an exact copy of this expression
    Expression copy();

    // substitute variable in for this expression
    Expression sub(Variable v, Expression e);

    // return whether this expression is equal to another expression
    boolean equals(Expression other);
}
