"""
Tim Rolshud, David Lee
ATiCS Period 3
12 May 2023
Daring Duck Lab
"""
class Transition:
    def __init__(self, transiton_dict: dict) -> None:
        self.read: str = transiton_dict["read"]
        self.write: str = transiton_dict["write"]
        self.direction_right: bool = transiton_dict["direction_right"]
        self.next_state_str: str = transiton_dict["next_state"]
