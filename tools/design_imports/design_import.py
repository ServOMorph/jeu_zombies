from __future__ import annotations

import argparse
import datetime as dt
import hashlib
import json
import os
import re
import shutil
import struct
import sys
import tempfile
import xml.etree.ElementTree as element_tree
from pathlib import Path
from typing import Any, Iterable


SCHEMA_VERSION = 1
ALLOWED_STATUSES = {
    "detecte", "precontrole_ok", "approuve", "a_regenerer", "a_revoir",
    "bloque", "refuse", "archive", "importe", "valide", "retour_arriere",
}
ALLOWED_ACTIONS = {"ajouter", "remplacer", "inchangé", "retirer"}
ENTRY_FIELDS = {
    "design_id", "lot_id", "source_path", "source_hash", "source_version",
    "asset_type", "license_status", "design_status", "target_paths",
    "current_hashes", "action", "consumers", "contracts", "import_settings",
    "validation_commands", "archive_run_id", "integration_status",
    "last_validated_at", "decision", "decision_at", "notes",
}
TRANSITIONS = {
    "detecte": {"precontrole_ok", "a_regenerer", "a_revoir", "bloque", "refuse"},
    "precontrole_ok": {"approuve", "a_regenerer", "a_revoir", "bloque", "refuse"},
    "approuve": {"archive", "a_regenerer", "a_revoir", "bloque", "refuse"},
    "archive": {"importe", "retour_arriere", "a_revoir", "bloque"},
    "importe": {"valide", "retour_arriere", "a_revoir", "bloque"},
    "valide": {"retour_arriere", "a_revoir", "bloque"},
    "retour_arriere": {"precontrole_ok", "a_revoir", "bloque"},
    "a_regenerer": {"detecte", "a_revoir", "bloque", "refuse"},
    "a_revoir": {"precontrole_ok", "a_regenerer", "bloque", "refuse"},
    "bloque": {"precontrole_ok", "a_revoir", "refuse"},
    "refuse": set(),
}
DEFAULT_EXTENSIONS = {".glb", ".tres", ".svg"}


class DesignImportError(RuntimeError):
    pass


def now_utc() -> str:
    return dt.datetime.now(dt.timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ")


def sha256_file(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as source:
        for block in iter(lambda: source.read(1024 * 1024), b""):
            digest.update(block)
    return digest.hexdigest()


def canonical_json(payload: Any) -> bytes:
    return (json.dumps(payload, ensure_ascii=False, indent=2, sort_keys=True) + "\n").encode("utf-8")


def atomic_write(path: Path, payload: bytes) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with tempfile.NamedTemporaryFile(dir=path.parent, prefix=f".{path.name}.", delete=False) as handle:
        temporary = Path(handle.name)
        handle.write(payload)
        handle.flush()
        os.fsync(handle.fileno())
    try:
        os.replace(temporary, path)
    finally:
        if temporary.exists():
            temporary.unlink()


def is_within(path: Path, root: Path) -> bool:
    try:
        path.resolve().relative_to(root.resolve())
        return True
    except ValueError:
        return False


def repo_path(root: Path, value: str, *, field: str) -> Path:
    candidate = Path(value)
    if candidate.is_absolute():
        raise DesignImportError(f"{field}: chemin absolu interdit: {value}")
    resolved = (root / candidate).resolve()
    if not is_within(resolved, root):
        raise DesignImportError(f"{field}: chemin hors dépôt: {value}")
    return resolved


def relative_path(root: Path, path: Path) -> str:
    return path.resolve().relative_to(root.resolve()).as_posix()


def registry_template() -> dict[str, Any]:
    return {"schema_version": SCHEMA_VERSION, "updated_at": None, "designs": []}


def load_json(path: Path) -> dict[str, Any]:
    try:
        with path.open(encoding="utf-8") as handle:
            value = json.load(handle)
    except (OSError, json.JSONDecodeError) as error:
        raise DesignImportError(f"JSON illisible: {path}: {error}") from error
    if not isinstance(value, dict):
        raise DesignImportError(f"JSON racine invalide: {path}")
    return value


def load_registry(path: Path, root: Path) -> dict[str, Any]:
    registry = registry_template() if not path.exists() else load_json(path)
    validate_registry(registry, root)
    return registry


def validate_registry(registry: dict[str, Any], root: Path) -> None:
    if set(registry) != {"schema_version", "updated_at", "designs"}:
        raise DesignImportError("Registre: champs racine invalides")
    if registry["schema_version"] != SCHEMA_VERSION:
        raise DesignImportError("Registre: version de schéma non prise en charge")
    if registry["updated_at"] is not None and not isinstance(registry["updated_at"], str):
        raise DesignImportError("Registre: updated_at invalide")
    designs = registry["designs"]
    if not isinstance(designs, list):
        raise DesignImportError("Registre: designs doit être une liste")
    identifiers: set[str] = set()
    source_paths: set[str] = set()
    for entry in designs:
        validate_entry(entry, root)
        design_id = entry["design_id"]
        if design_id in identifiers:
            raise DesignImportError(f"Registre: design_id dupliqué: {design_id}")
        if entry["source_path"] in source_paths:
            raise DesignImportError(f"Registre: source_path dupliqué: {entry['source_path']}")
        identifiers.add(design_id)
        source_paths.add(entry["source_path"])


def validate_entry(entry: Any, root: Path) -> None:
    if not isinstance(entry, dict) or set(entry) != ENTRY_FIELDS:
        raise DesignImportError("Registre: champs d'entrée invalides")
    for field in ("design_id", "lot_id", "source_path", "source_hash", "source_version", "asset_type", "license_status", "design_status", "action", "integration_status"):
        if not isinstance(entry[field], str) or not entry[field]:
            raise DesignImportError(f"Registre: {field} invalide")
    if not isinstance(entry["notes"], str):
        raise DesignImportError("Registre: notes invalide")
    if not re.fullmatch(r"[a-z0-9][a-z0-9._:-]*", entry["design_id"]):
        raise DesignImportError(f"Registre: design_id invalide: {entry['design_id']}")
    if not re.fullmatch(r"[0-9a-f]{64}", entry["source_hash"]):
        raise DesignImportError(f"Registre: empreinte source absente ou invalide: {entry['design_id']}")
    if entry["design_status"] not in ALLOWED_STATUSES:
        raise DesignImportError(f"Registre: statut invalide: {entry['design_status']}")
    if entry["action"] not in ALLOWED_ACTIONS:
        raise DesignImportError(f"Registre: action invalide: {entry['action']}")
    repo_path(root, entry["source_path"], field="source_path")
    for target in entry["target_paths"]:
        if not isinstance(target, str):
            raise DesignImportError("Registre: target_paths invalide")
        repo_path(root, target, field="target_paths")
    for key in ("target_paths", "current_hashes", "consumers", "contracts", "validation_commands"):
        if not isinstance(entry[key], list):
            raise DesignImportError(f"Registre: {key} doit être une liste")
        if not all(isinstance(value, str) for value in entry[key]):
            raise DesignImportError(f"Registre: {key} contient une valeur invalide")
    if not isinstance(entry["import_settings"], dict):
        raise DesignImportError("Registre: import_settings doit être un objet")
    for key in ("archive_run_id", "last_validated_at", "decision", "decision_at"):
        if entry[key] is not None and not isinstance(entry[key], str):
            raise DesignImportError(f"Registre: {key} invalide")


def save_registry(path: Path, registry: dict[str, Any], root: Path) -> None:
    validate_registry(registry, root)
    atomic_write(path, canonical_json(registry))


def transition(entry: dict[str, Any], new_status: str) -> None:
    old_status = entry["design_status"]
    if new_status not in TRANSITIONS.get(old_status, set()):
        raise DesignImportError(f"Transition interdite: {entry['design_id']}: {old_status} -> {new_status}")
    entry["design_status"] = new_status


def asset_type(path: Path) -> str:
    return {".glb": "modele_3d", ".tres": "ressource_godot", ".svg": "vectoriel"}.get(path.suffix.lower(), "fichier")


def read_glb(path: Path) -> dict[str, Any]:
    raw = path.read_bytes()
    if len(raw) < 20:
        raise DesignImportError("GLB trop court")
    magic, version, length = struct.unpack_from("<4sII", raw, 0)
    if magic != b"glTF" or version != 2 or length != len(raw):
        raise DesignImportError("En-tête GLB invalide")
    chunk_length, chunk_type = struct.unpack_from("<I4s", raw, 12)
    if chunk_type != b"JSON" or 20 + chunk_length > len(raw):
        raise DesignImportError("Chunk JSON GLB invalide")
    try:
        return json.loads(raw[20:20 + chunk_length].decode("utf-8").rstrip(" \t\r\n\x00"))
    except (UnicodeDecodeError, json.JSONDecodeError) as error:
        raise DesignImportError(f"JSON GLB invalide: {error}") from error


def glb_bounds(document: dict[str, Any]) -> dict[str, list[float]] | None:
    accessors = document.get("accessors", [])
    minimum: list[float] | None = None
    maximum: list[float] | None = None
    for mesh in document.get("meshes", []):
        for primitive in mesh.get("primitives", []):
            position = primitive.get("attributes", {}).get("POSITION")
            if not isinstance(position, int) or not 0 <= position < len(accessors):
                continue
            accessor = accessors[position]
            lower, upper = accessor.get("min"), accessor.get("max")
            if accessor.get("type") != "VEC3" or not isinstance(lower, list) or not isinstance(upper, list):
                continue
            if len(lower) != 3 or len(upper) != 3:
                continue
            values_low = [float(value) for value in lower]
            values_high = [float(value) for value in upper]
            minimum = values_low if minimum is None else [min(a, b) for a, b in zip(minimum, values_low)]
            maximum = values_high if maximum is None else [max(a, b) for a, b in zip(maximum, values_high)]
    if minimum is None or maximum is None:
        return None
    return {"min": minimum, "max": maximum, "dimensions": [round(high - low, 6) for low, high in zip(minimum, maximum)]}


def glb_metadata(path: Path) -> dict[str, Any]:
    document = read_glb(path)
    nodes = document.get("nodes", [])
    images = document.get("images", [])
    accessors = document.get("accessors", [])
    dependencies = sorted({image["uri"] for image in images if isinstance(image, dict) and isinstance(image.get("uri"), str)})
    scales = [node.get("name", f"node_{index}") for index, node in enumerate(nodes) if isinstance(node, dict) and node.get("scale", [1, 1, 1]) != [1, 1, 1]]
    triangles = 0
    for mesh in document.get("meshes", []):
        for primitive in mesh.get("primitives", []):
            index = primitive.get("indices")
            if isinstance(index, int) and 0 <= index < len(accessors) and isinstance(accessors[index].get("count"), int):
                triangles += accessors[index]["count"] // 3
    return {
        "format": "glb_v2", "meshes": len(document.get("meshes", [])), "materials": len(document.get("materials", [])),
        "textures": len(document.get("textures", [])), "external_dependencies": dependencies,
        "skins": len(document.get("skins", [])), "animations": [item.get("name", f"animation_{index}") for index, item in enumerate(document.get("animations", []))],
        "root_nodes": [item.get("name", f"node_{index}") for index, item in enumerate(nodes) if isinstance(item, dict) and item.get("name")],
        "non_unit_scale_nodes": scales, "triangles_indexed": triangles, "bounds_locales": glb_bounds(document),
    }


def tres_metadata(path: Path) -> dict[str, Any]:
    try:
        content = path.read_text(encoding="utf-8")
    except UnicodeDecodeError as error:
        raise DesignImportError(f"TRES non UTF-8: {error}") from error
    header = next((line for line in content.splitlines() if line.startswith("[gd_resource")), "")
    match = re.search(r'type="([^"]+)"', header)
    return {"format": "tres", "resource_type": match.group(1) if match else None, "external_dependencies": sorted(set(re.findall(r'res://[^\"]+', content)))}


def svg_metadata(path: Path) -> dict[str, Any]:
    try:
        root = element_tree.parse(path).getroot()
    except element_tree.ParseError as error:
        raise DesignImportError(f"SVG invalide: {error}") from error
    return {"format": "svg", "root": root.tag, "view_box": root.attrib.get("viewBox"), "width": root.attrib.get("width"), "height": root.attrib.get("height")}


def classify_target(root: Path, entry: dict[str, Any]) -> tuple[str, list[dict[str, Any]]]:
    targets = []
    for value in entry["target_paths"]:
        target = repo_path(root, value, field="target_paths")
        targets.append({"path": value, "exists": target.exists(), "sha256": sha256_file(target) if target.exists() else None})
    if not targets:
        return "destination_inconnue", targets
    if all(not target["exists"] for target in targets):
        return "ajout", targets
    if all(target["sha256"] == entry["source_hash"] for target in targets):
        return "inchangé", targets
    return "remplacement", targets


PHASE1_DIMENSIONS = {
    "01-sol-droit": [2.0, 0.12, 2.0], "02-sol-angle": [2.0, 0.12, 2.0], "03-sol-bord": [2.0, 0.12, 2.0], "04-sol-transition": [2.0, 0.12, 1.0],
    "05-mur-plein": [2.0, 3.5, 0.2], "06-demi-mur": [1.0, 3.5, 0.2], "07-angle-interieur": [2.0, 3.5, 2.0], "08-angle-exterieur": [2.0, 3.5, 2.0],
    "09-terminaison-mur": [0.2, 3.5, 2.0], "10-plafond-plein": [2.0, 0.18, 2.0], "11-plafond-technique": [2.0, 0.18, 2.0], "12-plafond-transition": [2.0, 0.18, 1.0],
    "13-encadrement-simple": [4.0, 3.5, 0.22], "14-encadrement-double": [8.0, 3.5, 0.22], "15-porte-accueil-couloirs": [4.0, 3.5, 0.35], "16-porte-couloirs-entrepot": [4.0, 3.5, 0.35],
    "17-porte-couloirs-laboratoire": [4.0, 3.5, 0.35], "18-porte-entrepot-extraction": [4.0, 3.5, 0.35], "19-porte-laboratoire-extraction": [4.0, 3.5, 0.35],
    "20-pilier": [0.3, 3.5, 0.3], "21-poutre": [2.0, 0.3, 0.3], "22-couvre-joint-vertical": [0.08, 3.5, 0.1], "23-couvre-joint-horizontal": [2.0, 0.08, 0.1],
}
REQUIRED_ZOMBIE_ANIMATIONS = {"spawn", "idle", "walk", "chase", "attack", "hit_reaction", "death", "disable"}
REQUIRED_WEAPON_ANIMATIONS = {"equip", "tir", "recul", "rechargement", "melee"}


def matches_dimensions(actual: list[float] | None, expected: list[float]) -> bool:
    return actual is not None and len(actual) == len(expected) and all(abs(left - right) <= 0.001 for left, right in zip(actual, expected))


def contract_checks(entry: dict[str, Any], metadata: dict[str, Any]) -> dict[str, Any]:
    issues: list[str] = []
    pending: list[str] = ["axes et pivot à confirmer par montage isolé"] if entry["asset_type"] == "modele_3d" else []
    if entry["lot_id"] == "phase1":
        suffix = entry["design_id"].split("np-kms-", 1)[-1]
        expected = PHASE1_DIMENSIONS.get(suffix)
        actual = (metadata.get("bounds_locales") or {}).get("dimensions")
        if expected and not matches_dimensions(actual, expected):
            issues.append(f"dimensions exportées {actual} != dimensions nominales {expected}")
        maximum_materials = 4 if suffix[:2] in {"15", "16", "17", "18", "19"} else 3
        if metadata.get("materials", 0) > maximum_materials:
            issues.append(f"{metadata['materials']} matériaux > budget {maximum_materials}")
    elif entry["lot_id"] == "phase2":
        if entry["asset_type"] == "ressource_godot" and metadata.get("resource_type") != "StandardMaterial3D":
            issues.append("ressource différente de StandardMaterial3D")
        if entry["asset_type"] == "vectoriel" and not str(metadata.get("root", "")).endswith("svg"):
            issues.append("racine SVG absente")
    elif entry["lot_id"] == "phase4":
        if metadata.get("materials", 0) > 4:
            issues.append(f"{metadata['materials']} matériaux > budget 4")
        if metadata.get("skins") != 1:
            issues.append("squelette unique requis")
        missing = sorted(REQUIRED_ZOMBIE_ANIMATIONS - set(metadata.get("animations", [])))
        if missing:
            issues.append(f"clips absents: {', '.join(missing)}")
        dimensions = (metadata.get("bounds_locales") or {}).get("dimensions")
        if dimensions and (dimensions[0] > 0.74 or dimensions[2] > 0.48):
            issues.append("enveloppe visuelle trop grande")
        if metadata.get("triangles_indexed", 0) > 4500:
            issues.append("budget de triangles dépassé")
    elif entry["lot_id"] == "phase5" and entry["design_id"].split(":", 1)[1] not in {"np-z05-bras-scientifique", "np-z05-presentation-murale", "np-z05-silhouette-sol"}:
        roots = set(metadata.get("root_nodes", []))
        missing_roots = {"WeaponVisualRoot", "MuzzleFlash"} - roots
        missing_clips = REQUIRED_WEAPON_ANIMATIONS - set(metadata.get("animations", []))
        if missing_roots:
            issues.append(f"ancrages absents: {', '.join(sorted(missing_roots))}")
        if missing_clips:
            issues.append(f"clips absents: {', '.join(sorted(missing_clips))}")
    if metadata.get("external_dependencies"):
        issues.append("dépendances externes non transférées")
    return {"automatique_ok": not issues, "issues": issues, "a_qualifier_di3": pending}


def inventory_entry(root: Path, entry: dict[str, Any], duplicate_hashes: set[str]) -> dict[str, Any]:
    source = repo_path(root, entry["source_path"], field="source_path")
    if not source.exists() or sha256_file(source) != entry["source_hash"]:
        raise DesignImportError(f"Source dérivée: {entry['design_id']}")
    technical = {".glb": glb_metadata, ".tres": tres_metadata, ".svg": svg_metadata}.get(source.suffix.lower())
    if technical is None:
        raise DesignImportError(f"Format non pris en charge: {source}")
    classification, targets = classify_target(root, entry)
    metadata = technical(source)
    return {
        "design_id": entry["design_id"], "lot_id": entry["lot_id"], "source_path": entry["source_path"],
        "source_hash": entry["source_hash"], "source_version": entry["source_version"], "asset_type": entry["asset_type"],
        "license_status": entry["license_status"], "classification": classification, "action": entry["action"],
        "destinations": targets, "consumers": entry["consumers"], "contracts": entry["contracts"], "validation_commands": entry["validation_commands"],
        "checks": {"presence": True, "hash_registre": True, "format_lisible": True, "licence_proprietaire": entry["license_status"] == "proprietaire", "doublon_source": entry["source_hash"] in duplicate_hashes, "dependances_externes": metadata.get("external_dependencies", []), "echelle_unitaire": not metadata.get("non_unit_scale_nodes", []), "contract": contract_checks(entry, metadata)},
        "technical": metadata,
    }


def build_inventory(registry: dict[str, Any], root: Path, run_id: str) -> dict[str, Any]:
    if not re.fullmatch(r"[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{6}Z_[a-z0-9._-]+_[0-9a-f]{8,64}", run_id):
        raise DesignImportError(f"run_id invalide: {run_id}")
    duplicate_hashes = {value for value in {item["source_hash"] for item in registry["designs"]} if sum(item["source_hash"] == value for item in registry["designs"]) > 1}
    designs = [inventory_entry(root, entry, duplicate_hashes) for entry in sorted(registry["designs"], key=lambda item: item["design_id"])]
    counts: dict[str, int] = {}
    for item in designs:
        counts[item["classification"]] = counts.get(item["classification"], 0) + 1
    return {"schema_version": SCHEMA_VERSION, "run_id": run_id, "registry_sha256": registry_digest(registry), "designs": designs, "classification_counts": counts}


def render_plan_markdown(inventory: dict[str, Any]) -> str:
    lines = ["# Plan d’import", "", f"- Run : `{inventory['run_id']}`", f"- Empreinte du registre : `{inventory['registry_sha256']}`", "", "## Synthèse", ""]
    lines.extend(f"- {key} : {value}" for key, value in sorted(inventory["classification_counts"].items()))
    lines.extend(["", "## Candidats", ""])
    for item in inventory["designs"]:
        destinations = ", ".join(target["path"] for target in item["destinations"]) or "destination inconnue"
        risks = ["qualification contractuelle DI.3 requise"]
        if item["classification"] == "destination_inconnue":
            risks.insert(0, "destination à définir")
        if item["checks"]["dependances_externes"]:
            risks.insert(0, "dépendances externes")
        contract = item["checks"]["contract"]
        control = "OK" if contract["automatique_ok"] else f"écarts: {'; '.join(contract['issues'])}"
        lines.extend([f"### {item['design_id']}", "", f"- Source : `{item['source_path']}` (`{item['source_hash']}`)", f"- Destination : `{destinations}`", f"- Classement : {item['classification']}", f"- Action : {item['action']}", f"- Consommateurs : {', '.join(item['consumers']) or 'aucun détecté'}", f"- Contrôles automatiques : {control}", f"- Risques : {', '.join(risks)}", ""])
    return "\n".join(lines)


def make_design_id(lot_id: str, source: Path, source_root: Path) -> str:
    suffix = source.relative_to(source_root).with_suffix("").as_posix().lower()
    slug = re.sub(r"[^a-z0-9]+", "-", suffix).strip("-")
    return f"{lot_id}:{slug}"


def base_entry(root: Path, lot_id: str, source: Path, source_root: Path, target_root: str | None, license_status: str, contracts: list[str] | None = None, validation_commands: list[str] | None = None) -> dict[str, Any]:
    target_paths: list[str] = []
    if target_root:
        target = repo_path(root, target_root, field="target_root") / source.relative_to(source_root)
        target_paths = [relative_path(root, target)]
    return {
        "design_id": make_design_id(lot_id, source, source_root),
        "lot_id": lot_id,
        "source_path": relative_path(root, source),
        "source_hash": sha256_file(source),
        "source_version": "1",
        "asset_type": asset_type(source),
        "license_status": license_status,
        "design_status": "detecte",
        "target_paths": target_paths,
        "current_hashes": [],
        "action": "ajouter",
        "consumers": [],
        "contracts": contracts or [],
        "import_settings": {},
        "validation_commands": validation_commands or [],
        "archive_run_id": None,
        "integration_status": "non_importe",
        "last_validated_at": None,
        "decision": None,
        "decision_at": None,
        "notes": "",
    }


def scan(registry: dict[str, Any], root: Path, lot_id: str, source_value: str, target_root: str | None, extensions: set[str], license_status: str, contracts: list[str], validation_commands: list[str]) -> bool:
    source_value_path = repo_path(root, source_value, field="source")
    if source_value_path.is_file():
        source_root = source_value_path.parent
        candidates = [source_value_path] if source_value_path.suffix.lower() in extensions else []
    elif source_value_path.is_dir():
        source_root = source_value_path
        candidates = [candidate for candidate in source_root.rglob("*") if candidate.is_file() and candidate.suffix.lower() in extensions]
    else:
        raise DesignImportError(f"Source absente: {source_value}")
    existing = {entry["source_path"]: entry for entry in registry["designs"]}
    changed = False
    for source in sorted(candidates, key=lambda item: item.as_posix()):
        source_relative = relative_path(root, source)
        discovered = base_entry(root, lot_id, source, source_root, target_root, license_status, contracts, validation_commands)
        old = existing.get(source_relative)
        if old is None:
            registry["designs"].append(discovered)
            changed = True
            continue
        if old["design_id"] != discovered["design_id"] or old["lot_id"] != lot_id:
            raise DesignImportError(f"Source déjà enregistrée avec une identité différente: {source_relative}")
        if old["source_hash"] != discovered["source_hash"]:
            if old["design_status"] in {"approuve", "archive", "importe", "valide"}:
                raise DesignImportError(f"Dérive approuvée: {old['design_id']}; nouvelle approbation requise")
            old["source_hash"] = discovered["source_hash"]
            old["source_version"] = str(int(old["source_version"]) + 1) if old["source_version"].isdigit() else "1"
            changed = True
        if old["target_paths"] != discovered["target_paths"]:
            if old["design_status"] not in {"detecte", "precontrole_ok"}:
                raise DesignImportError(f"Destination modifiée après décision: {old['design_id']}")
            old["target_paths"] = discovered["target_paths"]
            changed = True
        for field in ("contracts", "validation_commands", "license_status"):
            if old[field] != discovered[field]:
                if old["design_status"] not in {"detecte", "precontrole_ok"}:
                    raise DesignImportError(f"Métadonnée modifiée après décision: {old['design_id']}")
                old[field] = discovered[field]
                changed = True
    registry["designs"].sort(key=lambda entry: entry["design_id"])
    return changed


def registry_digest(registry: dict[str, Any]) -> str:
    execution_fields = {"design_status", "archive_run_id", "integration_status", "last_validated_at"}
    designs = []
    for entry in registry["designs"]:
        stable = {key: value for key, value in entry.items() if key not in execution_fields}
        stable["decision"] = None
        stable["decision_at"] = None
        designs.append(stable)
    stable = {"schema_version": registry["schema_version"], "designs": designs}
    return hashlib.sha256(canonical_json(stable)).hexdigest()


def build_plan(registry: dict[str, Any], root: Path, run_id: str) -> dict[str, Any]:
    if not re.fullmatch(r"[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{6}Z_[a-z0-9._-]+_[0-9a-f]{8,64}", run_id):
        raise DesignImportError(f"run_id invalide: {run_id}")
    designs = []
    for entry in sorted(registry["designs"], key=lambda value: value["design_id"]):
        if entry["design_status"] == "a_revoir":
            continue
        current_hashes = []
        for target in entry["target_paths"]:
            target_path = repo_path(root, target, field="target_paths")
            current_hashes.append({"path": target, "hash": sha256_file(target_path) if target_path.exists() else None})
        designs.append({
            "design_id": entry["design_id"], "source_path": entry["source_path"],
            "source_hash": entry["source_hash"], "target_paths": entry["target_paths"],
            "target_hashes": current_hashes, "action": entry["action"],
            "design_status": entry["design_status"], "decision": entry["decision"],
        })
    return {"schema_version": SCHEMA_VERSION, "run_id": run_id, "registry_sha256": registry_digest(registry), "designs": designs}


def load_plan(path: Path, root: Path) -> dict[str, Any]:
    plan = load_json(path)
    required = {"schema_version", "run_id", "registry_sha256", "designs"}
    if set(plan) != required or plan["schema_version"] != SCHEMA_VERSION or not isinstance(plan["designs"], list):
        raise DesignImportError("Plan invalide")
    if not re.fullmatch(r"[0-9a-f]{64}", plan["registry_sha256"]):
        raise DesignImportError("Plan: empreinte de registre invalide")
    for item in plan["designs"]:
        if not isinstance(item, dict):
            raise DesignImportError("Plan: design invalide")
        for target in item.get("target_paths", []):
            repo_path(root, target, field="plan.target_paths")
    return plan


def plan_entries(registry: dict[str, Any], plan: dict[str, Any]) -> Iterable[tuple[dict[str, Any], dict[str, Any]]]:
    by_id = {entry["design_id"]: entry for entry in registry["designs"]}
    if plan["registry_sha256"] != registry_digest(registry):
        raise DesignImportError("Plan obsolète: le registre a changé")
    for planned in plan["designs"]:
        entry = by_id.get(planned.get("design_id"))
        if entry is None or planned.get("source_hash") != entry["source_hash"]:
            raise DesignImportError("Plan obsolète: design ou empreinte modifié")
        yield entry, planned


def approved_for_apply(entry: dict[str, Any]) -> bool:
    return entry["design_status"] == "archive" and entry["decision"] == "approuve"


def recovery_path(root: Path) -> Path:
    return root / "_docs" / "design_imports" / ".recovery.json"


def write_recovery(root: Path, operation: str, run_id: str, completed: list[str]) -> None:
    atomic_write(recovery_path(root), canonical_json({"operation": operation, "run_id": run_id, "completed_design_ids": completed}))


def archive(registry: dict[str, Any], root: Path, plan: dict[str, Any], registry_path: Path) -> dict[str, Any]:
    archive_root = root / "archives" / "design_imports" / plan["run_id"]
    manifest_path = archive_root / "manifest.json"
    manifest: list[dict[str, Any]] = []
    already_archived = 0
    for entry, planned in plan_entries(registry, plan):
        if entry["design_status"] == "a_revoir":
            continue
        if entry["design_status"] == "archive" and entry["archive_run_id"] == plan["run_id"]:
            already_archived += 1
            continue
        if entry["design_status"] != "approuve" or entry["decision"] != "approuve":
            raise DesignImportError(f"Archivage interdit sans approbation: {entry['design_id']}")
        for target in planned["target_paths"]:
            destination = repo_path(root, target, field="target_paths")
            archived = archive_root / target
            exists = destination.exists()
            if exists:
                archived.parent.mkdir(parents=True, exist_ok=True)
                if not archived.exists():
                    shutil.copy2(destination, archived)
                if sha256_file(destination) != sha256_file(archived):
                    raise DesignImportError(f"Archive corrompue: {target}")
            manifest.append({"design_id": entry["design_id"], "target_path": target, "original_exists": exists, "sha256": sha256_file(destination) if exists else None, "size": destination.stat().st_size if exists else 0})
        transition(entry, "archive")
        entry["archive_run_id"] = plan["run_id"]
    if already_archived and not manifest:
        existing_manifest = load_json(manifest_path)
        return {"archive": relative_path(root, manifest_path), "files": len(existing_manifest.get("files", []))}
    atomic_write(manifest_path, canonical_json({"schema_version": SCHEMA_VERSION, "run_id": plan["run_id"], "files": manifest}))
    registry["updated_at"] = now_utc()
    save_registry(registry_path, registry, root)
    return {"archive": relative_path(root, manifest_path), "files": len(manifest)}


def apply(registry: dict[str, Any], root: Path, plan: dict[str, Any], registry_path: Path) -> dict[str, Any]:
    completed: list[str] = []
    write_recovery(root, "apply", plan["run_id"], completed)
    for entry, planned in plan_entries(registry, plan):
        if entry["design_status"] == "a_revoir":
            continue
        source = repo_path(root, entry["source_path"], field="source_path")
        if not source.exists() or sha256_file(source) != entry["source_hash"]:
            raise DesignImportError(f"Dérive source détectée: {entry['design_id']}")
        if not planned["target_paths"]:
            raise DesignImportError(f"Destination inconnue: {entry['design_id']}")
        if entry["design_status"] in {"importe", "valide"}:
            if all(repo_path(root, target, field="target_paths").exists() and sha256_file(repo_path(root, target, field="target_paths")) == entry["source_hash"] for target in planned["target_paths"]):
                completed.append(entry["design_id"])
                write_recovery(root, "apply", plan["run_id"], completed)
                continue
            raise DesignImportError(f"État d'import incohérent: {entry['design_id']}")
        if not approved_for_apply(entry):
            raise DesignImportError(f"Application interdite sans archive approuvée: {entry['design_id']}")
        for target in planned["target_paths"]:
            destination = repo_path(root, target, field="target_paths")
            destination.parent.mkdir(parents=True, exist_ok=True)
            temporary = destination.with_name(f".{destination.name}.design-import")
            shutil.copyfile(source, temporary)
            if sha256_file(temporary) != entry["source_hash"]:
                temporary.unlink(missing_ok=True)
                raise DesignImportError(f"Copie invalide: {entry['design_id']}")
            os.replace(temporary, destination)
        transition(entry, "importe")
        entry["integration_status"] = "importe"
        registry["updated_at"] = now_utc()
        save_registry(registry_path, registry, root)
        completed.append(entry["design_id"])
        write_recovery(root, "apply", plan["run_id"], completed)
    recovery_path(root).unlink(missing_ok=True)
    return {"applied": len(completed)}


def verify(registry: dict[str, Any], root: Path, registry_path: Path) -> dict[str, Any]:
    verified = 0
    for entry in registry["designs"]:
        if entry["design_status"] != "importe":
            continue
        source = repo_path(root, entry["source_path"], field="source_path")
        if not source.exists() or sha256_file(source) != entry["source_hash"]:
            raise DesignImportError(f"Dérive source détectée: {entry['design_id']}")
        if not entry["target_paths"]:
            raise DesignImportError(f"Destination inconnue: {entry['design_id']}")
        if any(not repo_path(root, target, field="target_paths").exists() or sha256_file(repo_path(root, target, field="target_paths")) != entry["source_hash"] for target in entry["target_paths"]):
            raise DesignImportError(f"Vérification échouée: {entry['design_id']}")
        transition(entry, "valide")
        entry["integration_status"] = "valide"
        entry["last_validated_at"] = now_utc()
        verified += 1
    if verified:
        registry["updated_at"] = now_utc()
        save_registry(registry_path, registry, root)
    return {"verified": verified}


def approve(registry: dict[str, Any], root: Path, plan_path: Path, expected_plan_hash: str, registry_path: Path) -> dict[str, Any]:
    if not re.fullmatch(r"[0-9a-f]{64}", expected_plan_hash):
        raise DesignImportError("Empreinte de plan invalide")
    if sha256_file(plan_path) != expected_plan_hash:
        raise DesignImportError("Empreinte de plan différente de l'approbation utilisateur")
    plan = load_plan(plan_path, root)
    approved = 0
    retained = 0
    for entry, _ in plan_entries(registry, plan):
        if entry["design_status"] == "precontrole_ok":
            transition(entry, "approuve")
            entry["decision"] = "approuve"
            entry["decision_at"] = now_utc()
            approved += 1
        elif entry["design_status"] in {"approuve", "a_revoir"}:
            retained += 1
        else:
            raise DesignImportError(f"Approbation interdite depuis {entry['design_status']}: {entry['design_id']}")
    registry["updated_at"] = now_utc()
    save_registry(registry_path, registry, root)
    return {"approved": approved, "retained": retained, "run_id": plan["run_id"], "plan_sha256": expected_plan_hash}


def rollback(registry: dict[str, Any], root: Path, run_id: str, registry_path: Path) -> dict[str, Any]:
    manifest_path = root / "archives" / "design_imports" / run_id / "manifest.json"
    manifest = load_json(manifest_path)
    if manifest.get("run_id") != run_id or not isinstance(manifest.get("files"), list):
        raise DesignImportError("Manifeste d'archive invalide")
    by_id = {entry["design_id"]: entry for entry in registry["designs"]}
    restored = 0
    for item in manifest["files"]:
        entry = by_id.get(item.get("design_id"))
        target = item.get("target_path")
        if entry is None or not isinstance(target, str):
            raise DesignImportError("Manifeste d'archive incohérent")
        destination = repo_path(root, target, field="manifest.target_path")
        archived = manifest_path.parent / target
        if item.get("original_exists"):
            if not archived.exists() or sha256_file(archived) != item.get("sha256"):
                raise DesignImportError(f"Archive introuvable ou corrompue: {target}")
            destination.parent.mkdir(parents=True, exist_ok=True)
            temporary = destination.with_name(f".{destination.name}.design-rollback")
            shutil.copyfile(archived, temporary)
            os.replace(temporary, destination)
        else:
            destination.unlink(missing_ok=True)
        if entry["design_status"] != "retour_arriere":
            transition(entry, "retour_arriere")
        entry["integration_status"] = "retour_arriere"
        restored += 1
    registry["updated_at"] = now_utc()
    save_registry(registry_path, registry, root)
    return {"restored": restored}


def report(registry: dict[str, Any]) -> dict[str, Any]:
    counts = {status: 0 for status in sorted(ALLOWED_STATUSES)}
    for entry in registry["designs"]:
        counts[entry["design_status"]] += 1
    return {"schema_version": SCHEMA_VERSION, "registry_sha256": registry_digest(registry), "total": len(registry["designs"]), "statuses": counts}


def command_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(description="Import reproductible des designs Nox Protocol")
    parser.add_argument("--repo", type=Path, default=Path.cwd())
    parser.add_argument("--registry", type=Path, default=Path("_docs/design_imports/registry.json"))
    subcommands = parser.add_subparsers(dest="command", required=True)
    scan_parser = subcommands.add_parser("scan")
    scan_parser.add_argument("--lot", required=True)
    scan_parser.add_argument("--source", required=True)
    scan_parser.add_argument("--target")
    scan_parser.add_argument("--extensions", default=",".join(sorted(DEFAULT_EXTENSIONS)))
    scan_parser.add_argument("--license-status", default="proprietaire")
    scan_parser.add_argument("--contract", action="append", default=[])
    scan_parser.add_argument("--validation-command", action="append", default=[])
    preflight_parser = subcommands.add_parser("preflight")
    preflight_parser.add_argument("--design-id", action="append")
    inventory_parser = subcommands.add_parser("inventory")
    inventory_parser.add_argument("--run-id", required=True)
    inventory_parser.add_argument("--output", type=Path, required=True)
    inventory_parser.add_argument("--plan-output", type=Path, required=True)
    approve_parser = subcommands.add_parser("approve")
    approve_parser.add_argument("--plan", type=Path, required=True)
    approve_parser.add_argument("--plan-sha256", required=True)
    plan_parser = subcommands.add_parser("plan")
    plan_parser.add_argument("--run-id", required=True)
    plan_parser.add_argument("--output", type=Path, required=True)
    archive_parser = subcommands.add_parser("archive")
    archive_parser.add_argument("--plan", type=Path, required=True)
    apply_parser = subcommands.add_parser("apply")
    apply_parser.add_argument("--plan", type=Path, required=True)
    subcommands.add_parser("verify")
    rollback_parser = subcommands.add_parser("rollback")
    rollback_parser.add_argument("--run-id", required=True)
    report_parser = subcommands.add_parser("report")
    report_parser.add_argument("--output", type=Path)
    return parser


def main(argv: list[str] | None = None) -> int:
    args = command_parser().parse_args(argv)
    root = args.repo.resolve()
    registry_path = args.registry if args.registry.is_absolute() else root / args.registry
    if not is_within(registry_path, root):
        raise DesignImportError("Registre hors dépôt")
    registry = load_registry(registry_path, root)
    if args.command == "scan":
        extensions = {value.strip().lower() for value in args.extensions.split(",") if value.strip()}
        changed = scan(registry, root, args.lot, args.source, args.target, extensions, args.license_status, args.contract, args.validation_command)
        if changed:
            registry["updated_at"] = now_utc()
            save_registry(registry_path, registry, root)
        result: dict[str, Any] = {"changed": changed, "total": len(registry["designs"]), "registry_sha256": registry_digest(registry)}
    elif args.command == "preflight":
        selected = set(args.design_id or [entry["design_id"] for entry in registry["designs"]])
        count = 0
        for entry in registry["designs"]:
            if entry["design_id"] not in selected:
                continue
            source = repo_path(root, entry["source_path"], field="source_path")
            if not source.exists() or sha256_file(source) != entry["source_hash"]:
                raise DesignImportError(f"Précontrôle échoué: {entry['design_id']}")
            if entry["design_status"] == "detecte":
                transition(entry, "precontrole_ok")
                count += 1
        if count:
            registry["updated_at"] = now_utc()
            save_registry(registry_path, registry, root)
        result = {"precontrolled": count}
    elif args.command == "inventory":
        inventory = build_inventory(registry, root, args.run_id)
        output = args.output if args.output.is_absolute() else root / args.output
        plan_output = args.plan_output if args.plan_output.is_absolute() else root / args.plan_output
        if not is_within(output, root) or not is_within(plan_output, root):
            raise DesignImportError("Inventaire ou plan hors dépôt")
        atomic_write(output, canonical_json(inventory))
        atomic_write(plan_output, render_plan_markdown(inventory).encode("utf-8"))
        result = {"inventory": relative_path(root, output), "plan": relative_path(root, plan_output), "designs": len(inventory["designs"]), "classifications": inventory["classification_counts"]}
    elif args.command == "approve":
        plan_path = args.plan if args.plan.is_absolute() else root / args.plan
        if not is_within(plan_path, root):
            raise DesignImportError("Plan hors dépôt")
        result = approve(registry, root, plan_path, args.plan_sha256, registry_path)
    elif args.command == "plan":
        plan = build_plan(registry, root, args.run_id)
        output = args.output if args.output.is_absolute() else root / args.output
        if not is_within(output, root):
            raise DesignImportError("Plan hors dépôt")
        atomic_write(output, canonical_json(plan))
        result = {"plan": relative_path(root, output), "designs": len(plan["designs"])}
    elif args.command == "archive":
        plan = load_plan(args.plan if args.plan.is_absolute() else root / args.plan, root)
        result = archive(registry, root, plan, registry_path)
    elif args.command == "apply":
        plan = load_plan(args.plan if args.plan.is_absolute() else root / args.plan, root)
        result = apply(registry, root, plan, registry_path)
    elif args.command == "verify":
        result = verify(registry, root, registry_path)
    elif args.command == "rollback":
        result = rollback(registry, root, args.run_id, registry_path)
    else:
        result = report(registry)
        if args.output:
            output = args.output if args.output.is_absolute() else root / args.output
            if not is_within(output, root):
                raise DesignImportError("Rapport hors dépôt")
            atomic_write(output, canonical_json(result))
    print(json.dumps(result, ensure_ascii=False, sort_keys=True))
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except DesignImportError as error:
        print(f"ÉCHEC: {error}", file=sys.stderr)
        raise SystemExit(2)
