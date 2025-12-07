import numpy as np

def main():
    print("numpy test:")
    x = np.linspace(0, 10, 10)
    mean = np.mean(x)
    print(f"Mean of x: {mean:.2f}")
