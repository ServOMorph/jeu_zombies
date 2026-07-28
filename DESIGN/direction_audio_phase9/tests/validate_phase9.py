from pathlib import Path
import re
import sys


ROOT = Path(__file__).resolve().parents[1]
INVENTORY = ROOT / "inventaire_audio_phase9_v1.md"
SPECS = ROOT / "fiches_integration_audio_phase9_v1.md"
PALETTE = ROOT / "palette_sonore_phase9_v1.md"
DELIVERY = ROOT / "bordereau_transmission_phase9.md"


def fail(message: str) -> None:
    print(f"ERREUR: {message}")
    sys.exit(1)


def main() -> None:
    for file_path in (INVENTORY, SPECS, PALETTE, DELIVERY):
        if not file_path.is_file():
            fail(f"fichier absent: {file_path.name}")

    inventory = INVENTORY.read_text(encoding="utf-8")
    identifiers = re.findall(r"`(NP-A09-[A-Z]+-\d{2})`", inventory)
    if len(identifiers) != 47 or len(set(identifiers)) != 47:
        fail(f"inventaire invalide: {len(identifiers)} identifiants, 47 attendus")

    for prefix, expected in (("WPN", 15), ("IMP", 3), ("ZMB", 5), ("INT", 7), ("QST", 5), ("UI", 5), ("AMB", 5), ("MUS", 2)):
        count = sum(identifier.startswith(f"NP-A09-{prefix}-") for identifier in identifiers)
        if count != expected:
            fail(f"famille {prefix} invalide: {count}, {expected} attendus")

    specs = SPECS.read_text(encoding="utf-8")
    for required in ("48 kHz", "BodyVisual", "InteractionAnchor", "32", "6", "-1 dBFS"):
        if required not in specs:
            fail(f"contrainte absente: {required}")

    palette = PALETTE.read_text(encoding="utf-8")
    for zone in ("Accueil", "Confinement", "Entrepôt médical", "Synthèse", "Extraction"):
        if zone not in palette:
            fail(f"zone absente: {zone}")

    print("NOX_PROTOCOL_PHASE9_SPEC_VALIDATION_READY cues=47 zones=5")


if __name__ == "__main__":
    main()
