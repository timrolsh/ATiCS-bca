/*
Tim Rolshud, David Lee
ATiCS Period 3
June 6, 2023
*/

// TODO add comments

public class Variable implements Expression {
    public String name;

    public Variable(String name) {
        this.name = name;
    }

    public Variable copy() {
        return new Variable(name);
    }

    public Expression sub(Variable v, Expression e) {
        if (this.equals(v)) {
            return e;
        }
        return this;
    }

    public String toString() {
        return name;
    }

    public boolean equals(Expression other) {
        if (other instanceof Variable var) {
            return this.name.equals(var.name);
        }
        return false;
    }
}
