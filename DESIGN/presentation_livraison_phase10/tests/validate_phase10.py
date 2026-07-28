from pathlib import Path
import sys


ROOT = Path(__file__).resolve().parents[1]
REGISTRY = ROOT / "registre_lots_phase10_v1.md"
GAPS = ROOT / "ecarts_et_placeholders_phase10_v1.md"
GUIDE = ROOT / "guide_coherence_finale_phase10_v1.md"
DELIVERY = ROOT / "bordereau_consolide_phase10.md"
SHEET = ROOT / "references" / "planche_finale_phase10_v1.svg"


def fail(message: str) -> None:
    print(f"ERREUR: {message}")
    sys.exit(1)


def main() -> None:
    for file_path in (REGISTRY, GAPS, GUIDE, DELIVERY, SHEET):
        if not file_path.is_file():
            fail(f"fichier absent: {file_path.name}")

    registry = REGISTRY.read_text(encoding="utf-8")
    for phase in range(1, 10):
        if f"| {phase} |" not in registry:
            fail(f"phase absente du registre: {phase}")
    for anchor in ("BodyVisual", "WeaponVisualRoot", "MuzzleFlash", "InteractionAnchor"):
        if anchor not in registry:
            fail(f"contrat absent: {anchor}")

    gaps = GAPS.read_text(encoding="utf-8")
    for gap in ("NP-P10-01", "NP-P10-02", "NP-P10-03"):
        if gap not in gaps:
            fail(f"écart absent: {gap}")

    guide = GUIDE.read_text(encoding="utf-8")
    for required in ("96 particules", "48 quads", "32 voix mono 3D", "-1 dBFS", "50 FPS"):
        if required not in guide:
            fail(f"contrainte absente: {required}")

    sheet = SHEET.read_text(encoding="utf-8")
    for group in ("environnement", "zombie", "arsenal", "interactions", "interface", "effets_audio"):
        if f'id="{group}"' not in sheet:
            fail(f"groupe SVG absent: {group}")

    print("NOX_PROTOCOL_PHASE10_SPEC_VALIDATION_READY phases=9 gaps=3 panels=6")


if __name__ == "__main__":
    main()
