/*
Tim Rolshud, David Lee
ATiCS Period 3
June 5, 2023
*/

public class Variable implements Expression {
    public final String name;

    public Variable(String name) {
        this.name = name;
    }

    public String toString() {
        return name;
    }

    public boolean equals(Variable other) {
        return this.name.equals(other.name);
    }

    public Variable copy() {
        return new Variable(name);
    }
}
