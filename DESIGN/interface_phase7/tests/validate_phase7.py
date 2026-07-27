from pathlib import Path
from xml.etree import ElementTree


ROOT = Path(__file__).resolve().parents[1]
REFERENCE_DIR = ROOT / "references"
EXPECTED_IDS = {
    "reticule", "pistolet", "mitraillette", "pompe", "assaut", "precision",
    "lourde", "couteau", "constitution", "gestes", "reflexes", "reparation",
    "noyau", "serum", "relais", "antidote",
}


def fail(message: str) -> None:
    raise SystemExit(f"ECHEC_PHASE7: {message}")


def validate_svg(path: Path) -> ElementTree.Element:
    if not path.is_file():
        fail(f"référence absente: {path.name}")
    try:
        return ElementTree.parse(path).getroot()
    except ElementTree.ParseError as error:
        fail(f"SVG invalide {path.name}: {error}")


def main() -> None:
    inventory = (ROOT / "inventaire_phase7_v1.md").read_text(encoding="utf-8")
    sheets = (ROOT / "fiches_integration_phase7_v1.md").read_text(encoding="utf-8")
    asset_ids = {
        "NP-Z07-BRD-01", "NP-Z07-HUD-01", "NP-Z07-HUD-02", "NP-Z07-HUD-03",
        "NP-Z07-HUD-04", "NP-Z07-HUD-05", "NP-Z07-HUD-06", "NP-Z07-HUD-07",
        "NP-Z07-MNU-01", "NP-Z07-MNU-02", "NP-Z07-MNU-03", "NP-Z07-END-01",
        "NP-Z07-END-02", "NP-Z07-ICO-01", "NP-Z07-ICO-02", "NP-Z07-ICO-03",
    }
    for asset_id in asset_ids:
        if asset_id not in inventory or asset_id not in sheets:
            fail(f"fiche ou inventaire incomplet: {asset_id}")

    planche = validate_svg(REFERENCE_DIR / "planche_interface_phase7_v1.svg")
    if planche.attrib.get("viewBox") != "0 0 1920 1080":
        fail("planche hors référence 1920x1080")
    icons = validate_svg(REFERENCE_DIR / "icones_ui_phase7_v1.svg")
    found_ids = {element.attrib["id"] for element in icons.iter() if "id" in element.attrib}
    missing_ids = EXPECTED_IDS - found_ids
    if missing_ids:
        fail(f"icônes manquantes: {', '.join(sorted(missing_ids))}")
    print(f"NOX_PROTOCOL_PHASE7_DESIGN_VALID ids={len(EXPECTED_IDS)}")


if __name__ == "__main__":
    main()
