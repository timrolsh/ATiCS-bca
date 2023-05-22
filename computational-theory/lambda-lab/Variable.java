/*
Tim Rolshud, David Lee
ATiCS Period 3
June 5, 2023
*/

public class Variable implements Expression {
	private String name;
	
	public Variable(String name) {
		this.name = name;
	}
	
	public String toString() {
		return name;
	}

}
