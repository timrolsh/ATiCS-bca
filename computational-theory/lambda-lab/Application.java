/*
Tim Rolshud, David Lee
ATiCS Period 3
June 5, 2023
*/

public class Application implements Expression {
    public Expression left;
    public Expression right;

    public Application(Expression left, Expression right) {
        this.left = left;
        this.right = right;
    }

    public String toString() {
        return "(" + this.left + " " + this.right + ")";
    }

}
