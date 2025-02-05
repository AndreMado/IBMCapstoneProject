import json
import os


script_dir = os.path.dirname(os.path.abspath(__file__))


input_file = os.path.join(script_dir, "../data/catalog.json")
output_file = os.path.join(script_dir, "../data/catalog_fixed.json")


with open(input_file, "r", encoding="utf-8") as file:
    data = file.readlines()


documents = []
for line in data:
    try:
        doc = json.loads(line.strip())  # Convertir a JSON válido
        documents.append(doc)
    except json.JSONDecodeError as e:
        print(f"Error al procesar línea: {line.strip()} - {e}")


with open(output_file, "w", encoding="utf-8") as file:
    json.dump(documents, file, indent=4)

print(f"Archivo corregido guardado en: {output_file}")
