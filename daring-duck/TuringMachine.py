"""
Tim Rolshud, David Lee
ATiCS Period 3
12 May 2023
Daring Duck Lab
"""
import json
from State import State


class TuringMachine:
    def __init__(self, json_path_string: str) -> None:
        self.states: list[State] = []
        self.state_names: dict[str, State] = {}
        with open(json_path_string) as file:
            json_data: dict = json.load(file)
            self.null_character: str = json_data["null_character"]
            self.alphabet_size: int = len(json_data["alphabet"])
            self.initial_tape: str = json_data["initial_tape"]
            for state_dict in json_data["states"]:
                state: State = State(state_dict)
                self.states.append(state)
                self.state_names[state.state_name] = state
            self.start_state: State = self.state_names[json_data["start_state"]]
            self.halt_states: list[State] = []
            for state_name_string in json_data["halt_states"]:
                self.halt_states.append(self.state_names[state_name_string])
        # start off with a tape size of 1000, expand throughout the runtime of the program, triple in size every time you expand
        self.tape: list[str]
        if self.initial_tape != "":
            self.tape = [char for char in self.initial_tape]
        else:
            self.tape = ["0" for _ in range(1000)]
        self.head_index: int = len(self.tape) // 2
        self.current_state: State = self.start_state

    # return whether an index is valid with the size of the current tape
    def valid_index(self) -> bool:
        return self.head_index >= 0 and self.head_index < len(self.tape)

    # expand the size of the tape
    def expand_tape(self) -> None:
        current_length: int = len(self.tape)
        expand_buffer: list[str] = ["0" for _ in range(current_length)]
        self.tape = expand_buffer + self.tape + expand_buffer
        self.head_index += current_length

    def read(self) -> str:
        # if index is not valid with the size of the current tape, exoand the current tape
        if not self.valid_index():
            self.expand_tape()
        return self.tape[self.head_index]

    def write(self, character: str) -> None:
        self.tape[self.head_index] = character

    def run(self) -> None:
        while self.current_state not in self.halt_states:
            current_character: str = self.read()
            for transition in self.current_state.transitions:
                if transition.read == current_character:
                    self.write(transition.write)
                    self.current_state = self.state_names[transition.next_state_str]
                    if transition.direction_right:
                        self.head_index += 1
                    else:
                        self.head_index -= 1
