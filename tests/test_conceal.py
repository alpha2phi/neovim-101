"""Test conceal."""

x = 1
y = 2

if x >= y:
    print("x >= y")

if 1 in [1,2,3]:
    print("exists")

def sum(x: int, y: float) -> float:
    return x + y

print(sum(100,200))
