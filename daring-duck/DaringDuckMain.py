"""
Tim Rolshud, David Lee
ATiCS Period 3
12 May 2023
Daring Duck Lab

**Our stats
Ones: 4098
Number of states: 6
Initial Tape Size: 0
Alphabet Size: 2
Final score: 512.25

Included in the folder is a diagram of the machine that we used. A JSON was used to describe the turing machine, and
that json was then fed into the program and organized into different classes and their parameters and methods. The 
TuringMachine class ties togethee the State and Transition class to run a turing machine and correctly load all of the
data from the JSON. Assuming all of the data from the JSON is correct, this implementation will be able to correctly 
simulate any turing machine. 

This file simply uses the classes implemented to simulate and run a turing machine, and then print out the 
stats and score.
"""
from TuringMachine import TuringMachine

turing_machine: TuringMachine = TuringMachine(
    "./MyTuringMachine.json")
turing_machine.run()
ones: int = 0
for character in turing_machine.tape:
    if character == "1":
        ones += 1
print(f"Ones: {ones}")
states: int = len(turing_machine.states)
print(f"Number of states: {states}")
initial_tape_size: int = len(turing_machine.initial_tape)
print(f"Initial Tape Size: {initial_tape_size}")
alphabet_size: int = turing_machine.alphabet_size
print(f"Alphabet Size: {alphabet_size}")
print(f"Final score: {ones / (states + initial_tape_size + alphabet_size)}")
