from pathlib import Path
import re
import sys


ROOT = Path(__file__).resolve().parents[1]
INVENTORY = ROOT / "inventaire_phase8_v1.md"
SPECS = ROOT / "fiches_integration_phase8_v1.md"
SHEET = ROOT / "references" / "planche_effets_phase8_v1.svg"


def fail(message: str) -> None:
    print(f"ERREUR: {message}")
    sys.exit(1)


def main() -> None:
    for file_path in (INVENTORY, SPECS, SHEET):
        if not file_path.is_file():
            fail(f"fichier absent: {file_path.name}")

    inventory = INVENTORY.read_text(encoding="utf-8")
    identifiers = re.findall(r"`(NP-Z08-[A-Z]+-\d{2})`", inventory)
    if len(identifiers) != 18 or len(set(identifiers)) != 18:
        fail(f"inventaire invalide: {len(identifiers)} identifiants, 18 attendus")

    specs = SPECS.read_text(encoding="utf-8")
    for required in ("MuzzleFlash", "BodyVisual", "InteractionAnchor", "96", "48", "1,20 s"):
        if required not in specs:
            fail(f"contrainte absente: {required}")

    sheet = SHEET.read_text(encoding="utf-8")
    for reference in ("flash", "fumee", "impact-metal", "impact-beton", "impact-organique", "melee", "degats", "zombie", "interaction", "porte", "quete", "extraction"):
        if f'id="{reference}"' not in sheet:
            fail(f"référence SVG absente: {reference}")

    print("NOX_PROTOCOL_PHASE8_SPEC_VALIDATION_READY effects=18 references=12")


if __name__ == "__main__":
    main()
