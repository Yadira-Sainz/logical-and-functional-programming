# Conversión de metros a pies y pies a metros usando funciones puras (Paradigma Funcional)

# Función pura para convertir metros a pies
def meters_to_feet(meters):
    return meters * 3.28084

# Función pura para convertir pies a metros
def feet_to_meters(feet):
    return feet / 3.28084

# Listas de valores a convertir
meters_list = [5, 10, 15]      # Lista de valores en metros
feet_list = [16.4, 32.8, 49.2] # Lista de valores en pies

# Uso de map para aplicar la conversión a cada elemento de la lista (funcional)
converted_to_feet = list(map(meters_to_feet, meters_list))
converted_to_meters = list(map(feet_to_meters, feet_list))

# Mostrar resultados de metros a pies
print("Metros a pies (Funcional):")
for m, f in zip(meters_list, converted_to_feet):
    print(f"{m} metros = {f:.2f} pies")

# Mostrar resultados de pies a metros
print("Pies a metros (Funcional):")
for f, m in zip(feet_list, converted_to_meters):
    print(f"{f} pies = {m:.2f} metros")
