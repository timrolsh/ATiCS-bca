"""
Tim Rolshud, David Lee
ATiCS Period 3
12 May 2023
Daring Duck Lab
"""
from Transition import Transition


class State:

    def __init__(self, state_dict: dict) -> None:
        self.state_name: str = state_dict["state_name"]
        self.transitions: list[Transition] = []
        for transition_dict in state_dict["transitions"]:
            self.transitions.append(Transition(transition_dict))
