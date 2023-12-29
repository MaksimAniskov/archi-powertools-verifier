import argparse
import xml.etree.ElementTree as ET
import csv


def __init_cli() -> argparse:
    parser = argparse.ArgumentParser(
        description="archixml2csv - convert The Archimate Tool's model file (.archimate extension) to set of CSV files"
    )

    parser.add_argument("archixml_file_name")

    return parser


def exportSubFolders(
    parent_node: ET,
    parent_id,
    hierarchy_type,
    csv_writer_folders,
    csv_writer_folder_content,
):
    for f in parent_node.findall("./folder"):
        csv_writer_folders.writerow(
            [
                f.get("id"),
                hierarchy_type,
                f.get("name"),
                parent_id,
                "",  # TODO: Documentation
            ]
        )

        for e in f.findall("./element"):
            csv_writer_folder_content.writerow(
                [
                    f.get("id"),
                    e.get("id"),
                ]
            )

        exportSubFolders(
            f,
            f.get("id"),
            hierarchy_type,
            csv_writer_folders,
            csv_writer_folder_content,
        )


def main():
    __cli_args = __init_cli().parse_args()

    tree = ET.parse(__cli_args.archixml_file_name)
    root = tree.getroot()

    f_elements = None
    f_relations = None
    f_properties = None
    f_views = None
    f_view_content = None
    f_folders = None
    f_folder_content = None
    try:
        f_elements = open("elements.csv", "w", encoding="UTF8")
        f_relations = open("relations.csv", "w", encoding="UTF8")
        f_properties = open("properties.csv", "w", encoding="UTF8")

        csv_writer_elements = csv.writer(f_elements, quoting=csv.QUOTE_NONNUMERIC)
        csv_writer_elements.writerow(
            ["ID", "Type", "Name", "Documentation", "Specialization"]
        )

        csv_writer_relations = csv.writer(f_relations, quoting=csv.QUOTE_NONNUMERIC)
        csv_writer_relations.writerow(
            [
                "ID",
                "Type",
                "Name",
                "Documentation",
                "Source",
                "Target",
                "Specialization",
            ]
        )

        csv_writer_properties = csv.writer(f_properties, quoting=csv.QUOTE_NONNUMERIC)
        csv_writer_properties.writerow(["ID", "Key", "Value"])

        f_views = open("views.csv", "w", encoding="UTF8")
        f_view_content = open("view-content.csv", "w", encoding="UTF8")

        csv_writer_views = csv.writer(f_views, quoting=csv.QUOTE_NONNUMERIC)
        csv_writer_views.writerow(["ID", "Name", "Documentation"])

        csv_writer_view_content = csv.writer(
            f_view_content, quoting=csv.QUOTE_NONNUMERIC
        )
        csv_writer_view_content.writerow(["ViewID", "ObjectID"])

        f_folders = open("folders.csv", "w", encoding="UTF8")
        f_folder_content = open("folder-content.csv", "w", encoding="UTF8")

        csv_writer_folders = csv.writer(f_folders, quoting=csv.QUOTE_NONNUMERIC)
        csv_writer_folders.writerow(["ID", "Type", "Name", "Parent", "Documentation"])

        csv_writer_folder_content = csv.writer(
            f_folder_content, quoting=csv.QUOTE_NONNUMERIC
        )
        csv_writer_folder_content.writerow(["FolderID", "ObjectID"])

        for e in root.iter("element"):
            type = e.get("{http://www.w3.org/2001/XMLSchema-instance}type").replace(
                "archimate:", ""
            )
            if type.endswith("Relationship"):
                specialization = root.find(
                    './profile[@id="{}"]'.format(e.get("profiles"))
                )
                if specialization is not None:
                    specialization = specialization.get("name")

                csv_writer_relations.writerow(
                    [
                        e.get("id"),
                        type.replace("Relationship", ""),
                        e.get("name"),
                        "",  # TODO: Documentation
                        e.get("source"),
                        e.get("target"),
                        specialization,
                    ]
                )

                if type == "AccessRelationship":
                    access_type = "Write"
                    match e.get("accessType"):
                        case "1":
                            access_type = "Read"
                        case "3":
                            access_type = "ReadWrite"
                    csv_writer_properties.writerow(
                        [e.get("id"), "Access_Type", access_type]
                    )

            elif type == "ArchimateDiagramModel":  # View
                csv_writer_views.writerow(
                    [e.get("id"), e.get("name"), ""]  # TODO: Documentation
                )
                for c in e.iter("child"):
                    csv_writer_view_content.writerow(
                        [e.get("id"), c.get("archimateElement")]
                    )
                for sc in e.iter("sourceConnection"):
                    csv_writer_view_content.writerow(
                        [e.get("id"), sc.get("archimateRelationship")]
                    )

            else:  # Element
                if type == "Junction":
                    continue
                if type == "ArchimateDiagramModel":
                    continue

                specialization = root.find(
                    './profile[@id="{}"]'.format(e.get("profiles"))
                )
                if specialization is not None:
                    specialization = specialization.get("name")

                csv_writer_elements.writerow(
                    [
                        e.get("id"),
                        type,
                        e.get("name"),
                        "",  # TODO: Documentation
                        specialization,
                    ]
                )

            for p in e.iter("property"):
                csv_writer_properties.writerow(
                    [e.get("id"), p.get("key"), p.get("value")]
                )

        for f in root.findall("./folder"):
            hierarchy_type = f.get("type")
            if hierarchy_type == "diagrams":
                hierarchy_type = "views"
            exportSubFolders(
                f, None, hierarchy_type, csv_writer_folders, csv_writer_folder_content
            )

    finally:
        if f_elements:
            f_elements.close()
        if f_relations:
            f_relations.close()
        if f_properties:
            f_properties.close()
        if f_views:
            f_views.close()
        if f_view_content:
            f_view_content.close()
        if f_folders:
            f_folders.close()
        if f_folder_content:
            f_folder_content.close()


if __name__ == "__main__":  # pragma: no cover
    main()
