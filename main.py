def greet(name: str) -> str:
    """Kembalikan sapaan ramah untuk nama yang diberikan."""
    return f"Halo, {name}! Selamat datang di Proyek Terlindungi."


def add(a: float, b: float) -> float:
    """Jumlahkan dua bilangan."""
    return a + b


if __name__ == "__main__":
    print(greet("Tamu"))
    print("2 + 3 =", add(2, 3))
