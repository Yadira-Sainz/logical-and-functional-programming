# Conversión de metros a pies y pies a metros usando orientación a objetos (Paradigma OO)

class UnitConverter:
    # Constructor que recibe la cantidad en metros
    def __init__(self, meters):
        self.meters = meters

    # Método de instancia para convertir metros a pies
    def to_feet(self):
        return self.meters * 3.28084

    # Método estático para convertir pies a metros
    @staticmethod
    def feet_to_meters(feet):
        return feet / 3.28084

# Lista de objetos UnitConverter con diferentes valores en metros
converters = [UnitConverter(5), UnitConverter(10), UnitConverter(15)]

# Mostrar resultados de metros a pies usando el método de instancia
print("Metros a pies (OOP):")
for converter in converters:
    print(f"{converter.meters} metros = {converter.to_feet():.2f} pies")

# Lista de valores en pies para convertir a metros
feet_values = [16.4, 32.8, 49.2]

# Mostrar resultados de pies a metros usando el método estático
print("Pies a metros (OOP):")
for feet in feet_values:
    print(f"{feet} pies = {UnitConverter.feet_to_meters(feet):.2f} metros")
